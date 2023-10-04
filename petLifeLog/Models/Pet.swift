//
//  PetActions.swift
//  petLifeLog
//
//  Created by ! on 2023/10/04.
//

import Foundation

struct PetAction: Codable {
    var act_id: Int?
    var actions:PetActionDetail?
}

struct PetDiary: Codable {
    var act_time : String?
    var diary_content: String?
    var diary_image: String?
    var diary_open: Bool?
    //var actions:PetActionDetail
}

struct PetActionDetail: Codable {
    var act_time : String
    var memo : String?
    var memo_image : String?
    var walk_spend_time : Int?
    var ordure_shape : String?
    var ordure_color : String?
    var feed_type : String?
    var feed_amount : String?
    var feed_name : String?
    var hospital_type : String?
//    var hospital_name : String?
//    var hospital_doctor : String?
    var hospital_cost : Int?
    var beauty_type : String?
    var beauty_cost : Int?
    var weight : Double?
}
