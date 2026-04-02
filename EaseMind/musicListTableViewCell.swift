//
//  musicListTableViewCell.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-03-04.
//

import UIKit

class musicListTableViewCell: UITableViewCell {
    @IBOutlet weak var listViewBlack: UIView!
    
    @IBOutlet weak var soundName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
