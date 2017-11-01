//
//  MessengerViewController.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class MessengerCollectionView: UICollectionView {
    
    var behavoirdDelegate: MessengerBehavoirDelegate!
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else {
            return
        }
        behavoirdDelegate.hideKeyboard()
    }
    
}
