//
//  DetailViewController.swift
//  NewsProject
//
//  Created by Gene MBS on 4/10/2565 BE.
//

import UIKit
import SafariServices


class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageArticle: UIImageView!
    @IBOutlet weak var titleArticle: UILabel!
    @IBOutlet weak var descriptionArticle: UILabel!
    @IBOutlet weak var dateArticle: UILabel!
    @IBOutlet weak var sourceButton: UIButton!
    
    var titleData: String?
    var descriptionData: String?
    var dateData: String?
    var sourceURLData: String?
    var imageDataString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleArticle.text = titleData
        descriptionArticle.text = descriptionData
        dateArticle.text = dateData
        renderImage()
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
    
    
    @IBAction func onPressSource(_ sender: UIButton) {        
        if let wrapSourceURL = sourceURLData {
            let safariVC = SFSafariViewController(url: URL(string: wrapSourceURL)!)
            self.present(safariVC, animated: true)
        }
    }
    
}
