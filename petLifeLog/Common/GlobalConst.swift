//
//  GlobalConst.swift
//  petLifeLog
//
//  Created by jso on 2023/10/13.
//

import Foundation

let SITE_URL = "http://127.0.0.1:8000"

// 로그인
let login_url = "\(SITE_URL)/auth/login"

// 회원가입
let join_url = "\(SITE_URL)/auth/regist"

// 이메일중복체크
let email_dupl_check_url = "\(SITE_URL)/auth/isEmailDupl"


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
