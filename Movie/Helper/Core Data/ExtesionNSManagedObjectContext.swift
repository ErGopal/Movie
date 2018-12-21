//
//  ExtesionNSManagedObjectContext.swift
//  Movie
//
//  Created by mac-0002 on 19/12/18.
//  Copyright © 2018 Er.Gopal Vasani. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func saveChanges() {
        if self.hasChanges {
            do { try save() }
            catch { print("Error while saving the Single Change into NSManagedObjectContext :- \(error.localizedDescription)") }
        }
    }
}

