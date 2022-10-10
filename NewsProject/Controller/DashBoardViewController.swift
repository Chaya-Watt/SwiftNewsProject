//
//  ViewController.swift
//  NewsProject
//
//  Created by Gene MBS on 2/10/2565 BE.
//

import UIKit
import SafariServices


class DashBoardViewController: UIViewController {
    
    @IBOutlet weak var dashBoardTableView: UITableView!
    
    var articleList: [ArticleAPIData] = []
    var selectArticle: ArticleAPIData?
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dashBoardTableView.dataSource = self
        dashBoardTableView.delegate = self
        dashBoardTableView.register(UINib(nibName: K.CustomTableCell.dashBoardCell, bundle: nil), forCellReuseIdentifier:  K.CustomTableCell.dashBoardCell)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.articleList = loadLocal()
//    }
    
    @IBAction func tapTpSearch(_ sender: UIButton) {
        performSegue(withIdentifier: K.Segue.goToSearch, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.goToSearch {
            let searchVC = segue.destination as! SearchViewController
            searchVC.delegate = self
        }
        if segue.identifier == K.Segue.goToDetail {
            let detailVC = segue.destination as! DetailViewController
            
            detailVC.titleData = selectArticle?.title
            detailVC.descriptionData = selectArticle?.description
            detailVC.dateData = selectArticle?.publishedAt
            detailVC.sourceURLData = selectArticle?.url
            detailVC.imageDataString = selectArticle?.urlToImage
        }
    }
    
//    func saveToLocal(_ list: [ArticleAPIData]) {
//        let data = list.map { try? JSONEncoder().encode($0)}
//
//        defaults.set(data, forKey: K.KeyDataLocal.ArticleList)
//    }
    
//    func loadLocal() -> [ArticleAPIData] {
//        guard let encodeData = defaults.array(forKey: K.KeyDataLocal.ArticleList) as? [Data] else {
//            return []
//        }
//
//        let encodeArticleList = encodeData.map { try! JSONDecoder().decode(ArticleAPIData.self, from: $0)}
//
//
//        return encodeArticleList
//    }
    
}

//MARK: - UITableViewDataSource

extension DashBoardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = dashBoardTableView.dequeueReusableCell(withIdentifier: K.CustomTableCell.dashBoardCell, for: indexPath) as? DashBoardTableViewCell {
            let article = articleList[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "TH")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let date = dateFormatter.date(from: article.publishedAt!)
            
            if let date = date {
                dateFormatter.dateFormat = "dd MMM yyyy"
                let resultDate = dateFormatter.string(from: date)
                
                cell.date.text = resultDate
            }
            
            cell.titleNews.text = article.title ?? ""
            cell.descriptionNews.text = article.description ?? ""
            cell.urlSource = article.url
            cell.delegate = self
            
            
            if let imageURL = URL(string: article.urlToImage ?? "") {
                let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    guard let data = data, error == nil else {
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageNews.image = UIImage(data: data)
                    }
                }
                
                task.resume()
            }
            
            return cell
            
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectArticle = articleList[indexPath.row]
        print("selectArticle \(selectArticle)")
        self.selectArticle = selectArticle
        
        performSegue(withIdentifier: K.Segue.goToDetail, sender: self)
    }
}

//MARK: - HistoryDelegate

extension DashBoardViewController: HistoryDelegate {
    func updateArticleList(articleList: [ArticleAPIData]) {
        self.articleList = articleList
//        saveToLocal(articleList)
        
        DispatchQueue.main.async {
            self.dashBoardTableView.reloadData()
        }
    }
}

//MARK: - DashBoardTableViewDelegate

extension DashBoardViewController: DashBoardTableViewDelegate {
    func didTapOpenSource(source: String?) {
        if let wrapSource = source {
            let safariVC = SFSafariViewController(url: URL(string: wrapSource)!)
            self.present(safariVC, animated: true)
        } else {
            print("source url is nil")
        }
    }
}
