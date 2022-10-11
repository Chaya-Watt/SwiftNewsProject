//
//  DashBoardTableViewCell.swift
//  NewsProject
//
//  Created by Gene MBS on 2/10/2565 BE.
//

import UIKit
import SnapKit

protocol DashBoardTableViewDelegate {
    func didTapOpenSource(source: String?)
}

class DashBoardTableViewCell: UITableViewCell {
    
    let imageNews: UIImageView = {
        let imageNews = UIImageView()
        
        imageNews.contentMode = .scaleToFill
        imageNews.backgroundColor = .gray
        
        return imageNews
    }()
    
    let titleNews: UILabel = {
        let titleNews = UILabel()
        
        titleNews.numberOfLines = 0
        titleNews.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        return titleNews
    }()
    
    let descriptionNews: UILabel = {
        let descriptionNews = UILabel()
        
        descriptionNews.numberOfLines = 0
        descriptionNews.font = .systemFont(ofSize: 16, weight: .regular)
        
        return descriptionNews
    }()
    
    let date: UILabel = {
        let date = UILabel()
        
        date.textColor = .gray
        
        return date
    }()
    
    let sourceButton: UIButton = {
        let sourceButton = UIButton()
        
        sourceButton.setTitle("source", for: .normal)
        sourceButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        sourceButton.setTitleColor(.systemCyan, for: .normal)
        
        return sourceButton
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        
        stackView.spacing = 20
        
        return stackView
    }()
    
    private let stackHorizonal: UIStackView = {
        let stackHorizonal = UIStackView()
        
        stackHorizonal.axis = .horizontal
        
        return stackHorizonal
    }()
    
    var urlSource: String?
    var delegate: DashBoardTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageNews)
        stackView.addArrangedSubview(titleNews)
        stackView.addArrangedSubview(descriptionNews)
        stackView.addArrangedSubview(stackHorizonal)
        stackHorizonal.addArrangedSubview(date)
        stackHorizonal.addArrangedSubview(sourceButton)
        
        sourceButton.addTarget(self, action: #selector(pressOpenSource), for: .touchUpInside)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(10)
            make.right.equalTo(contentView.safeAreaLayoutGuide.snp.right).offset(-10)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.left.equalTo(contentView.safeAreaLayoutGuide.snp.left).offset(10)
        }
        
        imageNews.snp.makeConstraints { make in
            make.top.equalTo(stackView)
            make.right.equalTo(stackView)
            make.left.equalTo(stackView)
            make.height.equalTo(250)
        }

        titleNews.snp.makeConstraints { make in
            make.right.equalTo(stackView)
            make.left.equalTo(stackView)
        }
        
        descriptionNews.snp.makeConstraints { make in
            make.right.equalTo(stackView)
            make.left.equalTo(stackView)
        }
        
        stackHorizonal.snp.makeConstraints { make in
            make.top.equalTo(descriptionNews.snp.bottom).offset(20)
            make.right.equalTo(stackView)
            make.left.equalTo(stackView)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func pressOpenSource(_ sender: UIButton) {
        delegate?.didTapOpenSource(source: urlSource)
    }
}
