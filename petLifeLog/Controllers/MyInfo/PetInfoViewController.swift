//
//  PetInfoViewController.swift
//  TeamProject
//
//  Created by hope1049 on 2023/09/23.
//

import UIKit
import PhotosUI
import Alamofire

class PetInfoViewController: UIViewController {
    var pet:[Pets] = []
    var saveType = "" //저장 I/U 구분
    var album:PHPickerViewController?
    let camera = UIImagePickerController()
    var name: Any = ""  // 닉네임
    var breed: Any = "" // 품종
    var sexType: Any = ""  // 출생일
    var petId: Any = "" // petId
    var imageFile = ""  // image파일명
    
    //이미지선택 데이터?
    static let originalImage = UIImagePickerController.InfoKey.originalImage
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var btnAlbum: UIView!
    @IBOutlet weak var lblBirth: UILabel!
    @IBOutlet weak var txtBreed: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var sexseg: UISegmentedControl!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sexseg.selectedSegmentIndex = 0
        sexseg.tintColor = UIColor.blue
        
        camera.sourceType = .camera
        camera.delegate = self
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        album = PHPickerViewController(configuration: config)
        album?.delegate = self
        
        datePicker.addTarget(self, action: #selector(actDatePicker(_:)), for: .valueChanged)
        
        if saveType == "U"{
            txtName.text = pet[0].name
            
            if let name = txtName.text {
                lblTitle.text = "\(name)의 정보 수정"
            } else {
                lblTitle.text = "이름 정보가 없습니다"
            }
            
            petId = pet[0].id
            txtBreed.text = pet[0].breed
            
            imageFile = pet[0].profileImage
            
            imageview.image = UIImage(named: imageFile)
            
            let sexType = pet[0].sex
            if sexType == "M" {
                sexseg.selectedSegmentIndex = 0
            }
            else{
                sexseg.selectedSegmentIndex = 1
            }
            
            let birth = pet[0].birth
                
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            if let date = dateFormatter.date(from: birth) {
                //datePicker.datePickerMode = .date // 시간을 선택하지 못하게 함
                datePicker.date = date
            }
            // Date Picker의 시간대 설정 (한국 시간대로 설정)
            datePicker.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        }
        else{
            lblTitle.text = "새로운 강아지 등록"
            txtName.text = ""
            txtBreed.text = ""
            sexseg.selectedSegmentIndex = 0
//            lblBirth.text = ""

        }
    }
    
    //==========================버튼, 달력 이벤트================================
    //달력 선택시
    @IBAction func actDatePicker(_ sender: UIDatePicker) {
        view.endEditing(true)
    }
    
    //취소버튼 클릭
    @IBAction func actCancel(_ sender: Any) {
        //닫히는 화면에서 home아이콘->exit아이콘클릭(ctrl누르고). unwind가 생김.
        //메인화면에서 back 액션추가해서 데이터 새로조회하도록 내용 추가
        self.performSegue(withIdentifier: "back", sender: self)
        //self.dismiss(animated: true)
    }
    
    //저장버튼 클릭
    @IBAction func actSave(_ sender: Any) {
        //var addPet:[String:String] = [:]

        if saveType == "U" {
            saveUpdatePets()
        }else{
            saveInsertPets()
        }
        
        //사진 저장
//        UIImageWriteToSavedPhotosAlbum(originalImage, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
//        let fileURL = getFileURL(imageFile)
//
//        if let image = imageview.image,
//           let data = image.jpegData(compressionQuality: 0.8) {
//            do {
//                try data.write(to: fileURL)
//            }
//            catch{
//                print("저장실패")
//            }
//        }
        //}
    }

    func saveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer)
    {
        if let error = error {
            print(error)
        } else {
            print("save")
        }
    }
    
    //================================사진선택==========================================
    @IBAction func actProfile(_ sender: UIButton) {
        let alert = UIAlertController(title: "이미지선택", message: "", preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "사진찍기", style: .default) { action in
            self.camera.sourceType = .camera
            self.present(self.camera, animated: false) }
        alert.addAction(actionCamera)
        
        let actionPhoto = UIAlertAction(title: "사진 보관함", style: .default) { action in
            self.camera.sourceType = .photoLibrary
            self.present(self.camera, animated: false) }
        alert.addAction(actionPhoto)
        
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(actionCancel)
        
        present(alert, animated: true)
    }
    
    //사진
    
    
    //입력박스 일괄 셋팅
    func setInput(){
        if let strName = txtName.text {
            let anyName: Any = strName
            self.name = anyName
        }
        
        if let strName = txtBreed.text {
            let anyName: Any = strName
            self.breed = anyName
        }
        
        if let strName = sexseg.titleForSegment(at: sexseg.selectedSegmentIndex) {
            if strName == "수컷"{
                self.sexType = "T"
            }else{
                self.sexType = "F"
            }
        }
        
    }
    
    //==================== 강아지 정보 신규등록 ============================
    func saveInsertPets() {
        // [http 요청 주소 지정]
        let url = "http://127.0.0.1:8000/api/pet/create/"

//        // [http 요청 헤더 지정]
//        let header : HTTPHeaders = [
//            "Content-Type" : "application/json"
//        ]

        setInput()
        
        // [http 요청 파라미터 지정 실시]
        //id, name, profile_image, birth, breed, sex, user_id
        let queryString : Parameters = [
            "id": 0,
            "name": name,
            "profile_image": "dog1.jpeg",
            "birth": datePicker.date.toString(),
            "breed": breed,
            "sex":sexType,
            "user":1
        ]
        
        print(queryString)
        
        // Alamofire를 사용하여 POST 요청 보내기
        AF.request(url, method: .post, parameters: queryString, encoding: JSONEncoding.default).responseDecodable(of: Pets.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                // POST 요청이 성공하고, 응답 데이터를 모델로 디코딩한 경우
                // POST 요청이 성공하고, 응답 데이터를 모델로 디코딩한 경우
                let alert = UIAlertController(title: "확인", message: "신규등록 되었습니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: " 확인", style: .default)
                alert.addAction(action)
                
                self.present(alert, animated: true)

                break
            case .failure:
                // POST 요청 중 오류가 발생한 경우
                break
            }
        }
    }
    
    //==================== 강아지 정보 수정 ============================
    func saveUpdatePets() {
        // [http 요청 주소 지정]
        let url = "http://127.0.0.1:8000/api/pet/update/\(petId)/"

        // [http 요청 헤더 지정]
//        let headers : HTTPHeaders = [
//            "Content-Type" : "application/json"
//        ]

        setInput()
        
        // [http 요청 파라미터 지정 실시]
        //id, name, profile_image, birth, breed, sex, user_id
        let queryString : Parameters = [
            "id":petId,
            "name": name,
            "profile_image": "dog2.jpeg",
            "birth": datePicker.date.toString(),
            "breed": breed,
            "sex": sexType,
            "user":1
        ]
        print(queryString)
        
        // Alamofire를 사용하여 POST 요청 보내기
        AF.request(url, method: .put, parameters: queryString, encoding: JSONEncoding.default).responseDecodable(of: Pets.self) { response in
            switch response.result {
            case .success:
                // POST 요청이 성공하고, 응답 데이터를 모델로 디코딩한 경우
                let alert = UIAlertController(title: "확인", message: "수정되었습니다.", preferredStyle: .alert)
                let action = UIAlertAction(title: " 확인", style: .default)
                alert.addAction(action)
                
                self.present(alert, animated: true)
                
                break
            case .failure:
                // POST 요청 중 오류가 발생한 경우
                print(response.debugDescription)
                break
            }
        }
        
    }
    
}

extension PetInfoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider =  results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let img = image as? UIImage {
                    DispatchQueue.main.async {
                        self.imageview.image = img
                    }
                }
            }
        }
        
        if let itemProvider =  results.last?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    if let img = image as? UIImage {
                        DispatchQueue.main.async {
                            self.imageview.image = img
                        }
                    }
            }
        }
    }
}

extension PetInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.imageview.image = image
        }
        
        //서버에 이미지 저장하기
        let selectedImage = UIImage(named: "dog1.jpeg") // 이미지 파일 이름이라고 가정
        let resizedImage = selectedImage?.resizeImage(newWidth: 300) // resizeImage 함수는 이미지를 리사이즈하는 함수로 가정
        
        if let imageData = resizedImage?.jpegData(compressionQuality: 0.5) {
            AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(imageData, withName: "file", fileName: "profileImage.jpeg", mimeType: "image/jpeg")
                },
                to: "https://petshj.blob.core.windows.net/petimage/", // 실제 서버 주소로 대체해야 합니다.
                method: .patch,
                headers: ["Content-Type": "multipart/form-data"]
            ).responseJSON { response in
                switch response.result {
                case .success:
                    if let statusCode = response.response?.statusCode, statusCode >= 200 {
                        // 성공적으로 업로드 완료
                        self.imageview.image = resizedImage
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        // 서버에서 오류 응답
                        print("서버 오류: \(response)")
                    }
                case .failure(let error):
                    // 업로드 실패
                    print("업로드 실패: \(error)")
                }
            }
        }
        else {
            // 이미지 데이터를 생성하지 못한 경우
            print("이미지 데이터 생성 실패")
        }
    }
}

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}


//extension PetInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let image = info[.originalImage] as? UIImage else { return }
//        picker.dismiss(animated: true)
//    }
//}

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage? {
        //        let scale = newWidth / self.size.width
        //        let newHeight = self.size.height * scale
        //        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        //        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        //
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
