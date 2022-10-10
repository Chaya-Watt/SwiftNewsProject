//
//  NewsAPICall.swift
//  NewsProject
//
//  Created by Gene MBS on 3/10/2565 BE.
//

import Foundation

protocol NewsAPICallDelegate {
    func updateHistoryTableView(history: HistoryModel)
    func updateArticlesTableView(articlesList: [ArticleAPIData])
}

struct NewsAPICall {
    
    var delegate: NewsAPICallDelegate?
    
    func fetchNews(searchNews: String, isUpdateHistory: Bool) {
        let urlString = "\(K.newsUrl)&q=\(searchNews)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    return
                } else {
                    if let wrapData = data {
                        do {
                            let decodeNews = try JSONDecoder().decode(NewsAPIData.self, from: wrapData)
                            
                            if isUpdateHistory {
                                let history = HistoryModel(name: searchNews, totalResults: decodeNews.totalResults)
                                
                                self.delegate?.updateHistoryTableView(history: history)
                            } else {
                                let articlesList: [ArticleAPIData] = decodeNews.articles
                                
                                self.delegate?.updateArticlesTableView(articlesList: articlesList)
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            
            task.resume()
        }
    }
}
