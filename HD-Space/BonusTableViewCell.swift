//
//  BonusTableViewCell.swift
//  HD-Space
//
//  Created by Erik Slovák on 14/12/2016.
//  Copyright © 2016 Erik Slovák. All rights reserved.
//

import UIKit

class BonusTableViewCell: UITableViewCell {

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
