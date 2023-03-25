//
//  Date+Extension.swift
//  AstronomyWatch
//
//  Created by Sathish Kumar S on 26/03/23.
//

import Foundation

extension Date {
    
    static func getTodaysDateInAPIFriendlyFormat() -> String {
        var currentTimetsamp = Date().timeIntervalSince1970
        
        //Doing this to adjust for timezone difference, so API can always return an image
        currentTimetsamp = currentTimetsamp.advanced(by: -60*60*24*2)
        let currentDate = Date(timeIntervalSince1970: currentTimetsamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: currentDate)
    }
}
