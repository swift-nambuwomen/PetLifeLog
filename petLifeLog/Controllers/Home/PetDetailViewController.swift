//
//  PetDetailViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/28.
//

import UIKit

class PetDetailViewController: UIViewController {
    // var dataset = // 메인 prepare에서 넘겨 받은 데이터셋, 추후 해당 타입으로 지정해줘야 함
    
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
    
    var petAction = PetAction()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        imgGesture()
        picker.delegate = self // 카메라 피커
    }
    
    // TODO: 넘겨받은 데이터셋에서 UI내에 각 요소마다 해당하는 데이터가 있을 시 채워 넣게 해야 함.
            //이미지뷰에 String <-> UIImage 방법
    // MARK: Cell 선택시 어떤 act_name인지 받아서 해당 액션에 맞는 UI를 그리게 함.
    func drawUI() { //act_name 변수는 acts테이블에 저장된 name칼럼의 6개.
        // 공통으로 들어갈 사항
        act_time.date = (petAction.actions?.act_time.toTime())!
        memo.text = petAction.actions?.memo
        //imageView.image = petAction.actions?.memo_image // String, UIImage
        
        let act_id = petAction.act_id
        switch act_id {
        case 1 : ActionLabel.title = "산책"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; WeightView.isHidden = true;
            
            let myString: String = String(petAction.actions?.walk_spend_time ?? 0)
            waste_time.text = myString
            
        case 2 : ActionLabel.title = "배변"; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true;

            if petAction.actions?.ordure_shape == "건조" {
                poo_shape.selectedSegmentIndex = 0
            } else if petAction.actions?.ordure_shape == "정상" {
                poo_shape.selectedSegmentIndex = 1
            } else {
                poo_shape.selectedSegmentIndex = 2
            }
            
            switch petAction.actions?.ordure_color {
                case "초코": poo_color.selectedSegmentIndex = 0
                case "녹색": poo_color.selectedSegmentIndex = 1
                case "노랑": poo_color.selectedSegmentIndex = 2
                case "빨강": poo_color.selectedSegmentIndex = 3
                case "검정": poo_color.selectedSegmentIndex = 4
                case "보라": poo_color.selectedSegmentIndex = 5
                default: return
            }
            
        case 3 : ActionLabel.title = "사료"; PooShapeView.isHidden = true; PooColorView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true;
            food_brand.text = petAction.actions?.feed_name;
            food_gram.text = petAction.actions?.feed_amount;
            
            if petAction.actions?.feed_type == "사료" {
                food_type.selectedSegmentIndex = 0
            } else {
                food_type.selectedSegmentIndex = 1
            }
            
        case 4 : ActionLabel.title = "병원"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true;

            if petAction.actions?.hospital_type == "예방접종" {
                hospital_type.selectedSegmentIndex = 0
            } else {
                hospital_type.selectedSegmentIndex = 1
            }
            
            let myString: String = String(petAction.actions?.beauty_cost ?? 0)
            expences.text = myString
            
        case 5 : ActionLabel.title = "미용"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true;
            
            let myString: String = String(petAction.actions?.beauty_cost ?? 0)
            expences.text = myString
            
            if petAction.actions?.beauty_type == "셀프" {
                hair_type.selectedSegmentIndex = 0
            } else {
                hair_type.selectedSegmentIndex = 1
            }

        case 6 : ActionLabel.title = "체중"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true;
            
            let myString: String = String(petAction.actions?.weight ?? 0.0)
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
        let alert =  UIAlertController(title: "사진", message: "사진을 앨범에서 가져오거나 카메라로 찍으세요.", preferredStyle: .actionSheet)
    
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
    
    // MARK: 취소버튼 - 모달창 사라지게. 등록버튼 - 데이터 들고갈 수 있게 스토리보드상에서 unwind segue로 홈으로 연결함
    @IBAction func goHome(_ sender: Any) {
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
extension PetDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        
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
