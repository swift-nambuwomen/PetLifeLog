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
    var paths = "api/pet/act"
    var params:Parameters = [ // 알라모 파이어용 파라미터. 6개 액션의 공통된 2개는 미리 넣어둠.
        "pet":pet_id,
        "act_date":selected_date
    ]
    
    // 산책
    @IBOutlet weak var walk_time: UIDatePicker!
    // 배변
    @IBOutlet weak var poo_time: UIDatePicker!
    @IBOutlet weak var poo_type: UISegmentedControl!
    @IBOutlet weak var poo_color: UISegmentedControl!
    // 식사
    @IBOutlet weak var feed_time: UIDatePicker!
    @IBOutlet weak var feed_type: UISegmentedControl!
    // 병원
    @IBOutlet weak var hospital_time: UIDatePicker!
    @IBOutlet weak var hospital_type: UISegmentedControl!
    // 미용
    @IBOutlet weak var hair_time: UIDatePicker!
    // 몸무게
    @IBOutlet weak var weight_time: UIDatePicker!
    @IBOutlet weak var weight: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AddPet뷰 호출 - 홈에 선택된 날짜", selected_date)
    }
    
    // MARK: 6개 액션 등록 메소드에서 공통으로 쓸 AF
    //func updateOrCreateDataViaAF(params: params, handler: <#T##() -> ()#>){
    func updateOrCreateDataViaAF(){
        print("called 액션 등록 버튼 via AF")
        let url = "\(baseURL+paths)"
        let dataRequest = AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default)
        dataRequest.responseDecodable(of: Actdetail.self) { response in
            print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")
            switch response.result {
            case .success:
                guard let result = response.value else { return }
                print("액션 POST 응답 결과", result)
                self.alert(title: "등록되었습니다.")
            case .failure(let error):
                print("액션 POST 실패", error.localizedDescription)
                self.alert(title: "등록 실패")
                break
            }
        }
    }
    
    
    // MARK: - 등록 버튼 - 6개 액션 기록 저장하기. 저장된 데이터를 가지고 홈으로 돌아갈 수 있도록 스토리보드에서 unwind함
    @IBAction func AddFood(_ sender: Any) {
        print("사료 등록")
        // 식사타입 세그먼트바에 현재 선택된 값 받음
        var food_type = ""
        switch feed_type.selectedSegmentIndex {
            case 0: food_type = "사료"
            case 1: food_type = "간식"
            default: return
        }
        params = [
            "pet":pet_id,
            "act_date":selected_date,
            "act_time":feed_time.date.toTimeString(),
            "act":3,
            "feed_type":food_type
        ]
        // Alamofire의 파라미터에 대입
        self.params["act_time"] = feed_time.date.toTimeString()
        self.params["act"] = 3
        self.params["feed_type"] = food_type
        updateOrCreateDataViaAF()
    }
    
    @IBAction func AddPoo(_ sender: Any) {
        print("배변 등록")
        // 배변타입 세그먼트바에 현재 선택된 값 받음
        var ordure_type = ""
        switch poo_type.selectedSegmentIndex {
        case 0: ordure_type = "건조"
        case 1: ordure_type = "정상"
        case 2: ordure_type = "설사"
        default: return
        }
        
        // 배변컬러 세그먼트바에 현재 선택된 값 받음
        var ordure_color = ""
        switch poo_color.selectedSegmentIndex {
        case 0: ordure_color = "초코"
        case 1: ordure_color = "녹색"
        case 2: ordure_color = "노랑"
        case 3: ordure_color = "빨강"
        case 4: ordure_color = "검정"
        case 5: ordure_color = "보라"
        default: return
        }
        // Alamofire의 파라미터에 대입
        self.params["act_time"] = poo_time.date.toTimeString()
        self.params["act"] = 2
        self.params["ordure_shape"] = ordure_type
        self.params["ordure_color"] = ordure_color
        updateOrCreateDataViaAF()
    }
    
    @IBAction func AddWalk(_ sender: Any) {
        print("산책 등록")
        // Alamofire의 파라미터에 대입
        self.params["act_time"] = walk_time.date.toTimeString()
        self.params["act"] = 1
        updateOrCreateDataViaAF()
    }
    
    @IBAction func AddWeight(_ sender: Any) {
        print("체중 등록")
        // Alamofire의 파라미터에 대입
        self.params["act_time"] = weight_time.date.toTimeString()
        self.params["weight"] = Double(weight.text ?? "") ?? 0.0
        self.params["act"] = 6
        updateOrCreateDataViaAF()
    }
    
    @IBAction func AddHair(_ sender: Any) {
        print("미용 등록")
        // Alamofire의 파라미터에 대입
        self.params["act_time"] = hair_time.date.toTimeString()
        self.params["act"] = 5
        updateOrCreateDataViaAF()
        
    }
    
    @IBAction func AddHospital(_ sender: Any) {
        print("병원 등록")
        var hospital_seg = ""
        // 병원타입 세그먼트바에 현재 선택된 값 받음
        switch hospital_type.selectedSegmentIndex {
        case 0: hospital_seg = "예방접종"
        case 1: hospital_seg = "질병"
        default: return
        }
        
        // Alamofire의 파라미터에 대입
        self.params["act_time"] = hospital_time.date.toTimeString()
        self.params["hospital_type"] = hospital_seg
        self.params["act"] = 4
        updateOrCreateDataViaAF()
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
