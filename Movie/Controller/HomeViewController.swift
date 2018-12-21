//
//  Home.swift
//  Movie
//
//  Created by Mac-0004 on 19/12/18.
//  Copyright © 2018 0002. All rights reserved.
//

import UIKit
import ScalingCarousel
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    // MARK: -
    // MARK: - @IBOutlets.
    @IBOutlet fileprivate weak var carouselMovie: ScalingCarouselView! {
        didSet {
            carouselMovie.inset = CScreenWidth / 5.0
            self.carouselMovie.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }
    }
    
    @IBOutlet fileprivate weak var lblMovieName: UILabel!
    @IBOutlet fileprivate weak var lblMovieType: UILabel!
    @IBOutlet fileprivate weak var viewLabels: UIView!
    @IBOutlet fileprivate weak var activityLoader: UIActivityIndicatorView!
    
    // MARK: -
    // MARK: - Global Variables.
    fileprivate var autoScrollTimer: Timer?
    fileprivate var disposeBag = DisposeBag()
    
    fileprivate var nextIndex:Int? {
        
        if let currentIndex = carouselMovie.currentCenterCellIndex?.row {
            return (currentIndex + 1 ) % MovieViewModel.shared.arrMoviesCount
        }
        return nil
    }
    
    // MARK: -
    // MARK: - View Lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
        initalize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //.. Reset Timer when came back from search screen. Its not good to enable auto-scroll when left this screen. On came back user is able to see their's last seen Movie.
        MovieViewModel.shared.needToStartTimer.value = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //.. Stop Timer when left this screen. Its good to stop auto-scroll when left this screen.
        MovieViewModel.shared.needToStartTimer.value = false
    }
}

// MARK: -
// MARK: - General Methods.
extension HomeViewController  {
    
    fileprivate func initalize() {
        configureViewAppearance()
    }
    
    fileprivate func configureViewAppearance() {
        MovieViewModel.shared.loadMovies()
        //.. Add Necessary Observer and Subscriber.
        addObserverAndSubscriber()
    }
    
    fileprivate func addObserverAndSubscriber() {
        
        //.. Keep Observing for Timer Valid/Invalid State.
        MovieViewModel.shared.needToStartTimer.asObservable().subscribe(onNext: { (needToStartTimer) in
            if MovieViewModel.shared.arrMoviesCount > 0 {
                needToStartTimer ? self.initializeTimer() : self.resetTimer()
                //.. Code will be executed only once. Consider it as initial level setup.
                if self.activityLoader.isAnimating {
                    self.activityLoader.stopAnimating()
                    UIView.animate(withDuration: 0.3, animations: {
                        self.carouselMovie.transform = .identity
                        self.viewLabels.alpha += 1
                    })
                    self.showMovieDetails(index: 0)
                }
            }
        }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
        
        
        //.. Keep Observing for ArrMovies Updates and Bind the Data.
        MovieViewModel.shared.arrMovies.asObservable().bind(to: self.carouselMovie.rx.items(cellIdentifier: "HomeCell", cellType: HomeCell.self)) { (row , movieDetails , cell) in
            //... Configure each-every cell.
            cell.configureCell(movieDetails: movieDetails)
            }.disposed(by: disposeBag)
        
        
        //.. Keep Observing for scrollView's Begin Dragging Updates for stoping the auto-scroll.
        carouselMovie.rx.willBeginDragging.subscribe(onNext: { (_) in
            MovieViewModel.shared.needToStartTimer.value = false
        }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
        
        
        //.. Keep Observing for scrollView's End Decelerating Updates for reset the auto-scroll & Showing Movie-Details.
        carouselMovie.rx.didEndDecelerating.subscribe(onNext: { (_) in
            MovieViewModel.shared.needToStartTimer.value = true
            if let nextIndex = self.carouselMovie.currentCenterCellIndex?.row {
                self.carouselMovie.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredVertically, animated: true)
                self.showMovieDetails(index: nextIndex)
            }
        }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
    }
    
    fileprivate func initializeTimer() {
        if autoScrollTimer == nil {
            self.autoScrollTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
        }
    }
    
    fileprivate func resetTimer() {
        if let autoScrollTimer = self.autoScrollTimer , autoScrollTimer.isValid {
            self.autoScrollTimer?.invalidate()
            self.autoScrollTimer = nil
        }
    }
    
    fileprivate func showMovieDetails(index:Int) {
        lblMovieName.text = MovieViewModel.shared.showMovieDetails(index: index).strName
        lblMovieType.text = MovieViewModel.shared.showMovieDetails(index: index).strType
    }
}

// MARK: -
// MARK: - Selector Methods.
extension HomeViewController {
    
    @objc fileprivate func autoScroll() {
        if let nextIndex = nextIndex {
            carouselMovie.scrollToItem(at: IndexPath(item: nextIndex, section: 0), at: .centeredVertically, animated: true)
            showMovieDetails(index: nextIndex)
        }
    }
}

// MARK: -
// MARK: - @IBActions.
extension HomeViewController  {
    
    @IBAction fileprivate func btnSearchTapped(sender:UIBarButtonItem) {
        if let naviSearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchNavigation") as? UINavigationController {
            self.navigationController?.present(naviSearchVC, animated: true, completion: nil)
        }
    }
}
