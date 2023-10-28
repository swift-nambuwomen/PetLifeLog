//
//  Utils.swift
//  petLifeLog
//
//  Created by jso on 2023/10/13.
//

import UIKit
import Alamofire

class Utils {

    static func displayAlert(title: String, message: String, comfirm:String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Default", style: .default, handler: nil)

        alertController.addAction(UIAlertAction(title: "\(comfirm)", style: .cancel))


        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("keyWindow has no rootViewController")
        }

        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
    static func delUserDefault(mode:String) {
        if mode == "user" {
            UserDefaultsKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
        } else if mode == "pet" {
            PetDefaultsKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
        } else if mode == "all"{
            UserDefaults.standard.removeObject(forKey: "isLogined")
            PetDefaultsKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
            UserDefaultsKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
        }
        UserDefaults.standard.synchronize()
    }

    
    //이미지저장
    static func uploadImageToServer<T: Decodable>(url: String, imageName: String, image: UIImage, parameters: [String: Any], responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void)  {
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
            
        if let imageData = image.pngData() {
            AF.upload(multipartFormData: { multipart in
                for (key, value) in parameters {
                    multipart.append("\(value)".data(using: .utf8)!, withName: key)
                }
                //테이블 이미지컬럼명
                multipart.append(imageData, withName: "profile", fileName: imageName, mimeType: "image/png")
            }, to: url, method: .post, headers: headers)
            .responseDecodable(of: T.self) { response in
                completion(response.result.mapError { $0 as Error })
            }
        }
    }
    //호출시
//    let parameters: [String: Any] = [
//        "name": name,
//        "birth": datePicker.date.toDateString(),
//        "breed": breed,
//        "sex": sexType,
//        "user": USER_ID
//    ]
//
//    uploadImageAndDataWith(url: "your_server_url",
//                           parameters: parameters,
//                           image: selectedImage) { result in
//        switch result {
//        case .success:
//            let alert = UIAlertController(title: "확인", message: "등록 되었습니다.", preferredStyle: .alert)
//            let action = UIAlertAction(title: "확인", style: .default)
//            alert.addAction(action)
//
//            // 여기에서는 알림을 표시하는 것이 아니라 호출자 함수에서 처리하도록 수정하실 수도 있습니다.
//
//        case .failure(let error):
//            // POST 요청 중 오류가 발생한 경우
//            // 에러 처리 로직을 추가하세요.
//            print(error)
//        }
//    }

}


