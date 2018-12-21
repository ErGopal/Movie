//
//  MovieSearchViewController.swift
//  Movie
//
//  Created by mac-0005 on 19/12/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieSearchViewController: UIViewController {
    
    // MARK: -
    // MARK: - @IBOutlets.
    @IBOutlet fileprivate weak var tblMovieList : UITableView!
    @IBOutlet fileprivate weak var searchBar : UISearchBar!
    
    // MARK: -
    // MARK: - Global Variables.
    var viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: -
    // MARK: - View Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar?.becomeFirstResponder()
        self.navigationController?.navigationBar.barTintColor = CRGB(r: 20, g: 32, b: 79)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    //MARK:-
    //MARK:- General Methods
    
    func initialization() {
        
        navigationItem.titleView = searchBar
        
        if let textfield = searchBar?.value(forKey: "searchField") as? UITextField {
            textfield.tintColor = UIColor.blue
            
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 18;
                backgroundview.clipsToBounds = true;
            }
        }
        
        //...RxDataModel of searchhistory
        viewModel.data
            .drive(tblMovieList.rx.items(cellIdentifier: "MovieListCell")) { _, repository, cell in
                cell.textLabel?.text = repository.searchKeyword
                cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
                cell.textLabel?.textColor = CRGB(r: 198, g: 198, b: 198)
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(tblMovieList.rx.itemSelected, tblMovieList.rx.modelSelected(TblSearchHistory.self))
            .bind { [unowned self] indexPath, model in
                self.moveToSearchScreen(searchString: model.searchKeyword!)
            }
            .disposed(by: disposeBag)
        
        Observable
            .zip(tblMovieList.rx.itemDeleted, tblMovieList.rx.modelDeleted(TblSearchHistory.self))
            .bind { [unowned self] indexPath, model in
                self.viewModel.textOrDeleteObj.value = model
                self.tblMovieList.deselectRow(at: indexPath, animated: true)
                
            }
            .disposed(by: disposeBag)
    }
    
    func moveToSearchScreen(searchString:String) {
//        if let movieListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieListViewController") as? MovieListViewController {
//            movieListVC.keyword = searchString
//            self.navigationController?.pushViewController(movieListVC, animated: true)
//        }
    }
}


// MARK:-
// MARK:- SearchBar Delegates
extension MovieSearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text , searchString.count > 0 {
            self.viewModel.textOrDeleteObj.value = searchString
            self.moveToSearchScreen(searchString: searchString)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
}


