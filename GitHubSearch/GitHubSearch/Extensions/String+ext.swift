//
//  String+ext.swift
//  GitHubSearch
//
//  Created by Jinyung Yoon on 2021/10/21.
//

import Foundation

extension String {
    
    func converToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.converToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
