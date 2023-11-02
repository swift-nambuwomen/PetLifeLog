//
//  LoginViewController.swift
//  petLifeLog
//
//  Created by jso on 2023/10/12.
//

import UIKit
import Alamofire


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 내리기
        hideKeyboard()
        
        print("TARGET_IPHONE_SIMULATOR : \(TARGET_IPHONE_SIMULATOR)")
        
        if TARGET_IPHONE_SIMULATOR == 1 {
          // Simulator
//            emailTextField.text = "jsoarchi@nate.com"
//            passwordTextField.text = "1234"
        } else {
          // Device
            emailTextField.text = ""
            passwordTextField.text = ""
        }
        
        // 화면의 Back 버튼 숨김
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
    }
    
    func getOsVersion() -> String {
        return UIDevice.current.systemVersion
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func actLogin(_ sender: Any) {
        let strURL = "\(login_url)"
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }

        if email == "" {
            Utils.displayAlert(title: "", message: "이메일을 입력해주세요", comfirm: "OK")
        }
        
        if password == "" {
            Utils.displayAlert(title: "", message: "비밀번호를 입력해주세요", comfirm: "OK")
        }

        let params:Parameters = ["email": email, "password": password]
        let alamo = AF.request(strURL, method: .post, parameters: params, encoding: JSONEncoding(options: []))
        alamo.responseDecodable(of:LoginResult.self) { response in

            if let error = response.error {
                Utils.displayAlert(title: "", message: "로그인에 실패했습니다. \n이메일과 비밀번호를 다시한번 확인 부탁드립니다!.", comfirm: "OK")
            }
            else {
                // 성공적으로 디코딩된 데이터 처리
                guard let result = response.value
                ,let user = result.user else {
                    Utils.displayAlert(title: "", message: "로그인에 실패했습니다. \n이메일과 비밀번호를 다시한번 확인 부탁드립니다!!.", comfirm: "OK")
                    return
                }
                
                if result.message == "login success" {
                    
//                    UserDefaults.standard.setValue(true, forKey: "isLogined")
//                    UserDefaults.standard.setValue(user.id, forKey: "userId")
//                    UserDefaults.standard.setValue(user.nickName, forKey: "nickName")
                    UserDefaults.standard.set(true, forKey: UserDefaultsKey.isLogined.rawValue)
                    UserDefaults.standard.setValue(user.id, forKey: UserDefaultsKey.userId.rawValue)
                    UserDefaults.standard.setValue(user.nickName, forKey: UserDefaultsKey.nickName.rawValue)
                    
                    UserDefaults.standard.synchronize()
                    USER_ID = UserDefaults.standard.integer(forKey: UserDefaultsKey.userId.rawValue)
                    NICK_NAME = UserDefaults.standard.string(forKey: UserDefaultsKey.nickName.rawValue)
                    
                    if user.pets.count > 0 {
                        let pet = user.pets[0]
                        print("login pet 정보 : \(pet)")
                        UserDefaults.standard.setValue(pet.name, forKey: PetDefaultsKey.petName.rawValue)
                        UserDefaults.standard.setValue(pet.profileImage, forKey: PetDefaultsKey.petImage.rawValue)
                        UserDefaults.standard.setValue(pet.id, forKey: PetDefaultsKey.petId.rawValue)
                        
                        PET_ID = pet.id
                        PET_NAME = pet.name
                        PET_IMG = pet.profileImage
                        
                    }
                    
                    
                    

            
                    let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
//                    self.navigationController?.popToRootViewController(animated: true)
                    if let vc = homeStoryboard.instantiateViewController(identifier: "home") as? HomeViewController {
                        self.navigationController?.pushViewController(vc, animated: false)
                    }
                
                } else {
                    Utils.displayAlert(title: "", message: "로그인에 실패했습니다. \n이메일과 비밀번호를 다시한번 확인 부탁드립니다!!.", comfirm: "OK")
                }
            }
        }
        
    }
    
    @IBAction func actJoin(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "join") as? JoinViewController {
            navigationController?.pushViewController(vc, animated: true);
        }
    }
    
}
