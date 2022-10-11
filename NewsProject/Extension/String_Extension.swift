//
//  String_Extension.swift
//  NewsProject
//
//  Created by Gene MBS on 11/10/2565 BE.
//

import Foundation

extension String {
    func formatThaiDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: K.FormatDate.localIdentifier)
        dateFormatter.dateFormat = K.FormatDate.orginalFormat
        
        let date = dateFormatter.date(from: self)
        
        if let date = date {
            dateFormatter.dateFormat = K.FormatDate.resultFormat
            let resultDate = dateFormatter.string(from: date)
            
            return resultDate
        }
        else {
            return ""
        }
    }
}
