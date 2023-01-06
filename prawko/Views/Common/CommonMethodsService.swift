//
//  CommonMethodsService.swift
//  prawko
//
//  Created by Jakub Klentak on 06/01/2023.
//

import Foundation

public func formatDate(date: String, formatFrom: String, formatTo: String)-> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formatFrom
    
    return dateFormatter.date(from: date)!.getFormattedDate(format: formatTo)
}
