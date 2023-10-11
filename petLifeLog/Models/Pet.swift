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
 
