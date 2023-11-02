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
    var params:Parameters = [ // 알라모 파이어용 파라미터
        "pet":PET_ID,
        "user":USER_ID,
        "act_date":selected_date
    ]
    
    var petDiary:PetDiary! // 이전 화면에서 받아온 다이어리
    
    @IBOutlet weak var diaryPublicYN: UISegmentedControl!
    @IBOutlet weak var diaryDate: UILabel!
    @IBOutlet weak var diaryContent: UITextView!
    @IBOutlet weak var diaryImgView: UIImageView!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 키보드 내리기
        hideKeyboard()
        drawUI()
        imgGesture()
        print("AddDiary뷰 호출 - 홈에 선택된 날짜", selected_date)
        picker.delegate = self // 카메라 피커
    }
    
    func drawUI() {
//        diaryDate.text = selected_date + " 일기" // 메인에서 선택된 날짜의 일기를 추가해야 하므로 타이틀은 그 날짜로
        //TODO: 다이어리는 하루 하나 등록 가능하기에, 다이어리 기존 데이터가 있을 시 데이터 들고와서 뿌려줘야 함
        if petDiary != nil {
            diaryContent.text = petDiary.diary_content
//            diaryImgView.image = UIImage(named: petDiary.diary_image ?? "no-img")
            print("aa :\(petDiary.diary_open_yn)")
            if petDiary?.diary_open_yn == "Y" {
                diaryPublicYN.selectedSegmentIndex = 1
//                diaryPublicYN.
            } else {
                diaryPublicYN.selectedSegmentIndex = 0
            }
        }
    }
    
    
    // AF - 등록버튼 누를시 호출될 메소드
    func updateOrCreateDataViaAF() {
//        let url = "\(baseURL+paths)"
//        print("다이어리뷰의 URL \(url)")
            
        let dataRequest = AF.request(diaryReg_url, method: .post, parameters: params, encoding: JSONEncoding.default)

        dataRequest.responseDecodable(of: PetDiary.self) { response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")
            switch response.result {
                case .success:
                    guard let result = response.value else { return }
                    print("다이어리 POST 응답 결과", result)
                    NotificationCenter.default.post(name: NSNotification.Name("DataInsertSuccess"), object: nil, userInfo: nil)
                self.dismiss(animated: true)
                case .failure(let error):
                    print("다이어리 POST 응답 에러", error.localizedDescription)
                    self.alert(title: "실패했습니다.")
                    break
                }
        }
    }
    
    // MARK: [뒤로] 버튼은 저장된 데이터를 가지고 홈으로 돌아갈 수 있도록 스토리보드에서 unwind함
    // [등록] 버튼
    @IBAction func addDiary(_ sender: Any) {
        // 공개 여부 스위치의 상태값 받아옴
        var new_diary_flag = "N"
//        if diaryOpenYN.isOn{
//            new_diary_flag = "Y"
//        }
        
        if diaryPublicYN.selectedSegmentIndex == 1{
            new_diary_flag = "Y"
        }

        self.params["diary_content"] = diaryContent.text ?? ""
        self.params["diary_open_yn"] = new_diary_flag
        //self.params["diary_image"] = 이미지명
        updateOrCreateDataViaAF()
    }
    
    @IBAction func actDissMiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // TODO: 장치 이미지명 가져와서 AF에 넣기
    func getImgNamefromDevice(){
    }
    
    // 이미지 이름 AF 통해 DB에 넣는 메소드
    func addImgNameViaAF() {
        //var imgName:String
        //self.params["diary_image"] = "no-img" // no-img가 아닌 장치로부터 가져온 이미지명
        updateOrCreateDataViaAF()
    }
    

    
    //MARK: 제스처인식기 생성 및 연결
    func imgGesture() {
        //제스처인식기 생성
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(onImgClicked(tapGestureRecognizer:)))
       //이미지뷰가 상호작용할 수 있게 설정
//        diaryImgView.isUserInteractionEnabled = true
       //이미지뷰에 제스처인식기 연결
//        diaryImgView.addGestureRecognizer(tapImageViewRecognizer)
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
