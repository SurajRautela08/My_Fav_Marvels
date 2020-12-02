//
//  Marvel.swift
//  My_Fav_Marvels
//
//  Created by Suraj on 01/12/20.
//  Copyright © 2020 Suraj. All rights reserved.
//

import Foundation
import UIKit

class Marvel: NSObject
{
    var title: String
    var image : UIImage
    var discription: String
    
    init(title: String , image: UIImage , discription: String)
    {
        self.title = title
        self.discription = discription
        self.image = image
    }
    
    
}
