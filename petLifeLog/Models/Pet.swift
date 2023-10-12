//
//  PetActions.swift
//  petLifeLog
//
//  Created by ! on 2023/10/04.
//

import Foundation

// 임시데이터 생성자에서 모든 값 넣지 않아도 되게 우선 var로 함
// MARK: - Diary
struct PetDiary: Codable {
    //var act_date: String
    var diary_image,diary_content, diary_open_yn: String?
}

// MARK: - Act
struct Act: Codable {
    var act: String
    var actdetail: Actdetail?
    var diary_content, diary_image, diary_open_yn: String?
    //let id, actdetailCount, pet, user: Int
    //let act_date: String
    //let reg_datetime: String?
}

// MARK: - Actdetail
struct Actdetail: Codable {
    //let id, petact: Int
    var act_time: String
    var memo, memo_image: String?
    var walk_spend_time, hospital_cost, beauty_cost: Int?
    var feed_amount, weight: Double?
    var ordure_shape, ordure_color: String?
    var feed_type, feed_name: String?
    var hospital_type, beauty_type: String?
}



// ActNum.몸무게.rawValue
//enum ActNum: Int {
//    case 산책 = 1
//    case 배변 = 2
//    case 사료 = 3
//    case 병원 = 4
//    case 미용 = 5
//    case 몸무게 = 6
//}

