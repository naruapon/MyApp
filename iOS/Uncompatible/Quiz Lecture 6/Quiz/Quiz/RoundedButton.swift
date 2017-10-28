//
//  RoundedButton.swift
//  Quiz
//
//  Created by J. Ruof, Meruca on 23/03/16.
//  Copyright © 2016 RuMe Academy. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }

}
