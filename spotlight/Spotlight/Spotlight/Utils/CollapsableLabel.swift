//
//  CollapsableLabel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 14.03.2022.
//

import UIKit

class CollapsableLabel: UILabel {
    
    var isExpanded = true
    var maxLength = 125
    
    var fullText: String? {
        didSet {
            guard let fullText = fullText else { return }
            if fullText.count > maxLength {
                collapse()
            } else {
                expand()
            }
        }
    }
    
    func collapse() {
        guard let fullText = fullText, maxLength < fullText.count else { return }
        let index = fullText.index(fullText.startIndex, offsetBy: maxLength)
        self.text = fullText[...index].description + L10n.readMore
        isExpanded = false
    }

    func expand() {
        self.text = (fullText ?? "") + (fullText?.count ?? 0 > maxLength ? L10n.readLess : "")
        isExpanded = true
    }
    
}
