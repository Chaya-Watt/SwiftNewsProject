//
//  NewsAPIModel.swift
//  NewsProject
//
//  Created by Gene MBS on 3/10/2565 BE.
//

import Foundation

struct NewsAPIData: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleAPIData]
}

struct ArticleAPIData: Codable {
    let source: SourceAPIData
    let author : String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct SourceAPIData:Codable {
    let id: String?
    let name: String?
}
