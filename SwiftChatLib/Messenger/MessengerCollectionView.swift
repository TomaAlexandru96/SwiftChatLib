//
//  MessengerViewController.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class MessengerCollectionView: UICollectionView {
    
    let LEFT_CELL_NAME = "LeftCell"
    let RIGHT_CELL_NAME = "RightCell"
    var behavoirdDelegate: MessengerBehavoirDelegate!
    fileprivate var data: [GenericMessage] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        dataSource = self
        delegate = self
        // bug when UICollectionView data is empty
        numberOfItems(inSection: 0)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else {
            return
        }
        behavoirdDelegate.hideKeyboard()
    }
    
}

extension MessengerCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func sendMessage(message: GenericMessage) {
        data.append(message)
        
        self.reloadData()
        self.insertItems(at: [IndexPath(item: self.data.count - 1, section: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.item]
        var textContent: String = ""
        
        if let item = item as? TextMessage {
            textContent = item.content
        }
        
        var reusableCell: UICollectionViewCell!
        
        if item.from == .Other {
            reusableCell = dequeueReusableCell(withReuseIdentifier: LEFT_CELL_NAME, for: indexPath)
            /*guard let reusableCell = reusableCell as? LeftMessengerCell else {
                fatalError("Should cast fine")
            }
            reusableCell.setText(text: textContent)*/
        } else {
            reusableCell = dequeueReusableCell(withReuseIdentifier: RIGHT_CELL_NAME, for: indexPath)
            /*guard let reusableCell = reusableCell as? RightMessengerCell else {
                fatalError("Should cast fine")
            }
            reusableCell.setText(text: textContent)*/
        }
        
        return reusableCell
    }
    
}
