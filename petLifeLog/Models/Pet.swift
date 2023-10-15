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
    // 3개 플러스. backend 보낼 용도
    let pet_id:Int?
    let act_date:String?
    // front AF로 받을 용도
    let id:Int //수정,삭제용 pk
    let act: String
    let act_time: String
    let memo, memo_image: String?
    let walk_spend_time, hospital_cost, beauty_cost, feed_amount, weight: Int?
    let ordure_shape, ordure_color: String?
    let feed_type, feed_name: String?
    let hospital_type, beauty_type: String?
}


