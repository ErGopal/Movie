//
//  MovieViewModel.swift
//  Movie
//
//  Created by mac-0002 on 21/12/18.
//  Copyright © 2018 mac-0002. All rights reserved.
//

import Foundation
import RxSwift

class MovieViewModel {
    
    // MARK: -
    // MARK: - Singleton.
    private init() {}
    
    private static var movieViewModel:MovieViewModel = {
        let movieViewModel = MovieViewModel()
        return movieViewModel
    }()
    
    static var shared:MovieViewModel {
        return movieViewModel
    }
    
    // MARK: -
    // MARK: - Rx-Swift Observable.
    var arrMovies:Variable<[MovieDetails]> = Variable([])
    var needToStartTimer:Variable<Bool> = Variable(false)
    
    // MARK: -
    // MARK: - Global Variables.
    var arrMoviesCount:Int {
        return self.arrMovies.value.count
    }
}

// MARK: -
// MARK: - General Methods.
extension MovieViewModel {
    
    func loadMovies() {
        _ = APIRequest.shared.movies(successCompletion: { (response, status) in
            if let movie = response as? Movie , let results = movie.results , results.count > 0 {
                self.arrMovies.value = results
                self.needToStartTimer.value = true
            }
        }, failureCompletion: nil)
    }
    
    func showMovieDetails(index:Int) -> (strName:String , strType:String) {
        let movieDetails = arrMovies.value[index]
        return (movieDetails.title ?? "" , movieDetails.movieType)
    }
}


