//
//  LocationTableViewCell.swift
//  SwiftWeather
//
//  Created by Jagjeetsingh Labana on 19/11/2024.
//  Copyright © 2024 Jake Lin. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.cornerRadius = 8
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
            containerView.layer.shadowRadius = 5
            containerView.layer.shadowOpacity = 1
        }
    }
    @IBOutlet weak var labelLocationName: UILabel!
    @IBOutlet weak var buttonFavourite: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
