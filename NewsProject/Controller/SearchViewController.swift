//
//  SearchViewController.swift
//  NewsProject
//
//  Created by Gene MBS on 3/10/2565 BE.
//

import UIKit

protocol HistoryDelegate {
    func updateArticleList(articleList:[ArticleAPIData])
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchNews: UITextField!
    @IBOutlet weak var historyListTable: UITableView!
    
    let defaults = UserDefaults.standard
    
    var newsAPI = NewsAPICall()
    
    var historyList: [HistoryModel] = []
    
    var delegate: HistoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchNews.delegate = self
        historyListTable.dataSource = self
        historyListTable.delegate = self
        newsAPI.delegate = self
        
        
        historyListTable.register(UINib(nibName: K.CustomTableCell.historyCell, bundle: nil), forCellReuseIdentifier: K.CustomTableCell.historyCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.historyList = loadLocal()
    }
    
    func saveToLocal(_ list: [HistoryModel]) {
        let data = list.map { try? JSONEncoder().encode($0)}
        
        defaults.set(data, forKey: K.KeyDataLocal.HistoryList)
    }
    
    func loadLocal() -> [HistoryModel] {
        guard let encodeData = defaults.array(forKey: K.KeyDataLocal.HistoryList) as? [Data] else {
           return []
        }
        
        let encodeHistoryList = encodeData.map { try! JSONDecoder().decode(HistoryModel.self, from: $0)}
        
 
        return encodeHistoryList
    }
    
}

//MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let wrapTextField = textField.text else {
            print("Pls Enter Keyword News")
            return false
        }
        newsAPI.fetchNews(searchNews: wrapTextField)
        searchNews.text = ""
        return true
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyListTable.dequeueReusableCell(withIdentifier: K.CustomTableCell.historyCell, for: indexPath) as! HistoryTableViewCell
        cell.historyName.text = historyList[indexPath.row].name
        cell.totalNews.text = String(historyList[indexPath.row].totalResults)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectHistory = historyList[indexPath.row]
                
        delegate?.updateArticleList(articleList: selectHistory.articles)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true,completion: nil)
    }
}

//MARK: - NewsAPICallDelegate

extension SearchViewController: NewsAPICallDelegate {
    func updateHistoryTableView(history: HistoryModel) {
        self.historyList.append(history)
        saveToLocal(historyList)
        
        DispatchQueue.main.async {
            self.historyListTable.reloadData()
        }
    }
    
}
