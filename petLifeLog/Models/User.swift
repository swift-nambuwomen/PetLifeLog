//
//  User.swift
//  petLifeLog
//
//  Created by jso on 2023/10/13.
//

import Foundation

struct Token: Codable {
    let access: String
    let refresh: String
}

struct User: Codable {
    let id: Int
    let password: String
    let email: String
    let nickName: String
//    let profileImage: String?
    let regDate: String
    let pets: [Pets]
    
    enum CodingKeys: String, CodingKey {
        case id, password, email, pets
//        case profileImage = "profile_image"
        case regDate = "reg_datetime"
        case nickName = "nick_name"
    }
    
    
}

struct LoginResult: Codable {
    let message: String
    let user: User?
    let token: Token?
    
//    init(from decoder : Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        message = (try? values.decode(String.self, forKey: .message)) ?? ""
//        user = (try? values.decode(User.self, forKey: .user)) ?? User(id: 0, password: "", email: "", nickName: "", profileImage: "", regDate: "", pets: [])
//        token = (try? values.decode(Token.self, forKey: .token)) ?? Token(access: "", refresh: "")
//
//    }
}
