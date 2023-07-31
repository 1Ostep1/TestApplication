//
//  Date+Extension.swift
//  TestApp
//
//  Created by Ramazan Iusupov on 27/7/23.
//

import Foundation

extension Date {
    enum DateFormat: String {
        case yyyyMMMMdd = "yyyy-MMMM-dd"
        case hhmmss = "HH:mm:ss"
        case hhmm = "HH:mm"
    }
    
    func format(format: DateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue

        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString) ?? Date()
        
        let formattedString = formatter
            .string(from: yourDate)
            .split(separator: "-")
            .joined(separator: " ")
        
        return formattedString
    }
}
