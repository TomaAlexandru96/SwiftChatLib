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
    fileprivate var delegate: MessengerBehavoirDelegate!
    fileprivate var isLast: Bool = false
    
    func setText(text: String) {
        textView.text = text
    }
    
    func setDelegate(delegate: MessengerBehavoirDelegate) {
        self.delegate = delegate
        textView.setParent(parent: self)
    }
    
    func setLast(isLast: Bool) {
        self.isLast = isLast
    }
}

class DeletableTextView: UITextView {
    
    fileprivate var parent: RightMessengerCell!
    fileprivate var menu: UIMenuController? = nil
    
    func setParent(parent: RightMessengerCell) {
        self.parent = parent
    }
    
    func showMenu() {
        if parent.isLast && menu == nil {
            menu = UIMenuController()
            menu?.menuItems = [UIMenuItem(title: "Delete", action: #selector(deleteText))]
            menu?.update()
        }
    }
    
    @objc func deleteText() {
        parent.delegate.deletedLastMessageFromMe()
        menu = nil
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(deleteText) {
            return true
        }
        return false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        showMenu()
    }
    
}
