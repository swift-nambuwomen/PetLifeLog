//
//  AddDiaryViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/27.
//

import UIKit

class AddDiaryViewController: UIViewController {
    
    @IBOutlet weak var diaryDate: UILabel!
    @IBOutlet weak var diaryContent: UITextView!
    var selectedDate = ""
    let sample_data_date = "2023-10-04"
    var petDiary = PetDiary()
    @IBOutlet weak var diaryImgView: UIImageView!
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        imgGesture()
        picker.delegate = self // 카메라 피커
    }
    
    func drawUI() {
        diaryDate.text = selectedDate + " 일기" // 메인에서 선택된 날짜의 일기를 추가해야 하므로 타이틀은 그 날짜로
        //TODO: 다이어리는 하루 하나 등록 가능하기에, 다이어리 기존 데이터가 있을 시 데이터 들고와서 뿌려줘야 함
        if selectedDate == sample_data_date { // 샘플 날짜
            diaryContent.text = petDiary.diary_content
            diaryImgView.image = UIImage(named: petDiary.diary_image ?? "no-img")
        }
    }
    
    
    
    // MARK: 등록 버튼 - 다이어리 수정/저장. 저장된 데이터를 가지고 홈으로 돌아갈 수 있도록 스토리보드에서 unwind함
    @IBAction func addDiary(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, diary_content=텍스트필드내용, diary_image=이미지뷰, diary_open_yn=스위치바상태
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
    
    
    // 취소 버튼
    @IBAction func closeDiary(_ sender: Any) {
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


// MARK: 카메라 익스텐션
extension AddDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.diaryImgView.image = newImage // 받아온 이미지를 update
        //petDiary.diary_image = 사용자에게 받아온 이미지를 구조체에 저장하고 서버로 보내기. UIImage -> String? 
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
    }
}
