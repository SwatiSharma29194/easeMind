//
//  moodHistoryTableViewCell.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-02-15.
//

import UIKit

class moodHistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var moodImg: UIImageView!
    @IBOutlet weak var moodDate: UILabel!
    @IBOutlet weak var taskName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
