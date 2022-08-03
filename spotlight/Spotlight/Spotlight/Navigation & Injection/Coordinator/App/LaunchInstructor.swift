//
//  LaunchInstructor.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 20.06.2022.
//

import Foundation

enum LaunchFlow: Int {
    case auth
    case main
}

class LaunchInstructor {
    
    private let keychainManager: KeychainManagerProtocol
    
    init(keychainManager: KeychainManagerProtocol) {
        self.keychainManager = keychainManager
    }
    
    var launchFlow: LaunchFlow {
        /*
         Keychain will persist the token even after the app is being unistall. To overcome this, we're using hasRunBefore as an indicator of
         whether the app should consider the keychain value.
         */
        defer { UserDefaults.standard.set(true, forKey: "didRunBefore") }
        
        guard keychainManager.read(Token.self, service: Constants.kTokenService, account: Constants.kTokenAccount) != nil,
              UserDefaults.standard.bool(forKey: "didRunBefore")
        else {
            keychainManager.delete(service: Constants.kTokenService, account: Constants.kTokenAccount)
            return .auth
        }
        
        return .main
    }
    
}
