//
//  PetDetailViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/28.
//

import UIKit
import Alamofire
import Kingfisher

class PetDetailViewController: UIViewController {
    
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    
    
    //UI 그리기 위한 뷰
    @IBOutlet weak var ActionLabel: UINavigationItem!
    @IBOutlet weak var PooShapeView: UIStackView!
    @IBOutlet weak var PooColorView: UIStackView!
    @IBOutlet weak var FoodSelectView: UIStackView!
    @IBOutlet weak var FoodBrandView: UIStackView!
    @IBOutlet weak var FoodGramView: UIStackView!
    @IBOutlet weak var HospitalSelectView: UIStackView!
    @IBOutlet weak var ExpencesView: UIStackView!
    @IBOutlet weak var HairSelectView: UIStackView!
    @IBOutlet weak var TimeView: UIStackView!
    @IBOutlet weak var WeightView: UIStackView!
    
    // 데이터 넣을 용도
    @IBOutlet weak var act_time: UIDatePicker!
    @IBOutlet weak var poo_shape: UISegmentedControl!
    @IBOutlet weak var poo_color: UISegmentedControl!
    @IBOutlet weak var food_brand: UITextField!
    @IBOutlet weak var food_type: UISegmentedControl!
    @IBOutlet weak var food_gram: UITextField!
    @IBOutlet weak var hospital_type: UISegmentedControl!
    @IBOutlet weak var hair_type: UISegmentedControl!
    @IBOutlet weak var expences: UITextField!
    @IBOutlet weak var waste_time: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var memo: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    
    // 카메라에서 선택된 이미지
    var newImage: UIImage?
    
    var petAction:Actdetail! // Home뷰로부터 넘겨받은 데이터
    var params:Parameters = [ // 알라모 파이어용 파라미터. 6개 액션의 공통된 2개는 미리 넣어둠.
        "pet":PET_ID,
        "act_date":selected_date
    ]
    var act_name = "" // UI 분기용. petAction.act_name
    var act_id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        imgGesture()
        picker.delegate = self // 카메라 피커
    }
    
    
    // MARK: UI-스토리보드 하나에 6개 액션에 관한 요소들을 전부 모아둔 상태. Cell 선택시 어떤 act_name인지 받아서 해당 액션에 맞는 요소만 뽑아서 UI를 그리고 받아온 값을 대입하도록 분기함.
    func drawUI() { //act_name 변수는 acts테이블에 저장된 name칼럼의 6개.
        // 공통으로 들어갈 사항
        act_time.date = petAction.act_time.toTime() ?? "00:00".toTime()!
        memo.text = petAction.memo
        //imageView.image = petAction.actions?.memo_image // String, UIImage
        print("\(petAction.memo_image)")
        // 액션명에 따라 보여줄 UI가 다르므로 분기처리
        act_name = petAction.act_name ?? ""
        act_id = petAction.act
        
        // 등록된 이미지 있을때
        if let memoImage = petAction?.memo_image {
            btnCamera.isHidden = true
            let imageName = IMAGE_URL + "/" + memoImage
            print(imageName)
            let image = URL(string: imageName)
                //                ImageCache.default.removeImage(forKey: image.cacheKey)
                
            let processor = RoundCornerImageProcessor(cornerRadius: 20) // 모서리 둥글게
            
            imageView?.kf.indicatorType = .activity
            imageView?.clipsToBounds = true
            
            imageView?.kf.setImage(
                with: image,
                options: [
                    .processor(processor),
                    //                        .cacheOriginalImage
                ],
                completionHandler: nil
            )
        } else {
            btnCamera.isHidden = false
            imageView.image = nil
        }
        
        switch act_id {
        // 산책용 뷰
        case 1: ActionLabel.title = act_name; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; WeightView.isHidden = true;
            
            let myString: String = String(petAction.walk_spend_time ?? 0)
            waste_time.text = myString
            
        // 배변용 뷰
        case 2 : ActionLabel.title = act_name; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true;

            if petAction.ordure_shape == "건조" {
                poo_shape.selectedSegmentIndex = 0
            } else if petAction.ordure_shape == "정상" {
                poo_shape.selectedSegmentIndex = 1
            } else {
                poo_shape.selectedSegmentIndex = 2
            }
            
            // 받아온 데이터의 액션명에 따라 UI뷰의 세그먼트바 위치에 미리 선택되어있게 함
            switch petAction.ordure_color {
                case "초코": poo_color.selectedSegmentIndex = 0
                case "녹색": poo_color.selectedSegmentIndex = 1
                case "노랑": poo_color.selectedSegmentIndex = 2
                case "갈색": poo_color.selectedSegmentIndex = 3
                case "빨강": poo_color.selectedSegmentIndex = 4
                case "검정": poo_color.selectedSegmentIndex = 5
                case "보라": poo_color.selectedSegmentIndex = 6
                default: return
            }
            
        //사료용 뷰
        case 3 : ActionLabel.title = act_name; PooShapeView.isHidden = true; PooColorView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true;
            food_brand.text = petAction.feed_name;
            food_gram.text = String(petAction.feed_amount ?? 0);
            
            if petAction.feed_type == "사료" {
                food_type.selectedSegmentIndex = 0
            } else {
                food_type.selectedSegmentIndex = 1
            }
            
        //병원용 뷰
        case 4 : ActionLabel.title = act_name; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true;

            if petAction.hospital_type == "예방접종" {
                hospital_type.selectedSegmentIndex = 0
            } else {
                hospital_type.selectedSegmentIndex = 1
            }
            
            let myString: String = String(petAction.hospital_cost ?? 0)
            expences.text = myString
            
        //미용용 뷰
        case 5 : ActionLabel.title = act_name; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true;
            
            let myString: String = String(petAction.beauty_cost ?? 0)
            expences.text = myString
            
            if petAction.beauty_type == "셀프" {
                hair_type.selectedSegmentIndex = 0
            } else {
                hair_type.selectedSegmentIndex = 1
            }

        //몸무게용 뷰
        case 6 : ActionLabel.title = act_name; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true;
            
            let myString: String = String(petAction.weight ?? 0)
            weight.text = myString

        default:
            return
        }
    }
    
    
    
    //MARK: 제스처인식기 생성 및 연결
    func imgGesture() {
        //제스처인식기 생성
        let tapImageViewRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(onImgClicked(tapGestureRecognizer:)))
       //이미지뷰가 상호작용할 수 있게 설정
        imageView.isUserInteractionEnabled = true
       //이미지뷰에 제스처인식기 연결
        imageView.addGestureRecognizer(tapImageViewRecognizer)
    }
    
    //MARK: 이미지뷰 클릭시 호출될 함수 - 카메라 혹은 앨범 가져오기 알럿
    @objc func onImgClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("onImgClicked() called")
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
        let del =  UIAlertAction(title: "삭제", style: .destructive) { (action) in
            self.deleteImageAF()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        
        alert.addAction(del)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func actCamera(_ sender: Any) {
        print("onImgClicked() called")
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
        let library =  UIAlertAction(title: "앨범에서 선택", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라로 촬영", style: .default) { (action) in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        
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
    
    // MARK: [등록]버튼 AF -> [뒤로]버튼 데이터 들고갈 수 있게 스토리보드상에서 unwind segue로 홈으로 연결함
    @IBAction func putData(_ sender: Any) {
        // 현재 뷰의 데이터에 맞는 UI에서 파라미터를 얻는다.
            switch act_id {
            case 1 : updateWalk()
            case 2 : updatePoo()
            case 3 : updateFood()
            case 4 : updateHospital()
            case 5 : updateHair()
            case 6 :updateWeight()
            default:return
        }
    }
    
    func deleteImageAF() {
        self.params["memo_image"] = ""
        switch act_id {
        case 1 : updateWalk()
        case 2 : updatePoo()
        case 3 : updateFood()
        case 4 : updateHospital()
        case 5 : updateHair()
        case 6 :updateWeight()
        default:return
        }
        
    }
    
    @IBAction func delConfirm() {
        let alert = UIAlertController(title: "", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        
        let actionOK = UIAlertAction(title: "확인", style: .default, handler: deleteAct)
        
        let actionCancel = UIAlertAction(title: "취소", style: .default) { _ in
            
        }
        
        present(alert, animated: true)
        alert.addAction(actionCancel)
        alert.addAction(actionOK)
    }
    
    func deleteAct(action:UIAlertAction) {
        let url = "\(actReg_url)/\(petAction.id)"
        print("parameter값",params)
        let dataRequest = AF.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default)
        dataRequest.responseDecodable(of: [String:String].self) { response in
            // print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")
            switch response.result {
            case .success:
                guard let result = response.value else { return }
                NotificationCenter.default.post(name: NSNotification.Name("DataInsertSuccess"), object: nil, userInfo: nil)
                self.dismiss(animated: true)
//                    print("액션 수정 PUT 응답 결과", result)
                self.alert(title: "수정되었습니다.")
            case .failure(let error):
                print("액션 수정 PUT 에러", error)
                self.alert(title: "실패했습니다.")
                break
            }
        }
    }
    
    // 알라모 파이어로 통신
    func updateDataViaAF(){
        
        print("called 액션 수정 버튼 via AF")
        let pk = petAction.id
        let paths = "api/pet/act/\(pk)"
        
        
        print("image test")
        if let memoImage = newImage {
            let url = "\(actImageReg_url)/\(pk)"
            let fileName = "\(UUID().uuidString).png"
            Utils.uploadImageToServer(url: url,
                                   imageName: fileName,
                                   image: memoImage,
                                   parameters: params,
                                      responseType: Actdetail.self) {result in
                    print(result)
                    switch result {
                    case .success:
                        let alert = UIAlertController(title: "확인", message: "등록 되었습니다.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "확인", style: .default)
                        alert.addAction(action)
                        NotificationCenter.default.post(name: NSNotification.Name("DataInsertSuccess"), object: nil, userInfo: nil)
                        // 여기에서는 알림을 표시하는 것이 아니라 호출자 함수에서 처리하도록 수정하실 수도 있습니다.
                        self.dismiss(animated: true)
            
                    case .failure(let error):
                        // POST 요청 중 오류가 발생한 경우
                        // 에러 처리 로직을 추가하세요.
                        print(error)
                    }
                }
                                      
            
        } else {
            let url = "\(actReg_url)/\(pk)"
            print("parameter값",params)
            let dataRequest = AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            dataRequest.responseDecodable(of: Actdetail.self) { response in
                // print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")
                switch response.result {
                case .success:
                    guard let result = response.value else { return }
                    NotificationCenter.default.post(name: NSNotification.Name("DataInsertSuccess"), object: nil, userInfo: nil)
                    self.dismiss(animated: true)
//                    print("액션 수정 PUT 응답 결과", result)
                    self.alert(title: "수정되었습니다.")
                case .failure(let error):
                    print("액션 수정 PUT 에러", error)
                    self.alert(title: "실패했습니다.")
                    break
                }
            }
        }
    }
    
    
    // MARK: - UI에 따라 보여지는 필드들이 다르므로 분기해서 데이터를 얻음-> Params대입-> AF호출
    func updateWalk() {
        print("산책 수정")
        // Alamofire의 파라미터에 대입
        self.params["act_time"] = act_time.date.toTimeString()
        self.params["act"] = 1
        self.params["walk_spend_time"] = Int(waste_time.text ?? "") ?? 0
        self.params["memo"] = memo.text ?? ""
        updateDataViaAF()
    }
    
    func updatePoo() {
        print("배변 수정")
        // 배변타입 세그먼트바에 현재 선택된 값 받음
        var ordure_type = ""
        switch poo_shape.selectedSegmentIndex {
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
        case 3: ordure_color = "갈색"
        case 4: ordure_color = "빨강"
        case 5: ordure_color = "검정"
        case 6: ordure_color = "보라"
        default: return
        }
        
        // Alamofire의 파라미터에 대입
        self.params["act_time"] = act_time.date.toTimeString()
        self.params["act"] = 2
        self.params["ordure_shape"] = ordure_type
        self.params["ordure_color"] = ordure_color
        self.params["memo"] = memo.text ?? ""
        print("zzzzz")
        updateDataViaAF()
    }
    
    func updateFood() {
        print("사료 수정")
        // 사료타입 세그먼트바에 현재 선택된 값 받음
        var food_name = ""
        switch food_type.selectedSegmentIndex {
        case 0: food_name = "사료"
        case 1: food_name = "간식"
        default: return
        }

        // Alamofire의 파라미터에 대입
        self.params["act_time"] = act_time.date.toTimeString()
        self.params["act"] = 3
        self.params["feed_type"] = food_name
        self.params["feed_name"] = food_brand.text ?? ""
        self.params["feed_amount"] = Int(food_gram.text ?? "")
        self.params["memo"] = memo.text ?? ""
        updateDataViaAF()
    }
    
    func updateHospital() {
        print("병원 수정")
        // 병원타입 세그먼트바에 현재 선택된 값 받음
        var hospital_seg = ""
        switch hospital_type.selectedSegmentIndex {
        case 0: hospital_seg = "예방접종"
        case 1: hospital_seg = "질병"
        default: return
        }

        // Alamofire의 파라미터에 대입
        self.params["act_time"] = act_time.date.toTimeString()
        self.params["act"] = 4
        self.params["hospital_type"] = hospital_seg
        self.params["hospital_cost"] = Int(expences.text ?? "") ?? 0
        self.params["memo"] = memo.text ?? ""
        updateDataViaAF()
    }
    
    func updateHair() {
        print("미용 수정")
        // 미용타입 세그먼트바에 현재 선택된 값 받음
        var beauty_type = ""
        if hair_type.selectedSegmentIndex == 0 {
            beauty_type = "셀프"
        } else {
            beauty_type = "미용실"
        }
        
        // Alamofire의 파라미터에 대입
        self.params["act_time"] = act_time.date.toTimeString()
        self.params["act"] = 5
        self.params["beauty_type"] = beauty_type
        self.params["beauty_cost"] = Int(expences.text ?? "") ?? 0
        self.params["memo"] = memo.text ?? ""
        updateDataViaAF()
    }
    
    func updateWeight() {
        print("체중 수정")
        // Alamofire의 파라미터에 대입
        self.params["act_time"] = act_time.date.toTimeString()
        self.params["act"] = 6
        self.params["weight"] = Double(weight.text ?? "") ?? 0.0
        self.params["memo"] = memo.text ?? ""
        updateDataViaAF()
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
extension PetDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.imageView.image = newImage // 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
    }
}


// MARK: 이미지 리사이즈
extension UIImage {
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
