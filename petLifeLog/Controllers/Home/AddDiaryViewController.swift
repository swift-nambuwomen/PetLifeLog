//
//  AddDiaryViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/27.
//

import UIKit
import Alamofire

// pet_id, user_id, selected_date, baseURL은 홈컨트롤러의 글로벌 변수를 가져다 씀
class AddDiaryViewController: UIViewController {
    let paths = "api/pet/diary"

    var petDiary:PetDiary!
    
    @IBOutlet weak var diaryDate: UILabel!
    @IBOutlet weak var diaryContent: UITextView!
    @IBOutlet weak var diaryOpenYN: UISwitch!
    @IBOutlet weak var diaryImgView: UIImageView!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        imgGesture()
        print("AddDiary뷰 호출 - 홈에 선택된 날짜", selected_date)
        picker.delegate = self // 카메라 피커
    }
    
    func drawUI() {
        diaryDate.text = selected_date + " 일기" // 메인에서 선택된 날짜의 일기를 추가해야 하므로 타이틀은 그 날짜로
        //TODO: 다이어리는 하루 하나 등록 가능하기에, 다이어리 기존 데이터가 있을 시 데이터 들고와서 뿌려줘야 함
        if petDiary != nil {
            diaryContent.text = petDiary.diary_content
            diaryImgView.image = UIImage(named: petDiary.diary_image ?? "no-img")
            
            if petDiary?.diary_open_yn == "Y" {
                diaryOpenYN.isOn = true
            } else {
                diaryOpenYN.isOn = false
            }
        }
    }
    
    
    // AF - 등록버튼 누를시 호출될 메소드
    func updateOrCreateDataViaAF(_ params:Parameters) {
        let url = "\(baseURL+paths)"
        print("다이어리뷰의 URL\(url)")
            
        let dataRequest = AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)

        dataRequest.responseDecodable(of: PetDiary.self) { response in
            print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")
            switch response.result {
                case .success:
                    guard let result = response.value else { return }
                    print("다이어리 POST 응답 결과", result)
                
                    // 알럿
                    let alert = UIAlertController(title: "알림", message: "등록되었습니다!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    break
                case .failure(let error):
                    print("다이어리 POST 응답 에러", error.localizedDescription)
                }
        }
    }
    
    // MARK: [뒤로] 버튼은 저장된 데이터를 가지고 홈으로 돌아갈 수 있도록 스토리보드에서 unwind함
    // [등록] 버튼
    @IBAction func addDiary(_ sender: Any) {
        // 저장할 데이터 : PetAct테이블의 act_date = selected_date, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, diary_content=텍스트필드내용, diary_image=장치내 이미지명, diary_open_yn=스위치바 상태
        var new_diary_flag = "N"
        if diaryOpenYN.isOn{
            new_diary_flag = "Y"
        }
        // 실제 필요한 것만 딕셔너리 insert해야함 null안됨
        let params:Parameters = [
            "pet":pet_id, // 장고 모델 컬럼명에 맞춰서 JSON key값은 pet_id가 아닌 pet으로 보내야함
            "user":user_id, // 마찬가지 이유로 JSON key값은 user로
            "act_date":selected_date,
            "diary_content":diaryContent.text ?? "",
            "diary_open_yn":new_diary_flag
            //"diary_image":
        ]
        updateOrCreateDataViaAF(params)
    }
    
    // TODO: 장치 이미지명 가져와서 AF에 넣기
    func getImgNamefromDevice(){
    }
    
    func addImgNameViaAF() {
        // 저장할 데이터 : PetAct테이블의 act_date = selected_date, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, diary_image=장치내 이미지명
        //var imgName:String
        let params:Parameters = [
            "pet":pet_id, // 장고 모델 컬럼명에 맞춰서 JSON key값은 pet_id가 아닌 pet으로 보내야함
            "user":user_id, // 마찬가지 이유로 JSON key값은 user로
            "act_date":selected_date,
            "diary_image":"no-img" // no-img가 아닌 장치로부터 가져온 이미지명
        ]
        updateOrCreateDataViaAF(params)
    }
    
    
    
    //MARK: 제스처인식기 생성 및 연결
    func imgGesture() {
        //제스처인식기 생성
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(onImgClicked(tapGestureRecognizer:)))
       //이미지뷰가 상호작용할 수 있게 설정
        diaryImgView.isUserInteractionEnabled = true
       //이미지뷰에 제스처인식기 연결
        diaryImgView.addGestureRecognizer(tapImageViewRecognizer)
    }
    
    //MARK: 이미지뷰 클릭시 호출될 함수 - 카메라 혹은 앨범 가져오기 알럿
    @objc func onImgClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("onImgClicked() called")
        let alert =  UIAlertController(title: "다이어리 사진", message: "사진을 앨범에서 가져오거나 카메라로 찍으세요.", preferredStyle: .actionSheet)
    
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
        else{
            print("Camera not available")
        }
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


// MARK: 카메라 익스텐션
extension AddDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        newImage = newImage?.resizeWithWidth(width: 100)
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.diaryImgView.image = newImage // 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
    }
}
