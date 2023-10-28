//
//  PetInfoViewController.swift
//  TeamProject
//
//  Created by hope1049 on 2023/09/23.
//

import UIKit
import PhotosUI
import Alamofire
import Kingfisher

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
        
        initPet()
        
        getPetInfo()
    }
    
    //컨트롤 초기화
    func initPet()
    {
        //텍스트필드
        txtName.borderStyle = .none
        txtBreed.borderStyle = .none
        
        let bottomName = CALayer()
        bottomName.frame = CGRect(x: 0.0, y: txtName.frame.size.height - 1, width: txtName.frame.size.width, height: 1.0)
        bottomName.backgroundColor = UIColor.gray.cgColor //테두리 색

        let bottomBreed = CALayer()
        bottomBreed.frame = CGRect(x: 0.0, y: txtName.frame.size.height - 1, width: txtBreed.frame.size.width, height: 1.0)
        bottomBreed.backgroundColor = UIColor.gray.cgColor //테두리 색
        
        txtName.layer.addSublayer(bottomName)
        txtBreed.layer.addSublayer(bottomBreed)
        
        //세그먼트
        sexseg.selectedSegmentIndex = 0
        sexseg.removeSegment()
        self.sexseg.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.blue,
                .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
            ],
            for: .selected
        )

        //사진
        camera.sourceType = .camera
        camera.delegate = self
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        album = PHPickerViewController(configuration: config)
        album?.delegate = self
        camera.delegate = self
        
        imageview.isUserInteractionEnabled = true //이미지뷰에 클릭허용
        
        //탭 제스처 생성 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageview.addGestureRecognizer(tapGesture)
        
        self.view.addSubview(imageview)
        
        //달력
        datePicker.addTarget(self, action: #selector(actDatePicker(_:)), for: .valueChanged)
    }
    
    //초기 화면 데이터
    func getPetInfo() {
        if petId != 0 {
            txtName.text = pet[0].name
            
            if let name = txtName.text {
                lblTitle.text = "\(name)의 정보 수정"
            } else {
                lblTitle.text = "이름 정보가 없습니다"
            }
            
            
            petId = pet[0].id
            txtBreed.text = pet[0].breed
            
            if pet[0].profileImage != "" && IMAGE_URL != "" {
                let imageName = IMAGE_URL + "/" + pet[0].profileImage
                
                if let image = URL(string: imageName) {
                    ImageCache.default.removeImage(forKey: image.cacheKey)
                    
                    let processor = RoundCornerImageProcessor(cornerRadius: 20) // 모서리 둥글게
                    
                    imageview?.kf.indicatorType = .activity
                    imageview?.clipsToBounds = true
                    imageview?.layer.cornerRadius = 55
                    
                    imageview?.kf.setImage(
                      with: image,
                      placeholder: UIImage(systemName: "photo"),
                      options: [
                              .processor(processor),
                              .cacheOriginalImage
                          ],
                      completionHandler: nil
                    )
                }
            }
            
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

        }
    }
    
    //==========================버튼, 달력 이벤트================================
    
    @IBAction func actDeleteImage(_ sender: Any) {
        let url = SITE_URL + "/api/pet/delete/\(petId)"
        
        if imageview.image != nil{
            updatePetWithImage(url: url) //주소만 변경
        }
    }
    
    //달력 선택시
    @IBAction func actDatePicker(_ sender: UIDatePicker) {
        view.endEditing(true)
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    //세그먼트 선택시 색상 변경
    @IBAction func actSexSegment(_ sender: Any) {
        let selected: [NSAttributedString.Key:Any] = [.foregroundColor:UIColor.blue]
        
        sexseg.setTitleTextAttributes(selected, for: .selected)
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
        var url = ""
        
        //등록, 수정구분 -> 이미지 있는지 없는지 체크하여 저장
        //수정
        if petId != 0 {
            if let image = selectedImage {
                url = SITE_URL + "/api/pet/update/\(petId)"
                updatePetWithImage(url: url)
            }else{
                url = SITE_URL + "/api/pet/petupdate/\(petId)"
                updatePet(url: url)
            }
        }else{
            //이미지 데이터가 있으면 처리
            if let image = selectedImage {
                //let url = "http://127.0.0.1:8000/api/pet/create"
                url = SITE_URL + "/api/pet/create"
                insertPetWithImage(url: url)
                //이미지 데이터가 없으면 처리
            } else {
                // 이미지가 nil인 경우 처리
                //let url = "http://127.0.0.1:8000/api/pet/petcreate"
                url = SITE_URL + "/api/pet/petcreate"
                insertPet(url: url)
            }
        }
    }
    
    //================================사진선택==========================================
    @objc func imageViewTapped(){
        let alert = UIAlertController(title: "이미지선택", message: "", preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "사진찍기", style: .default) { action in
            self.camera.sourceType = .camera
            self.present(self.camera, animated: false) }
        alert.addAction(actionCamera)
        
        let actionPhoto = UIAlertAction(title: "사진 보관함", style: .default) { action in
            self.camera.sourceType = .photoLibrary
            self.present(self.camera, animated: false) }
        alert.addAction(actionPhoto)
        
        let actionPhotoDelete = UIAlertAction(title: "사진 삭제", style: .destructive) { action in }
        alert.addAction(actionPhotoDelete)
        
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
    func insertPetWithImage(url: String){
        //함수 매개변수는 POST할 데이터, url
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        setInput()
        let fileName = "\(UUID().uuidString).png"
        let body : Parameters = [
                "id": 0,
                "name": name,
                "profile": fileName,
                "birth": datePicker.date.toDateString(),
                "breed": breed,
                "sex": sexType,
                "user": USER_ID
        ]
        print(body)
            
        if let imageData = selectedImage?.pngData() {
            AF.upload(multipartFormData: { multipart in
                for (key, value) in body {
                    multipart.append("\(value)".data(using: .utf8)!, withName: key)
                }
                multipart.append(imageData, withName: "profile", fileName: fileName, mimeType: "image/png")
                
            }, to: url, method: .post, headers: headers)
            .responseDecodable(of:Pets.self) { response in
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
        }else{
            
        }

    }
    
    //==================== 강아지 정보 신규등록 ============================
    func insertPet(url: String) {
        setInput()
        
        // [http 요청 파라미터 지정 실시]
        let queryString : Parameters = [
            "id": 0,
            "name": name,
            "profile_image": "",
            "birth": datePicker.date.toDateString(),
            "breed": breed,
            "sex":sexType,
            "user": USER_ID
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
    func updatePetWithImage(url: String){
        
        let headers: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        setInput()
        let fileName = "\(UUID().uuidString).png"
        
        if imageview.image != nil{
            let body : Parameters = [
                "id": petId,
                "name": name,
                "profile": fileName,
                "birth": datePicker.date.toDateString(),
                "breed": breed,
                "sex": sexType,
                "user": USER_ID
            ]
            
            print(body)
            if let originalImage = imageview.image {
                let resizedImage = resizeImage(originalImage, targetSize: CGSize(width: 200, height: 200))
                
                if let imageData = resizedImage.pngData() {
                    AF.upload(multipartFormData: { multipart in
                        for (key, value) in body {
                            multipart.append("\(value)".data(using: .utf8)!, withName: key)
                        }
                        multipart.append(imageData, withName: "profile", fileName: fileName, mimeType: "image/png")
                        
                    }, to: url, method: .put, headers: headers)
                    .responseDecodable(of:Pets.self) { response in
                        switch response.result {
                        case .success:
                            let alert = UIAlertController(title: "확인", message: "수정되었습니다.", preferredStyle: .alert)
                            let action = UIAlertAction(title: " 확인", style: .default)
                            alert.addAction(action)
                            
                            self.present(alert, animated: true)
                            
                            break
                        case .failure(let error):
                            print("이미지 업로드 실패 : \(error)")
                        }
                    }
                }
            }
            
        }else{
            print("이미지가 없습니다.")
            return
        }

    }
    
    func updatePet(url: String) {
        setInput()
        
        // [http 요청 파라미터 지정 실시]
        let queryString : Parameters = [
            "id":petId,
            "name": name,
            "profile_image": "",
            "birth": datePicker.date.toDateString(),
            "breed": breed,
            "sex": sexType,
            "user": USER_ID
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
                print(response.debugDescription)
                break
            }
        }
        
    }
    
    //이미지 삭제
    func deletePetImage(url: String){
        
    }
    
    //pet 데이터 삭제
    func deletePet(url: String){
        
    }
    
    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
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
//            // 이미지를 저장하고 URL을 가져올 수 있습니다
//            if let image = saveImageToDocumentsDirectory(image) {
//               print("Image URL: \(image)")
//               imageURL = image
//            }
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

//extension UIImage {
//    /// 이미지의 용량을 줄이기 위해서 리사이즈.
//    /// - 가로, 세로 중 짧은 것이 720 보다 작다면 그대로 반환.
//    /// - 가로, 세로 중 짧은 것이 720 보다 크다면 720 으로 리사이즈해서 반환.
//    func resize(newWidth: CGFloat) -> UIImage? {
//        let width = self.size.width
//         let height = self.size.height
//         let resizeLength: CGFloat = 720.0
//
//         var scale: CGFloat
//
//         if height >= width {
//             scale = width <= resizeLength ? 1 : resizeLength / width
//         } else {
//             scale = height <= resizeLength ? 1 :resizeLength / height
//         }
//
//         let newHeight = height * scale
//         let newWidth = width * scale
//         let size = CGSize(width: newWidth, height: newHeight)
//         let render = UIGraphicsImageRenderer(size: size)
//         let renderImage = render.image { _ in
//             self.draw(in: CGRect(origin: .zero, size: size))
//         }
//         return renderImage
//    }
//
    
    
    
//    func asImage() -> UIImage {
//        let render = UIGraphicsImageRenderer(bounds: bounds)
//        return render.image { renderContext in
//            layer.render(in: renderContext.cgContext)
//        }
//    }
//}

// 세그먼트 배경 바꾸기
extension UISegmentedControl {
    func removeSegment() {
        // 배경색을 하얀색으로 설정
        setBackgroundImage(imageWithSegment(UIColor.white), for: .normal, barMetrics: .default)
        // 선택된 세그먼트의 배경색을 하얀색으로 설정
        setBackgroundImage(imageWithSegment(UIColor.white), for: .selected, barMetrics: .default)
        
        // 글자 색을 파란색으로 설정
        setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        
        // 글자와의 구분선
        //        setDividerImage(imageWithColor(UIColor.blue, size: CGSize(width: 3, height: 2)), forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
    
    func imageWithSegment(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
