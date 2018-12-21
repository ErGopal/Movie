//
//  Movie.swift
//  Movie
//
//  Created by mac-0002 on 20/12/18.
//  Copyright © 2018 mac-0002. All rights reserved.
//

import Foundation
import ObjectMapper

struct GenreIds : Mappable  {
    
    var id:String?
    var name:String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

struct MovieDetails : Mappable  {
    
    var id:String?
    var title:String?
    var age_category:String?
    var genre_ids:[GenreIds]?
    var rate:Float?
    var release_date:Int64?
    var poster_path:String?
    var presale_flag:Int?
    var description:String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        age_category <- map["age_category"]
        genre_ids <- map["genre_ids"]
        rate <- map["rate"]
        release_date <- map["release_date"]
        poster_path <- map["poster_path"]
        presale_flag <- map["presale_flag"]
        description <- map["description"]
    }
    
    var movieType:String {
        if let arrGenreIds = genre_ids {
            return arrGenreIds.map({$0.name ?? ""}).joined(separator: ",")
        }
        return ""
    }
    
    var strReleaseDate:String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMM yyyy"
        
        if let releaseDate = release_date {
            dateFormater.string(from: Date(timeIntervalSince1970: Double(releaseDate)))
        }
        return ""
    }
    
}

struct Movie : Mappable  {
    
    var results:[MovieDetails]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        results <- map["results"]
    }
}
