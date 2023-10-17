//
//  PetActions.swift
//  petLifeLog
//
//  Created by ! on 2023/10/04.
//

import Foundation
import Alamofire

// MARK: - Diary
struct PetDiary: Codable {
    let id: Int // 수정 삭제용 pk
    let diary_image,diary_content, diary_open_yn: String?
}

// MARK: - Act
struct Act: Codable {
    let id: Int // 수정용 pk
    let actdetail: [Actdetail]?
    let diary_content, diary_image, diary_open_yn: String?
}

// MARK: - Actdetail
struct Actdetail: Codable {
    let pet:Int? // backend 필수
    let act_name:String?
    let act:Int
    let act_date:String? // backend 필수
    let id:Int // backend 수정,삭제용 pk
    let act_time: String
    let memo, memo_image: String?
    let walk_spend_time, hospital_cost, beauty_cost, feed_amount: Int?
    let weight: Double?
    let ordure_shape, ordure_color: String?
    let feed_type, feed_name: String?
    let hospital_type, beauty_type: String?
}



