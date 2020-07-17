//
//  MessageCell.swift
//  08-ChatApp
//
//  Created by Ricardo Sanchez on 7/16/20.
//  Copyright © 2020 Ricardo Sanchez. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.messageBackground.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
