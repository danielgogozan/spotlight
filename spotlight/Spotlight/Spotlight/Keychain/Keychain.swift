//
//  Keychain.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 18.06.2022.
//

import Foundation

protocol KeychainProtocol: AnyObject {
    func save(_ query: CFDictionary) -> OSStatus
    func update(_ query: CFDictionary, attributes: CFDictionary) -> OSStatus
    func delete(service: String, account: String, secClass: CFString) -> OSStatus
    func read(service: String, account: String, secClass: CFString) -> Data?
}

class Keychain: KeychainProtocol {
    
    @discardableResult
    func save(_ query: CFDictionary) -> OSStatus {
        return SecItemAdd(query, nil)
    }
    
    @discardableResult
    func update(_ query: CFDictionary, attributes: CFDictionary) -> OSStatus {
        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    }
    
    @discardableResult
    func delete(service: String, account: String, secClass: CFString) -> OSStatus {
        let query = [kSecAttrService: service, kSecAttrAccount: account, kSecClass: secClass] as CFDictionary
        return SecItemDelete(query)
    }
    
    @discardableResult
    func read(service: String, account: String, secClass: CFString) -> Data? {
        let query = [kSecAttrService: service, kSecAttrAccount: account, kSecClass: secClass, kSecReturnData: true] as CFDictionary
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return result as? Data
    }
    
}
