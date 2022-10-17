//
//  SearchViewController.swift
//  NewsProject
//
//  Created by Gene MBS on 3/10/2565 BE.
//

import UIKit
import SnapKit

protocol HistoryDelegate {
    func updateArticleList(articleList:[ArticleAPIData]) async
}

class SearchViewController: UIViewController {
    
    private let searchFieldNews: UITextField! = {
        let searchFieldNews = UITextField()
        
        searchFieldNews.placeholder = "Search News"
        searchFieldNews.font = .systemFont(ofSize: 20)
        searchFieldNews.backgroundColor = .white
        searchFieldNews.borderStyle = .roundedRect
        
        return searchFieldNews
    }()
    
    private let historyListTable: UITableView = {
        let historyListTable = UITableView()
        
        historyListTable.backgroundColor = .white
        
        return historyListTable
    }()
    
    let defaults = UserDefaults.standard
    
    var newsAPI = NewsAPICall()
    
    var historyList: [HistoryModel] = []
    
    var delegate: HistoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchFieldNews)
        view.addSubview(historyListTable)
        
        
        searchFieldNews.delegate = self
        historyListTable.dataSource = self
        historyListTable.delegate = self
        newsAPI.delegate = self
        
        
        historyListTable.register(UINib(nibName: K.CustomTableCell.historyCell, bundle: nil), forCellReuseIdentifier: K.CustomTableCell.historyCell)
        
        searchFieldNews.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.height.equalTo(50)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
        }
        
        historyListTable.snp.makeConstraints { make in
            make.top.equalTo(searchFieldNews.snp.bottom).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.equalTo(view).offset(20)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.historyList = loadLocal()
        handleShowTable(counts: historyList.count)
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
    
    func handleShowTable(counts: Int) {
        print(counts)
        if counts == 0 {
            self.historyListTable.isHidden = true
        }
        else {
            self.historyListTable.isHidden = false
        }
    }
}

//MARK: - UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let wrapTextField = textField.text else {
            print("Pls Enter Keyword News")
            return false
        }
        newsAPI.fetchNews(searchNews: wrapTextField,isUpdateHistory: true)
        searchFieldNews.text = ""
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
        cell.separatorInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        cell.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectHistory = historyList[indexPath.row]
        
        newsAPI.fetchNews(searchNews: selectHistory.name,isUpdateHistory: false)
        
    }
}

//MARK: - NewsAPICallDelegate

extension SearchViewController: NewsAPICallDelegate {
    func updateArticlesTableView(articlesList: [ArticleAPIData]) {
        Task {
            await delegate?.updateArticleList(articleList: articlesList)
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true,completion: nil)
            }
        }
    }
    
    func updateHistoryTableView(history: HistoryModel) {
        self.historyList.append(history)
        saveToLocal(historyList)
        handleShowTable(counts: historyList.count)
        
        DispatchQueue.main.async {
            self.historyListTable.reloadData()
        }
    }
    
}
