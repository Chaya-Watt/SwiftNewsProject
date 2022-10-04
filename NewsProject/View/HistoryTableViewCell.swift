//
//  HistoryTableViewCell.swift
//  NewsProject
//
//  Created by Gene MBS on 3/10/2565 BE.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var historyName: UILabel!
    @IBOutlet weak var totalNews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
