//
//  MemeTableViewCell.swift
//  Meme2.0
//
//  Created by Christine Chao on 5/18/17.
//  Copyright © 2017 Christine Chao. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
