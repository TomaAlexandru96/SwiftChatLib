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
    let RIGHT_CELL_NAME = "LeftCell"
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first else {
            return
        }
        behavoirdDelegate.hideKeyboard()
    }
    
}

extension MessengerCollectionView: UICollectionViewDataSource {
    
    func sendMessage(message: GenericMessage) {
        data.append(message)
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(data.count)
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.item]
        let reusableCell = dequeueReusableCell(withReuseIdentifier: item.from == .AI ? LEFT_CELL_NAME : RIGHT_CELL_NAME, for: indexPath) as! MessengerCell
        var textContent: String = ""
        if let item = item as? TextMessage {
            textContent = item.content
        }
        reusableCell.setText(text: textContent)
        return reusableCell
    }
    
}
