//
//  StringUtils.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.03.2022.
//

import Foundation

final class StringUtils {
    
    static let shared: StringUtils = StringUtils()
    
    private init() {
    }
    
    func mutableAttributedString(message: String, links: [String], bodyAttr: [NSAttributedString.Key: Any], linkAttr: [[NSAttributedString.Key: Any]]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: message, attributes: bodyAttr))
        
        guard links.count == linkAttr.count else { return attributedString }
        
        for (idx, link) in links.enumerated() {
            let linkRange = NSString(string: message).range(of: link)
            attributedString.setAttributes(linkAttr[idx], range: linkRange)
            
        }
        
        return attributedString
    }
    
}
