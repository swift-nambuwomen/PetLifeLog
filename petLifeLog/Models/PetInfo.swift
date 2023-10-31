//
//  PetInfo.swift
//  TeamProject
//
//  Created by hope1049 on 2023/10/02.
//

import Foundation

struct Pets: Codable {
    let id: Int
    let name, profileImage, birth, breed: String
    let sex: String
    let user: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case profileImage = "profile_image"
        case birth, breed, sex, user
        //case user = "user_id"
    }
    
init(from decoder : Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(Int.self, forKey: .id)) ?? 0
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        profileImage = (try? values.decode(String.self, forKey: .profileImage)) ?? ""
        birth = (try? values.decode(String.self, forKey: .birth)) ?? ""
        breed = (try? values.decode(String.self, forKey: .breed)) ?? ""
        sex = (try? values.decode(String.self, forKey: .sex)) ?? ""
        user = (try? values.decode(Int.self, forKey: .user)) ?? 0
    }
}

struct DiaryList: Codable {
    let pet: Int
    let act_date: String
    let diary_image: String
    let diary_content: String
    let pet_name: String
    let user_name: String

    init(from decoder : Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        pet = (try? values.decode(Int.self, forKey: .pet)) ?? 0
        act_date = (try? values.decode(String.self, forKey: .act_date)) ?? ""
        diary_image = (try? values.decode(String.self, forKey: .diary_image)) ?? ""
        diary_content = (try? values.decode(String.self, forKey: .diary_content)) ?? ""
        pet_name = (try? values.decode(String.self, forKey: .pet_name)) ?? ""
        user_name = (try? values.decode(String.self, forKey: .user_name)) ?? ""
    }

}

//myInfo 한달 지출비용
struct CostData: Codable {
    let petID, feedAmount, hospitalCost, beautyCost: Int

    enum CodingKeys: String, CodingKey {
        case petID = "pet_id"
        case feedAmount = "feed_amount"
        case hospitalCost = "hospital_cost"
        case beautyCost = "beauty_cost"
    }
    
    init(from decoder : Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        petID = (try? values.decode(Int.self, forKey: .petID)) ?? 0
        feedAmount = (try? values.decode(Int.self, forKey: .feedAmount)) ?? 0
        hospitalCost = (try? values.decode(Int.self, forKey: .hospitalCost)) ?? 0
        beautyCost = (try? values.decode(Int.self, forKey: .beautyCost)) ?? 0
    }
}

//성장곡선
struct WeightData: Codable {
    let actDate: String
    let weight: Double

    enum CodingKeys: String, CodingKey {
        case actDate = "act_date"
        case weight
    }
    
    init(from decoder : Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        actDate = (try? values.decode(String.self, forKey: .actDate)) ?? ""
        weight = (try? values.decode(Double.self, forKey: .weight)) ?? 0
    }
}







