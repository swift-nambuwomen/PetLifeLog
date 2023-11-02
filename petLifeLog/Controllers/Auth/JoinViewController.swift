//
//  JoinViewController.swift
//  petLifeLog
//
//  Created by jso on 2023/10/14.
//

import UIKit
import Alamofire

class JoinViewController: UIViewController {

    @IBOutlet weak var nickNameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var pwdConfirmField: UITextField!
        
    var isDuplCheck = false
    var emailPossible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 키보드 내리기
        hideKeyboard()
        nickNameTxtField.setUnderLine()
        emailTxtField.setUnderLine()
        pwdTxtField.setUnderLine()
        pwdConfirmField.setUnderLine()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func actDuplCheck(_ sender: Any) {
        guard let email = emailTxtField.text else { return }
        
        if email == "" {
            Utils.displayAlert(title: "", message: "이메일을 입력해주세요", comfirm: "OK")
        }
        
        let params:Parameters = ["email": emailTxtField.text!]
        let alamo = AF.request(email_dupl_check_url, method: .get, parameters: params)
        alamo.responseDecodable(of:[String:Int].self) { response in

            if let error = response.error {
                Utils.displayAlert(title: "", message: "시스템 오류입니다. \n 오류가 계속될경우 문의 부탁드립니다.", comfirm: "OK")
            }
            else {
             
                // 성공적으로 디코딩된 데이터 처리
                guard let result = response.value
                ,let count = result["count"] else {
                    Utils.displayAlert(title: "", message: "시스템 오류입니다. \n 오류가 계속될경우 문의 부탁드립니다!.", comfirm: "OK")
                    return
                }

                self.isDuplCheck = true
                if count > 0 {
                    Utils.displayAlert(title: "", message: "사용중인 이메일 입니다.", comfirm: "OK")
                    
                } else {
                    Utils.displayAlert(title: "", message: "사용 가능한 이메일입니다.", comfirm: "OK")
                    self.emailPossible = true
                }
            }
        }
    }
    
    @IBAction func actJoin(_ sender: Any) {

        let email = emailTxtField.text!
        let nickName =  nickNameTxtField.text!
        let password = pwdTxtField.text!
        let passwordConfirm = pwdConfirmField.text!

        
        if !isDuplCheck {
            Utils.displayAlert(title: "", message: "이메일 중복체크를 해주세요", comfirm: "OK")
            return
        }
        
        if !emailPossible {
            Utils.displayAlert(title: "", message: "사용 불가능한 이메일 입니다.", comfirm: "OK")
            return
        }
        
        if nickName == "" {
            Utils.displayAlert(title: "", message: "닉네임을 입력해주세요", comfirm: "OK")
            return
        }
        
        if password == "" {
            Utils.displayAlert(title: "", message: "비밀번호를 입력해주세요", comfirm: "OK")
            return
        }
        
        if passwordConfirm == "" {
            Utils.displayAlert(title: "", message: "비밀번호를 입력해주세요", comfirm: "OK")
            return
        }
        
        if passwordConfirm != password {
            Utils.displayAlert(title: "", message: "비밀번호를 다시한번 확인해주세요", comfirm: "OK")
            return
        }

        let strURL = "\(join_url)"
        let params:Parameters = ["email": email, "password": password, "nick_name" : nickName]
        let alamo = AF.request(strURL, method: .post, parameters: params, encoding: JSONEncoding(options: []))
        alamo.responseDecodable(of:LoginResult.self) { response in

            if let error = response.error {
                print(response.error)
                Utils.displayAlert(title: "", message: "회원가입에 실패했습니다. \n계속해서 실패할 경우 문의 부탁드립니다!.", comfirm: "OK")
            }
            else {
                // 성공적으로 디코딩된 데이터 처리
                print(response.value)
                guard let user = response.value?.user else {
                    Utils.displayAlert(title: "", message: "회원가입에 실패했습니다. \n계속해서 실패할 경우 문의 부탁드립니다!!.", comfirm: "OK")
                    return
                }
  
                UserDefaults.standard.set(true, forKey: UserDefaultsKey.isLogined.rawValue)
                UserDefaults.standard.setValue(user.id, forKey: UserDefaultsKey.userId.rawValue)
                UserDefaults.standard.setValue(user.nickName, forKey: UserDefaultsKey.nickName.rawValue)
                UserDefaults.standard.synchronize()
                
                USER_ID = UserDefaults.standard.integer(forKey: UserDefaultsKey.userId.rawValue)
                NICK_NAME = UserDefaults.standard.string(forKey: UserDefaultsKey.nickName.rawValue)
                
                PET_ID = 0
                PET_NAME = nil
                PET_IMG = nil
                
                print("회원가입후 \(USER_ID) , \(NICK_NAME)")
                
                let petStoryboard = UIStoryboard(name: "MyInfo", bundle: nil)
                if let vc = petStoryboard.instantiateViewController(identifier: "MyInfo") as? MyPagesViewController {
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            
                
            }
        }
    }
}

extension UITextField {

    func setUnderLine() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width - 10, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

}
