//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Александр Верповский on 25.06.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username, firstName, lastName:String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}
