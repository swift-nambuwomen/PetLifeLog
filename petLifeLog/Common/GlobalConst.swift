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

// act 등록 (image 첨부)
let actImageReg_url = "\(SITE_URL)/api/pet/actImage"

// act 등록 (image 첨부)
let actDel_url = "\(SITE_URL)/api/pet/actDel"

// diary 등록
let diaryReg_url = "\(SITE_URL)/api/pet/diary"

// 달력통계용
let statsForCalendar_url = "\(SITE_URL)/api/pet/act/detailList"

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

var USER_ID = UserDefaults.standard.integer(forKey: UserDefaultsKey.userId.rawValue)
var NICK_NAME = UserDefaults.standard.string(forKey: UserDefaultsKey.nickName.rawValue)
var PET_ID = UserDefaults.standard.integer(forKey: PetDefaultsKey.petId.rawValue)
var PET_NAME = UserDefaults.standard.string(forKey: PetDefaultsKey.petName.rawValue)
var PET_IMG = UserDefaults.standard.string(forKey: PetDefaultsKey.petImage.rawValue)


func getReaAddress() -> String {
    if TARGET_IPHONE_SIMULATOR == 1 {
        return "http://127.0.0.1:8000"
    } else {
        return "https://petlogapi.azurewebsites.net"
    }
}
   

