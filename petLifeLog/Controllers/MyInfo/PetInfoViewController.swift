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
    //var saveType = "" //저장 I/U 구분
    var album:PHPickerViewController?
    var camera = UIImagePickerController()
    var name: Any = ""  // 닉네임
    var breed: Any = "" // 품종
    var sexType: Any = ""  // 성별구분
    var petId: Int = 0 // petId
    var selectedImage: UIImage?  // image파일명
    var imageURL:URL?
    
    let memberID = UserDefaults.standard.integer(forKey: "userId")
    //petId = PetDefaultsKey.petId
    
    //이미지선택 데이터?
    static let originalImage = UIImagePickerController.InfoKey.originalImage
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var btnAlbum: UIView!
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
        camera.delegate = self
        
        datePicker.addTarget(self, action: #selector(actDatePicker(_:)), for: .valueChanged)
        
        if petId != 0 {
            txtName.text = pet[0].name
            
            if let name = txtName.text {
                lblTitle.text = "\(name)의 정보 수정"
            } else {
                lblTitle.text = "이름 정보가 없습니다"
            }
            
            petId = pet[0].id
            txtBreed.text = pet[0].breed
            
            let imageName = pet[0].profileImage
            //저장한 이미지 불러오기 String(describing: UIImage(data: imageData)!)
            //let str = String(decoding: data, as: UTF8.self))
            imageview.image = UIImage(named: imageName)
            
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

    //저장버튼
    @IBAction func actSave(_ sender: Any) {
        if petId != 0 {
            saveUpdatePets()
        }else{
            //이미지 데이터가 있으면 처리
            if let image = selectedImage {
                let url = "http://127.0.0.1:8000/api/pet/create"
                //let url = SITE_URL + "/api/pet/create"
                saveInsertUploadImage(photo: image, url: url)
                //이미지 데이터가 없으면 처리
            } else {
                // 이미지가 nil인 경우 처리
                let url = "http://127.0.0.1:8000/api/pet/petcreate"
                //let url = SITE_URL + "/api/pet/petcreate"
                saveInsertPets()
            }
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
                self.sexType = "M"
            }else{
                self.sexType = "F"
            }
        }
    }
    
    //서버에 이미지 저장하기(신규등록)
    func saveInsertUploadImage(photo : UIImage, url: String){
        //함수 매개변수는 POST할 데이터, url
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        setInput()
        let fileName = "\(UUID().uuidString).png"
        
        if let imageName = selectedImage{
            let body : Parameters = [
                "id": 0,
                "name": name,
                "profile": fileName,
                "birth": datePicker.date.toDateString(),
                "breed": breed,
                "sex": sexType,
                "user": memberID
            ]
            print(body)
            if let imageData = selectedImage?.pngData() {
                AF.upload(multipartFormData: { multipart in
                    for (key, value) in body {
                        multipart.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                    multipart.append(imageData, withName: "profile", fileName: fileName, mimeType: "image/png")
                    
                }, to: url, method: .post, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        let alert = UIAlertController(title: "확인", message: "등록 되었습니다.", preferredStyle: .alert)
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
        }else{
            print("이미지가 없습니다.")
            return
        }

    }
    
    //==================== 강아지 정보 신규등록 ============================
    func saveInsertPets() {
        // [http 요청 주소 지정]
        let url = SITE_URL + "/api/pet/petcreate"

        setInput()
        
        // [http 요청 파라미터 지정 실시]
        //id, name, profile_image, birth, breed, sex, user_id
        let queryString : Parameters = [
            "id": 0,
            "name": name,
            "profile_image": "",
            "birth": datePicker.date.toDateString(),
            "breed": breed,
            "sex":sexType,
            "user": memberID
        ]
        
        print(queryString)
        
        // Alamofire를 사용하여 POST 요청 보내기
        AF.request(url, method: .post, parameters: queryString, encoding: JSONEncoding.default).responseDecodable(of: Pets.self) { response in
            print(response.result)
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "확인", message: "등록 되었습니다.", preferredStyle: .alert)
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
    //서버에 이미지 저장하기(수정)
    func saveUpdateUploadImage(photo : UIImage, url: String){
        //함수 매개변수는 POST할 데이터, url
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        setInput()
        let fileName = "\(UUID().uuidString).png"
        
        if let imageName = selectedImage{
            let body : Parameters = [
                "id": petId,
                "name": name,
                "profile": fileName,
                "birth": datePicker.date.toDateString(),
                "breed": breed,
                "sex": sexType,
                "user": memberID
            ]
            print(body)
            if let imageData = selectedImage?.pngData() {
                AF.upload(multipartFormData: { multipart in
                    for (key, value) in body {
                        multipart.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                    multipart.append(imageData, withName: "profile", fileName: fileName, mimeType: "image/png")
                    
                }, to: url, method: .put, headers: headers)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        print("이미지 업로드 성공")
                    case .failure(let error):
                        print("이미지 업로드 실패 : \(error)")
                    }
                }
            }
            
        }else{
            print("이미지가 없습니다.")
            return
        }

    }
    
    func saveUpdatePets() {
        // [http 요청 주소 지정]
        let url = SITE_URL + "/api/pet/petupdate/\(petId)"

        setInput()
        
        // [http 요청 파라미터 지정 실시]
        //id, name, profile_image, birth, breed, sex, user_id
        let queryString : Parameters = [
            "id":petId,
            "name": name,
            "profile_image": "",
            "birth": datePicker.date.toDateString(),
            "breed": breed,
            "sex": sexType,
            "user": memberID
        ]
        print(queryString)
        
        // Alamofire를 사용하여 POST 요청 보내기
        AF.request(url, method: .put, parameters: queryString, encoding: JSONEncoding.default).responseDecodable(of: Pets.self) { response in
            switch response.result {
            case .success:
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
    
    // 이미지를 문서 디렉토리에 저장하고 URL을 반환하는 함수
    func saveImageToDocumentsDirectory(_ image: UIImage) -> URL? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = documentsDirectory?.appendingPathComponent("myImage.jpg")
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL!)
                return fileURL
            } catch {
                print("Error saving image: \(error)")
                return nil
            }
        }
        return nil
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
        self.camera.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            self.imageview.image = image
            
            selectedImage = image
            // 이미지를 저장하고 URL을 가져올 수 있습니다
            if let image = saveImageToDocumentsDirectory(image) {
               print("Image URL: \(image)")
               imageURL = image
            }
        }
    }
}

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "ko_KR") as TimeZone?
        //dateFormatter.dateFormat = format
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
    //이미지 사이즈 변경
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
    
//    func asImage() -> UIImage {
//        let render = UIGraphicsImageRenderer(bounds: bounds)
//        return render.image { renderContext in
//            layer.render(in: renderContext.cgContext)
//        }
//    }
}
