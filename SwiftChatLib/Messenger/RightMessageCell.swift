//
//  RightMessageCell.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class RightMessengerCell: UICollectionViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    func setText(text: String) {
        textView.text = text
    }
    
}
