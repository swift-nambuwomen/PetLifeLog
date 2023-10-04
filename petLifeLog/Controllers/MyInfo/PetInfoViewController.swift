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
    var saveType = ""
    var album:PHPickerViewController?
    let camera = UIImagePickerController()
    
    private let datePicker = UIDatePicker()
    
    @IBOutlet weak var datePiceker: UIDatePicker!
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
        album?.delegate
        
//        let image = pet.profileImage
//        if let imageName = image {
//            imageview.image = UIImage(named: imageName)
//        }
        
        print(pet)
        
        if saveType == "U"{
            txtName.text = pet[0].name
            
            if let name = txtName.text {
                lblTitle.text = "\(name)의 정보 수정"
            } else {
                lblTitle.text = "이름 정보가 없습니다"
            }
            
            txtBreed.text = pet[0].breed
            
            let image = pet[0].profileImage
            
            imageview.image = UIImage(named: image)
            
            let sexType = pet[0].sex
            if sexType == "수컷" {
                sexseg.selectedSegmentIndex = 0
            }
            else{
                sexseg.selectedSegmentIndex = 1
            }
            
            var birth = pet[0].birth
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: birth) {
                datePicker.datePickerMode = .date // 시간을 선택하지 못하게 함
                datePicker.date = date
            }
        }
        else{
            lblTitle.text = "새로운 강아지 등록"
            txtName.text = ""
            txtBreed.text = ""
            sexseg.selectedSegmentIndex = 0
            lblBirth.text = ""

        }
    }
    
    //저장버튼 클릭
    @IBAction func actSave(_ sender: Any) {
        var addPet:[String:String] = [:]

        if saveType == "I" {
            saveInsertPets()
        }
        else{
            saveUpdatePets()
        }
        
        //사진 저장
        if let imageName = addPet["profileImage"] {
            let fileURL = getFileURL(imageName)
            
            if let image = imageview.image,
               let data = image.jpegData(compressionQuality: 0.8) {
                do {
                    try data.write(to: fileURL)
                }
                catch{
                    print("저장실패")
                }
            }
        }
    }

    @IBAction func actDatePicker(_ sender: UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        let selectedDate = datePicker.date
//        let dateString = dateFormatter.string(from: selectedDate)
//
//        // 앞에서부터 10자리만 추출
//        let substringIndex = dateString.index(dateString.startIndex, offsetBy: 10)
//        let trimmedDateString = String(dateString[..<substringIndex])
//        lblBirth.text = trimmedDateString
    }
    
    
    //사진선택
    @IBAction func actProfile(_ sender: UIButton) {
        let alert = UIAlertController(title: "이미지선택", message: "", preferredStyle: .actionSheet)
        let actionCamera = UIAlertAction(title: "사진찍기", style: .default) { action in self.present(self.camera, animated: true) }
        alert.addAction(actionCamera)
        
        let actionPhoto = UIAlertAction(title: "사진 보관함", style: .default) { action in
            if let album = self.album {
                self.present(album, animated: true)
            }
        }
        alert.addAction(actionPhoto)
        
        let actionCancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(actionCancel)
        
        present(alert, animated: true)
        
    }
    
    //사진
    //파일 가져오기(URL -> file://
    func getDocPath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileURL(_ fileName:String) -> URL {
        let docPath = getDocPath()
        let fileURL = docPath.appending(component: fileName)
        return fileURL
    }
    
    // 데이터를 저장하는 함수
    func saveInsertPets() {
        // [http 요청 주소 지정]
        let url = "http://127.0.0.1/pets/"

//        // [http 요청 헤더 지정]
//        let header : HTTPHeaders = [
//            "Content-Type" : "application/json"
//        ]

        let name = txtName.text
        let breed = txtBreed.text
        let setType = sexseg.titleForSegment(at: sexseg.selectedSegmentIndex)
        
        // [http 요청 파라미터 지정 실시]
        //id, name, profile_image, birth, breed, sex, user_id
        let queryString : Parameters = [
            "id": 0,
            "name": name,
            "profile_image": "dog1.jpeg",
            "birth": "20220901",
            "breed": breed,
            "sex":setType,
            "user_id":1
        ]
        
        AF.request(url, method: .post, parameters: queryString, encoding: URLEncoding.httpBody).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: Any] {
                    print(data)
                }
            case .failure(let error):
                print("Error: \(error)")
                return
            }
        }
    }
    
    
    // 데이터를 저장하는 함수
    func saveUpdatePets() {
        let id = 1
        
        // [http 요청 주소 지정]
        let url = "http://127.0.0.1/pets/\(id)"

        // [http 요청 헤더 지정]
        let header : HTTPHeaders = [
            "Content-Type" : "application/json"
        ]

        let name = txtName.text
        let breed = txtBreed.text
        let sexType = sexseg.titleForSegment(at: sexseg.selectedSegmentIndex)
        
        // [http 요청 파라미터 지정 실시]
        //id, name, profile_image, birth, breed, sex, user_id
        let queryString : Parameters = [
            "id":id,
            "name": name,
            "profile_image": "dog2.jpeg",
            "birth": "20230901",
            "breed": breed,
            "sex": sexType,
            "user_id":1
        ]
        
        AF.request(url, method: .put, parameters: queryString, encoding: URLEncoding.httpBody).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: Any] {
                    print(data)
                }
            case .failure(let error):
                print("Error: \(error)")
                return
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
        picker.dismiss(animated: true)
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

