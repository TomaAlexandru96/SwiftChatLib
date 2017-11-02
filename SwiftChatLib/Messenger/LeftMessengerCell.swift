//
//  MessengerCell.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class LeftMessengerCell: UICollectionViewCell {
    @IBOutlet weak var textview: UITextView!
    
    func setText(text: String) {
        textview.text = text
    }
    
}
