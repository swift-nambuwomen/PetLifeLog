//
//  AddPetActionViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/27.
//

import UIKit
import Alamofire

// pet_id, user_id, selected_date, baseURL은 홈컨트롤러의 글로벌 변수를 가져다 씀
class AddPetActionViewController: UIViewController {
    var paths = "pet/act"
    var params:Parameters = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddPet뷰 호출 - 홈에 선택된 날짜", selected_date)
    }
    
    // MARK: 6개 액션 등록 메소드에서 공통으로 쓸 AF
    func postDataViaAF(params:Parameters, handler:()->()){
        let url = "\(baseURL+paths)"
        
        //TODO: theParams += param 딕셔너리 extension 만들어서 합치기
        var theParams:Parameters = [
            "pet":pet_id, // 장고 모델 컬럼명에 맞춰서 JSON key값은 pet_id가 아닌 pet으로 보내야함
            "act_date":selected_date
            // "user_id":user_id
        ]
        //let dataRequest = AF.request(url, method: .get, parameters: params)
        AF.request(url, method: .post, parameters: theParams, encoding: JSONEncoding.default).responseDecodable(of: Actdetail.self) { response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")
            switch response.result {
            case .success:
                //TODO: (응답 받아서 알럿)
                
                self.dismiss(animated: true) // 등록 후 홈뷰로 가고 홈뷰를 새로 고침 홈뷰에 will로?
            case .failure(let error):
                print("액션 POST 에러", error)
                break
            }
        }
    }
    
    
    // MARK: - 등록 버튼 - 6개 액션 기록 저장하기. 저장된 데이터를 가지고 홈으로 돌아갈 수 있도록 스토리보드에서 unwind함
    @IBAction func AddFood(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =3 && pet_act_detail테이블의 feed_type
        params = [
            "act_id":3,
            "feed_type":""
        ]
        // postDataViaAF(params: params, handler: <#T##() -> ()#>)
    }
    
    
    @IBAction func AddPoo(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =2 && pet_act_detail테이블의 ordure_shape=?, ordure_color=?
        params = [
            "act_id":2,
            "ordure_shape":"",
            "ordure_color":""
        ]
        // postDataViaAF(params: params, handler: <#T##() -> ()#>)
    }
    
    
    @IBAction func AddWalk(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =1
        params = [
            "act_id":1
        ]
        // postDataViaAF(params: params, handler: <#T##() -> ()#>)
    }
    
    
    @IBAction func AddWeight(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =6 && pet_act_detail테이블의 weight=?
        params = [
            "act_id":6,
            "weight":0
        ]
        // postDataViaAF(params: params, handler: <#T##() -> ()#>)
    }
    
    @IBAction func AddHair(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =5
        params = [
            "act_id":5,
        ]
        // postDataViaAF(params: params, handler: <#T##() -> ()#>)
    }
    
    
    @IBAction func AddHospital(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= 해당 날짜, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =4 && pet_act_detail 테이블의 hospital_type = ?
        params = [
            "act_id":4,
            "hospital_type":""
        ]
        // postDataViaAF(params: params, handler: <#T##() -> ()#>)
    }
    
    
    // MARK: - 취소 버튼 - 저장없이 창 닫기
    @IBAction func closeView1(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeView2(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeView3(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeView4(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeView5(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeView6(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
