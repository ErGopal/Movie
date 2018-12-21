//
//  SearchViewModel.swift
//  Movie
//
//  Created by Mac-0004 on 21/12/18.
//  Copyright © 2018 mac-0002. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    let textOrDeleteObj:Variable<Any?> = Variable("")
    
    lazy var data: Driver<[TblSearchHistory]> = {
        return self.textOrDeleteObj.asObservable()
            .flatMapLatest(SearchViewModel.historyBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    
    static func historyBy(_ textOrDeleteObj: Any) -> Observable<[TblSearchHistory]> {
        let searchlist = newHistory(object: textOrDeleteObj)
        return Observable.just(searchlist)
    }
    
    static func newHistory(object: Any) -> [TblSearchHistory] {
        
        var histories = TblSearchHistory.fetch(sortDescriptor: [NSSortDescriptor(key: "searchTime", ascending: false)]) as! [TblSearchHistory]
        
        if let serachObj = object as? TblSearchHistory {
            serachObj.delete()
            
            if let index = histories.firstIndex(of: serachObj) {
                histories.remove(at: index)
            }
            return histories
        }
        
        if let searchStr = object as? String {
            let item = ["searchKeyword" : searchStr , "searchTime" : Date().timeIntervalSince1970] as [String : Any]
            
            guard let searchKeyword = item["searchKeyword"] as? String, searchKeyword.count > 0 ,
                let searchTime = item["searchTime"] as? Double else {
                    return histories
            }
            
            let searchHistory = TblSearchHistory.findOrCreate(dict: ["searchKeyword":searchKeyword]) as! TblSearchHistory
            searchHistory.searchTime = searchTime
            
            if let existingIndex = histories.firstIndex(of: searchHistory) {
                histories.remove(at: existingIndex)
            }
            
            
            histories.insert(searchHistory, at: 0)
            //...it will records recently 10 times user search histories, latest search history should on top.
            if histories.count > 10 {
                histories.last?.delete()
                histories.removeLast()
            }
            
            CoreDataManager.shared.save()
        }
        return histories
    }
}

