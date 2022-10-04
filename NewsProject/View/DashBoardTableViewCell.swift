//
//  DashBoardTableViewCell.swift
//  NewsProject
//
//  Created by Gene MBS on 2/10/2565 BE.
//

import UIKit

protocol DashBoardTableViewDelegate {
    func didTapOpenSource(source: String?)
}

class DashBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var descriptionNews: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var sourceButton: UIButton!
    
    var urlSource: String?
    var delegate: DashBoardTableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func pressOpenSource(_ sender: UIButton) {
        delegate?.didTapOpenSource(source: urlSource)
    }
}
