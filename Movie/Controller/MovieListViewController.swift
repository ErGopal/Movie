//
//  MovieListViewController.swift
//  Movie
//
//  Created by mac-0005 on 19/12/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper

class MovieListViewController: UIViewController {

    // MARK: -
    // MARK: - @IBOutlets.
    @IBOutlet fileprivate var tblMovieList : UITableView! {
        didSet {
            tblMovieList.estimatedRowHeight = 50.0
            tblMovieList.rowHeight = UITableView.automaticDimension
        }
    }
    
    @IBOutlet fileprivate var btnNowShowing : UIButton!
    @IBOutlet fileprivate var btnComingSoon : UIButton!
    @IBOutlet fileprivate var cnSegmentViewLeadingSpace : NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var activityLoader: UIActivityIndicatorView!
    
    // MARK: -
    // MARK: - Global Variables.
    var keyword = ""
    let disposeBag = DisposeBag()
    
    // MARK: -
    // MARK: - View Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        initalize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.tintColor = .black
    }
}

// MARK: -
// MARK: - General Methods.
extension MovieListViewController {
    
    fileprivate func initalize() {
        configureViewAppearance()
    }
    
    fileprivate func configureViewAppearance() {
        MovieListViewModel.shared.loadSearchMovies(keyword: keyword)
        //.. Add Necessary Observer and Subscriber.
        addObserverAndSubscriber()
    }
    
    fileprivate func addObserverAndSubscriber() {
        //.. Keep Observing isLoading Updates For ActivityIndicator.
        MovieListViewModel.shared.isLoading.asObservable().subscribe(onNext: { (isLoading) in
            
            if MovieListViewModel.shared.arrNewMoviesCount > 0 || MovieListViewModel.shared.arrShowingMoviesCount > 0 {
                self.activityLoader.stopAnimating()
            }
        }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
        
        //.. Default New Showing tab will be selected.
        MovieListViewModel.shared.arrNewMovies.asObservable().subscribe(onNext: { (arrNewMovies) in
            MovieListViewModel.shared.arrMovies.value = MovieListViewModel.shared.arrNewMovies.value
        }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
        
        //.. Keep Observing for ArrMovies Updates and Bind the Data.
        MovieListViewModel.shared.arrMovies.asObservable().bind(to: tblMovieList.rx.items(cellIdentifier: "MovieListTblCell", cellType:MovieListTblCell.self)) { (row, movieDetails, cell) in
            cell.configureCell(movieDetails: movieDetails)
        }.disposed(by: disposeBag)
    }
}

// MARK: -
// MARK: - @IBActions.
extension MovieListViewController {
    
    @IBAction fileprivate func btnSegmentTapped(sender:UIButton){
        
        if sender.isSelected {
            return
        }
        
        btnComingSoon.isSelected = false
        btnNowShowing.isSelected = false
        sender.isSelected = true
        
        var leadingConstant:CGFloat = 0.0
        
        switch sender.tag {
            
        case 0:
            MovieListViewModel.shared.arrMovies.value = MovieListViewModel.shared.arrNewMovies.value
            
        case 1:
            MovieListViewModel.shared.arrMovies.value = MovieListViewModel.shared.arrShowingMovies.value
            leadingConstant = CScreenCenterX
            
        default:
            break;
        }
        
        self.cnSegmentViewLeadingSpace.constant = leadingConstant
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            self.tblMovieList.reloadData()
        }
    }
}
