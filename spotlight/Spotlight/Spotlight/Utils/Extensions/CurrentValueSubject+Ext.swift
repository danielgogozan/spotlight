//
//  CurrentValueSubject+Ext.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 16.03.2022.
//

import Combine

extension CurrentValueSubject {
    
    func appendAndSend<T>(_ value: T) {
        guard let valueArray = self.value as? [AnyObject],
              let valueToAppend = value as? [AnyObject] else {
                  sendValue(value)
                  return
              }
        
        var currentValue = valueArray
        currentValue.append(contentsOf: valueToAppend)
        self.sendValue(currentValue)
    }
    
    func sendValue<T>(_ value: T) {
        if let v = value as? Output {
            self.send(v)
        }
    }
    
}
