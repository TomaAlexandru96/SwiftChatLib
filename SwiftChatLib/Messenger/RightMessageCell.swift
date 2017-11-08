//
//  RightMessageCell.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class RightMessengerCell: UICollectionViewCell {
    
    @IBOutlet weak var textView: DeletableTextView!
    @IBOutlet weak var touchMask: RightCellTouchMask!
    fileprivate var delegate: MessengerBehavoirDelegate!
    fileprivate var isLast: Bool = false
    
    func setText(text: String) {
        textView.text = text
    }
    
    func setDelegate(delegate: MessengerBehavoirDelegate) {
        self.delegate = delegate
        textView.setParent(parent: self)
        touchMask.setParent(parent: self)
    }
    
    func setLast(isLast: Bool) {
        self.isLast = isLast
    }
}

class RightCellTouchMask: UIView {
    
    fileprivate var parent: RightMessengerCell!
    
    func setParent(parent: RightMessengerCell) {
        self.parent = parent
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        parent.textView.showMenu()
    }
    
}

class DeletableTextView: UITextView {
    
    fileprivate var parent: RightMessengerCell!
    
    func setParent(parent: RightMessengerCell) {
        self.parent = parent
    }
    
    func showMenu() {
        if parent.isLast {
            let menu = UIMenuController()
            menu.menuItems = [UIMenuItem(title: "Delete", action: #selector(deleteText))]
            menu.update()
        }
    }
    
    @objc func deleteText() {
        parent.delegate.deletedLastMessageFromMe()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(deleteText) {
            return true
        }
        return false
    }
    
}
