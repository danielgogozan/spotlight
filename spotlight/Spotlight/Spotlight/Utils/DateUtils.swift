//
//  DateUtils.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 08.03.2022.
//

import Foundation

final class DateUtils {
    
    static func defaultDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return  dateFormatter
    }
    
    static func timeFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return  dateFormatter
    }
    
    static func prettyDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm"
        return  dateFormatter
    }
    
    static func prettyArticleDate(for date: Date) -> String {
        let timeFormatter = timeFormatter()
        if Calendar.current.isDateInToday(date) {
            return L10n.today(timeFormatter.string(from: date))
        } else if Calendar.current.isDateInYesterday(date) {
            return L10n.yesterday(timeFormatter.string(from: date))
        }
        
        let prettyDateFormatter = prettyDateFormatter()
        return prettyDateFormatter.string(from: date)
    }
    
}
