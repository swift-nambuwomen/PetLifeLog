//
//  GlobalConst.swift
//  petLifeLog
//
//  Created by jso on 2023/10/13.
//

import Foundation


var SITE_URL = getReaAddress()

let IMAGE_URL = "https://stpetlifelog.blob.core.windows.net/petphoto"

// 로그인
let login_url = "\(SITE_URL)/auth/login"

// 회원가입
let join_url = "\(SITE_URL)/auth/regist"

// 이메일중복체크
let email_dupl_check_url = "\(SITE_URL)/auth/isEmailDupl"

// actList
let actList_url = "\(SITE_URL)/api/pet/act/list"

// act 등록
let actReg_url = "\(SITE_URL)/api/pet/act"

// diary 등록
let diaryReg_url = "\(SITE_URL)/api/pet/diary"


enum UserDefaultsKey: String, CaseIterable {
    case isLogined
    case userId
    case nickName
}

enum PetDefaultsKey: String, CaseIterable {
    case petName
    case petImage
    case petId
}

let USER_ID = UserDefaults.standard.integer(forKey: UserDefaultsKey.userId.rawValue)
let NICK_NAME = UserDefaults.standard.integer(forKey: UserDefaultsKey.nickName.rawValue)
var PET_ID = UserDefaults.standard.integer(forKey: PetDefaultsKey.petId.rawValue)
var PET_NAME = UserDefaults.standard.integer(forKey: PetDefaultsKey.petName.rawValue)
var PET_IMG = UserDefaults.standard.integer(forKey: PetDefaultsKey.petImage.rawValue)


func getReaAddress() -> String {
    if TARGET_IPHONE_SIMULATOR == 1 {
        return "http://127.0.0.1:8000"
    } else {
        return "https://petlogapi.azurewebsites.net"
    }
}
   

