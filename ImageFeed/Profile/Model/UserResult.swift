//
//  UserResult.swift
//  ImageFeed
//
//  Created by Александр Верповский on 26.06.2024.
//

import Foundation

struct UserResult: Codable {
    var profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let large: String
}
