//
//  HistoryModel.swift
//  NewsProject
//
//  Created by Gene MBS on 3/10/2565 BE.
//

import Foundation

struct HistoryModel: Codable {
    let name: String
    let status: String
    let totalResults: Int
    let articles: [ArticleAPIData]
}
