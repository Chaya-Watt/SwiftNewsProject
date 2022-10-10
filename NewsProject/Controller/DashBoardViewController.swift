//
//  ViewController.swift
//  NewsProject
//
//  Created by Gene MBS on 2/10/2565 BE.
//

import UIKit
import SafariServices
import SnapKit


class DashBoardViewController: UIViewController {
    
    private let buttonTapToSearch: UIButton = {
        let buttonTapToSearch = UIButton()
        
//        buttonTapToSearch.translatesAutoresizingMaskIntoConstraints = false
        buttonTapToSearch.setTitle("Tap To Search", for: .normal)
        buttonTapToSearch.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
                
        return buttonTapToSearch
    }()
    
    private let dashBoardTableView: UITableView! = {
        let dashBoardTableView = UITableView()
        
//        dashBoardTableView.translatesAutoresizingMaskIntoConstraints = false
        dashBoardTableView.separatorStyle = .none
        dashBoardTableView.showsVerticalScrollIndicator = false
       
        return dashBoardTableView
    }()
    
    var articleList: [ArticleAPIData] = []
    var selectArticle: ArticleAPIData?
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(buttonTapToSearch)
        view.addSubview(dashBoardTableView)
                
        dashBoardTableView.dataSource = self
        dashBoardTableView.delegate = self
        dashBoardTableView.register(UINib(nibName: K.CustomTableCell.dashBoardCell, bundle: nil), forCellReuseIdentifier:  K.CustomTableCell.dashBoardCell)
        
        buttonTapToSearch.addTarget(self, action: #selector(tapToSearch), for: .touchUpInside)

        
        // Set Constraint by Snapkit
        buttonTapToSearch.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(view.snp.centerX)
        }

        dashBoardTableView.snp.makeConstraints { make in
            make.top.equalTo(buttonTapToSearch.snp.bottom).offset(20)
            make.right.equalTo(view).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.equalTo(view).offset(20)
        }
        
        
        // Set Constraint by UIKit
//        NSLayoutConstraint.activate([
//            buttonTapToSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            buttonTapToSearch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            dashBoardTableView.topAnchor.constraint(equalTo: buttonTapToSearch.bottomAnchor, constant: 20),
//            dashBoardTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            dashBoardTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            dashBoardTableView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor)
//        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.articleList = loadLocal()
        handleShowTable(counts: articleList.count)
    }
    
    @objc func tapToSearch() {
        performSegue(withIdentifier: K.Segue.goToSearch, sender: nil)
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
    
    func saveToLocal(_ list: [ArticleAPIData]) {
        let data = list.map { try? JSONEncoder().encode($0)}
        
        defaults.set(data, forKey: K.KeyDataLocal.ArticleList)
    }
    
    func loadLocal() -> [ArticleAPIData] {
        guard let encodeData = defaults.array(forKey: K.KeyDataLocal.ArticleList) as? [Data] else {
            return []
        }
        
        let encodeArticleList = encodeData.map { try! JSONDecoder().decode(ArticleAPIData.self, from: $0)}
        
        
        return encodeArticleList
    }
    
    func handleShowTable(counts: Int) {
        print(counts)
        if counts == 0 {
            self.dashBoardTableView.isHidden = true
        }
        else {
            self.dashBoardTableView.isHidden = false
        }
    }
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
            cell.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            cell.layer.cornerRadius = 10


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
        self.selectArticle = selectArticle

        performSegue(withIdentifier: K.Segue.goToDetail, sender: self)
    }
}

//MARK: - HistoryDelegate

extension DashBoardViewController: HistoryDelegate {
    func updateArticleList(articleList: [ArticleAPIData]) {
        self.articleList = articleList
        saveToLocal(articleList)
        dashBoardTableView.reloadData()
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
