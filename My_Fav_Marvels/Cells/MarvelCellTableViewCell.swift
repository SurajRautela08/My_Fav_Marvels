//
//  MarvelCellTableViewCell.swift
//  My_Fav_Marvels
//
//  Created by Suraj on 01/12/20.
//  Copyright © 2020 Suraj. All rights reserved.
//

import UIKit

class MarvelCellTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var about: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
