//
//  DetailViewController.swift
//  NewsProject
//
//  Created by Gene MBS on 4/10/2565 BE.
//

import UIKit
import SafariServices


class DetailViewController: UIViewController {
    
    private let imageArticle: UIImageView! = {
        let imageArticle = UIImageView()
        
        imageArticle.translatesAutoresizingMaskIntoConstraints = false
        imageArticle.contentMode = .scaleToFill
        imageArticle.backgroundColor = .red
        
        return imageArticle
    }()
    
    private let scrollView: UIScrollView! = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        
       return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        
        return stackView
    }()
    
    private let titleArticle: UILabel! = {
        let titleArticle = UILabel()
        
        titleArticle.numberOfLines = 0
        titleArticle.sizeToFit()
        titleArticle.translatesAutoresizingMaskIntoConstraints = false
        
        return titleArticle
    }()
    
    private let descriptionArticle: UILabel! = {
        let descriptionArticle = UILabel()
        
        descriptionArticle.numberOfLines = 0
        descriptionArticle.sizeToFit()
        descriptionArticle.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionArticle
    }()
    
    private let dateArticle: UILabel! = {
        let dateArticle = UILabel()
        
        dateArticle.translatesAutoresizingMaskIntoConstraints = false
        dateArticle.numberOfLines = 1
        dateArticle.sizeToFit()
        
        return dateArticle
    }()
    
    private let sourceArticle: UIButton! = {
        let sourceArticle = UIButton()
        
        sourceArticle.setTitle("Source", for: .normal)
        sourceArticle.translatesAutoresizingMaskIntoConstraints = false
        sourceArticle.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        sourceArticle.sizeToFit()
        sourceArticle.backgroundColor = .cyan
        
        return sourceArticle
    }()
    
    var titleData: String?
    var descriptionData: String?
    var dateData: String?
    var sourceURLData: String?
    var imageDataString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageArticle)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(titleArticle)
        stackView.addArrangedSubview(descriptionArticle)
        stackView.addArrangedSubview(dateArticle)
        stackView.addArrangedSubview(sourceArticle)
        
        titleArticle.text = titleData
        descriptionArticle.text = descriptionData
        dateArticle.text = displayFormatDate(dateString: dateData)
        renderImage()
        sourceArticle.addTarget(self, action: #selector(onPressSource), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageArticle.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 10),
            imageArticle.heightAnchor.constraint(equalToConstant: 200),
            imageArticle.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor),
            imageArticle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: imageArticle.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: 10),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor,constant: -20),
        ])
    }
    
    func renderImage() {
        if let imageURL = URL(string: imageDataString ?? "") {
            let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.imageArticle.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }
    }
    
    func displayFormatDate (dateString:String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "TH")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateString!)

        if let date = date {
            dateFormatter.dateFormat = "dd MMM yyyy"
            let resultDate = dateFormatter.string(from: date)

            return resultDate
        }
        else {
            return ""
        }
    }
    
    
    @objc func onPressSource() {
        if let wrapSourceURL = sourceURLData {
            let safariVC = SFSafariViewController(url: URL(string: wrapSourceURL)!)
            self.present(safariVC, animated: true)
        }
    }
    
}
