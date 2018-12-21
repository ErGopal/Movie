//
//  MovieViewModel.swift
//  Movie
//
//  Created by mac-0002 on 20/12/18.
//  Copyright © 2018 mac-0002. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class MovieListViewModel {
    
    // MARK: -
    // MARK: - Singleton.
    private init() {}
    
    private static var movieListViewModel:MovieListViewModel = {
        let movieListViewModel = MovieListViewModel()
        return movieListViewModel
    }()
    
    static var shared:MovieListViewModel {
        return movieListViewModel
    }
    
    // MARK: -
    // MARK: - Rx-Swift Observable.
    var arrShowingMovies:Variable<[MovieDetails]> = Variable([])
    var arrNewMovies:Variable<[MovieDetails]> = Variable([])
    var arrMovies:Variable<[MovieDetails]> = Variable([])
    var isLoading:Variable<Bool> = Variable(true)
    
    // MARK: -
    // MARK: - Global Variables.
    
    //.. Future reference for load More.
    fileprivate var offset = 0
    
    var arrShowingMoviesCount:Int {
        return self.arrShowingMovies.value.count
    }
    
    var arrNewMoviesCount:Int {
        return self.arrNewMovies.value.count
    }
}

extension MovieListViewModel {
    
    func loadSearchMovies(keyword:String) {
        
        _ = APIRequest.shared.searchMovies(keyword: keyword, offset: 0, successCompletion: { (response, status) in
            
            if let resultDict = response as? [String:Any] {
                
                if let arrShowingMovies = resultDict["showing"] as? [[String:Any]] , arrShowingMovies.count > 0 {
                    self.arrShowingMovies.value = Mapper<MovieDetails>().mapArray(JSONArray: arrShowingMovies)
                }
                
                if let arrUpcomingMovies = resultDict["upcoming"] as? [[String:Any]] , arrUpcomingMovies.count > 0 {
                    self.arrNewMovies.value = Mapper<MovieDetails>().mapArray(JSONArray: arrUpcomingMovies)
                }
                
                self.isLoading.value = false
                
                self.offset += 1
            }
        }, failureCompletion: { (message) in
            self.isLoading.value = false
        })
    }
}
