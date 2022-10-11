//
//  DetailViewController.swift
//  NewsProject
//
//  Created by Gene MBS on 4/10/2565 BE.
//

import UIKit
import SafariServices


class DetailViewController: UIViewController {
    
    private let imageArticle: UIImageView = {
        let imageArticle = UIImageView()
        
        imageArticle.contentMode = .scaleToFill
        imageArticle.backgroundColor = .gray
        
        return imageArticle
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.backgroundColor = .white
        
        return stackView
    }()
    
    private let titleArticle: UILabel! = {
        let titleArticle = UILabel()
        
        titleArticle.numberOfLines = 0
        titleArticle.sizeToFit()
        titleArticle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        return titleArticle
    }()
    
    private let descriptionArticle: UILabel! = {
        let descriptionArticle = UILabel()
        
        descriptionArticle.numberOfLines = 0
        descriptionArticle.sizeToFit()
        descriptionArticle.font = .systemFont(ofSize: 16, weight: .regular)
        
        return descriptionArticle
    }()
    
    private let dateArticle: UILabel! = {
        let dateArticle = UILabel()
        
        dateArticle.numberOfLines = 1
        dateArticle.sizeToFit()
        dateArticle.textColor = .gray
        
        return dateArticle
    }()
    
    private let sourceArticle: UIButton! = {
        let sourceArticle = UIButton()
        
        sourceArticle.setTitle("Source", for: .normal)
        sourceArticle.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        sourceArticle.sizeToFit()
        sourceArticle.setTitleColor(.systemCyan, for: .normal)
        
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
        
        imageArticle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(200)
            make.left.equalTo(view).offset(20)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(imageArticle.snp.bottom).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView)
            make.right.equalTo(scrollView)
            make.left.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        titleArticle.snp.makeConstraints { make in
            make.top.equalTo(stackView).offset(10)
            make.left.equalTo(stackView).offset(10)
            make.right.equalTo(stackView).offset(-10)
        }
        
        sourceArticle.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width).offset(-20)
            make.bottom.equalTo(stackView).offset(-10)
        }
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
