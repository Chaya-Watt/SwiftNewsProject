//
//  NewsAPICall.swift
//  NewsProject
//
//  Created by Gene MBS on 3/10/2565 BE.
//

import Foundation

protocol NewsAPICallDelegate {
    func updateHistoryTableView(history: HistoryModel)
}

struct NewsAPICall {
    let newsURL = "https://newsapi.org/v2/everything?from=2022-09-04&sortBy=publishedAt&apiKey=7d785e8a702740a5a85fa236095ec611"
    
    var delegate: NewsAPICallDelegate?
    
    func fetchNews(searchNews: String) {
        let urlString = "\(newsURL)&q=\(searchNews)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    return
                } else {
                    if let wrapData = data {
                        do {
                            let decodeNews = try JSONDecoder().decode(NewsAPIData.self, from: wrapData)
                            let history = HistoryModel(name: searchNews, status: decodeNews.status, totalResults: decodeNews.totalResults, articles: decodeNews.articles  )
                            
                            self.delegate?.updateHistoryTableView(history: history)
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
