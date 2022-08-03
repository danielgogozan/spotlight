//
//  Dictionary+Ext.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 21.02.2022.
//

import Foundation

extension Dictionary {
    static func+=(left: inout [Key: Value], right: [Key: Value]) {
        for (key, value) in right {
            left[key] = value
        }
     }
}
