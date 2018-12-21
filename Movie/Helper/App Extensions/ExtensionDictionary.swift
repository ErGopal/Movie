//
//  ExtensionDictionary.swift
//  Movie
//
//  Created by mac-0002 on 20/12/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

// MARK: - Extension of Dictionary For getting the different types of values from it.
extension Dictionary {
    
    /// This method is used to get the string value from the dictionary.
    ///
    /// - Parameter key: Pass the key for which you want to get the value.
    /// - Returns: return String value according to passed key.
    func stringFor(key:String) -> String {
        if let dictionary = self as? [String:Any] {
            return "\(dictionary[key] ?? "")"
        } else {
            return ""
        }
    }
}
