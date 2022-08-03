//
//  SearchBarCollectionCell.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 21.04.2022.
//

import Foundation
import UIKit
import Combine

class SearchBarCollectionCell: UICollectionViewCell {
    
    // MARK: - Private properties
    @IBOutlet private weak var searchBarView: SearchBarView!
    
    // MARK: - Public properties
    var focus: Bool = false {
        didSet {
            if focus {
                searchBarView.focus()
            }
        }
    }
    var subscribers: [AnyCancellable] = []
    let liveTextSubject: PassthroughSubject<String, Never> = PassthroughSubject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchBarView.$liveText
            .throttle(for: 0.5, scheduler: DispatchQueue.main, latest: true)
            .removeDuplicates()
            .print("Text: ")
            .sink { [weak self] text in
                self?.liveTextSubject.send(text)
            }
            .store(in: &subscribers)
    }
    
}
