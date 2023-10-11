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

// MARK: - Actdetail
struct Act: Codable {
    let act:String?
    let actdetail:[ActDetail]?
    let act_date:String?
    let diary_content:String?
    let diary_image:String?
    let diary_open_yn:String?
    let pet:Int?
    let user:Int?
}

struct ActDetail: Codable {
    let id:Int?
    let act_time:String?
    let memo:String?
    let memo_image:String?
    let walk_spend_time:Int?
    let ordure_shape:String?
    let ordure_color:String?
    let feed_type:String?
    let feed_amount:Int?
    let feed_name:String?
    let hospital_type:String?
    let weight:Int?
}
 
