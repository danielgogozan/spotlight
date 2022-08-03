//
//  KeychainManager.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 18.06.2022.
//

import Foundation

protocol KeychainManagerProtocol: AnyObject {
    func save<T: Codable> (_ item: T, service: String, account: String)
    func delete(service: String, account: String)
    func read<T: Codable> (_ type: T.Type, service: String, account: String) -> T?
}

class KeychainManager: KeychainManagerProtocol {
    
    let keychain: Keychain
    
    init(keychain: Keychain) {
        self.keychain = keychain
    }
    
    func save<T>(_ item: T, service: String, account: String) where T: Codable {
        do {
            let data = try JSONEncoder().encode(item)
            var query = [kSecAttrService: service, kSecAttrAccount: account, kSecValueData: data, kSecClass: kSecClassGenericPassword] as CFDictionary
            var status = keychain.save(query)
            
            if status == errSecDuplicateItem {
                query = [kSecAttrService: service, kSecAttrAccount: account, kSecClass: kSecClassGenericPassword] as CFDictionary
                let attributes = [kSecValueData: data] as CFDictionary
                status = keychain.update(query, attributes: attributes)
            }
            
            if status != errSecSuccess {
                print("[Keychain] Error whilte saving item to keychain: \(item)")
            } else {
                print("[Keychain] Successfully saved item: \(item)")
            }
        } catch {
            print("[Keychain] Fail to encode item: \(item).")
        }
    }
    
    func delete(service: String, account: String) {
        let status = keychain.delete(service: service, account: account, secClass: kSecClassGenericPassword)
        if status != errSecSuccess {
            print("[Keychain] Error whilte deleting data for (service, account): (\(service), \(account))")
        }
    }
    
    func read<T>(_ type: T.Type, service: String, account: String) -> T? where T: Codable {
        guard let data = keychain.read(service: service, account: account, secClass: kSecClassGenericPassword) else { return nil }
        
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            print("[Keychain] Error while reading data for (service, account): (\(service), \(account))")
            return nil
        }
    }
    
}
