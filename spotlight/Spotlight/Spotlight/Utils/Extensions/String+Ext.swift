//
//  String+Ext.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 25.02.2022.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
}
