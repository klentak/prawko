//
//  DateExtensions.swift
//  prawko
//
//  Created by Jakub Klentak on 04/01/2023.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformater = DateFormatter()
       dateformater.dateFormat = format
    
        return dateformater.string(from: self)
    }
}
