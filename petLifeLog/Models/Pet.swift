//
//  PetActions.swift
//  petLifeLog
//
//  Created by ! on 2023/10/04.
//

import Foundation

struct PetAction: Codable {
    let id: Int
    let actDate: String
    let diaryContent, diaryImage, diaryOpenYn: String
    let regDatetime: String
    let pet, act, user: Int

    enum CodingKeys: String, CodingKey {
        case id
        case actDate = "act_date"
        case diaryContent = "diary_content"
        case diaryImage = "diary_image"
        case diaryOpenYn = "diary_open_yn"
        case regDatetime = "reg_datetime"
        case pet, act, user
    }
}

//typealias PetActResult = [PetAction]

struct PetDiary: Codable {
    var diary_image: String?
    var diary_content: String?
    var act_time: String?
    
}

struct PetActionDetail: Codable {
    var act_time : String
    var memo : String?
    var memo_image : String?
    var walk_spend_time : String?
    var ordure_shape : String?
    var ordure_color : String?
    var feed_type : String?
    var feed_amount : String?
    var feed_name : String?
    var hospital_type : String?
    var hospital_name : String?
    var hospital_doctor : String?
    var hospital_cost : Int?
    var beauty_cost : Int?
    var weight : Double?
}
