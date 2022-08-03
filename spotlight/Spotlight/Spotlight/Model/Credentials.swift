//
//  Credentials.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 21.05.2022.
//

import Foundation

struct Credentials: Codable {
    var email: String
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}
