//
//  MessengerViewController.swift
//  SwiftChatLib
//
//  Created by Alexandru Toma on 01/11/2017.
//  Copyright © 2017 Alexandru Toma. All rights reserved.
//

import UIKit

class MessengerCollectionViewController: UICollectionViewController {
    
    let LEFT_CELL_NAME = "LeftCell"
    let RIGHT_CELL_NAME = "RightCell"
    var behaviorDelegate: MessengerBehavoirDelegate!
    fileprivate var data: [GenericMessage] = []
    
    override func viewDidLoad() {
        setupFlow()
    }
    
    func setupFlow() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 50, height: 50)
        collectionView?.collectionViewLayout = flowLayout
    }
    
    @IBAction func tap(_ sender: Any) {
        behaviorDelegate.hideKeyboard()
    }
    
}

extension MessengerCollectionViewController {
    
    func reset() {
        // TODO
    }
    
    func sendMessage(message: GenericMessage) {
        data.append(message)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.scrollToItem(at: IndexPath(item: self.data.count - 1, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
        }
        behaviorDelegate.receivedMessage(message: message)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.item]
        var textContent: String!
        
        if let item = item as? TextMessage {
            textContent = item.content
        }
        
        var reusableCell: UICollectionViewCell!
        
        if item.from == .Other {
            reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: LEFT_CELL_NAME, for: indexPath)
            guard let reusableCell = reusableCell as? LeftMessengerCell else {
                fatalError("Should cast fine")
            }
            reusableCell.setText(text: textContent)
        } else {
            reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: RIGHT_CELL_NAME, for: indexPath)
            guard let reusableCell = reusableCell as? RightMessengerCell else {
                fatalError("Should cast fine")
            }
            reusableCell.setText(text: textContent)
            reusableCell.setDelegate(delegate: behaviorDelegate)
            reusableCell.setLast(isLast: isLastFromMe(index: indexPath.item))
        }
        
        return reusableCell
    }
    
    fileprivate func isLastFromMe(index: Int) -> Bool {
        for i in index+1..<data.count {
            if data[i].from == .Me {
                return false
            }
        }
        return true;
    }
    
    func deleteLastCells(nr: Int) {
        _ = data.removeLast(nr)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
}
