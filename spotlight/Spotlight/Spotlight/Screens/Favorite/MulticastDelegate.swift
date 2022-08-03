//
//  MulticastDelegate.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.04.2022.
//

import Foundation

class MulticastDelegate<ProtocolType> {
    
    private var delegateWrappers: [DelegateWrapper]
    
    // Wrapper in order to keep strong references to delegate wrappers while keeping weak references to the actual objects
    private class DelegateWrapper {
        weak var delegate: AnyObject?
        
        init(_ delegate: AnyObject) {
            self.delegate = delegate
        }
    }
    
    public var delegates: [ProtocolType] {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }
        // swiftlint:disable force_cast
        return delegateWrappers.map { $0.delegate } as! [ProtocolType]
        // swiftlint:enable force_cast
    }
    
    init(delegates: [ProtocolType] = []) {
        delegateWrappers = delegates.map { DelegateWrapper($0 as AnyObject) }
    }
    
    func addDelegate(_ delegate: ProtocolType) {
        let wrapper = DelegateWrapper(delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }
    
    func removeDelegate(_ delegate: ProtocolType) {
        guard let index = delegateWrappers.firstIndex(where: { $0.delegate === (delegate as AnyObject) }) else { return }
        delegateWrappers.remove(at: index)
    }
    
    func invokeAll(if condition: (ProtocolType) -> Bool, with closure: (ProtocolType) -> Void) {
        delegates
            .filter { condition($0) }
            .forEach { closure($0) }
    }
    
}
