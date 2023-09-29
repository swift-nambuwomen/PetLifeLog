//
//  PetDetailViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/28.
//

import UIKit

// TODO: 스토리보드 스택뷰 고정되게 조정 필요함

class PetDetailViewController: UIViewController {
    // var dataset = // 메인 prepare에서 넘겨 받은 데이터셋, 추후 해당 타입으로 지정해줘야 함
    
    @IBOutlet weak var ActionLabel: UILabel!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        
    }
    
    // TODO: 넘겨받은 데이터셋에서 UI내에 각 요소마다 해당하는 데이터가 있을 시 채워 넣게 해야 함.
    
    // Cell 선택시 어떤 act_name인지 받아서 해당 액션에 맞는 ui를 그리게 함.
    func drawUI() { //act_name 변수는 acts테이블에 저장된 name칼럼의 6개.
        let act_name = "배변" // TO DO : 디테일뷰 종류 선택에 따라 6개 액션 중 하나 변수로 들어오게 하기
        switch act_name {
        case "사료" : ActionLabel.text = "사료"; PooShapeView.isHidden = true; PooColorView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true
        case "배변" : ActionLabel.text = "배변"; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true
        case "병원" : ActionLabel.text = "병원"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true
        case "미용" : ActionLabel.text = "미용"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; WeightView.isHidden = true
        case "산책" : ActionLabel.text = "산책"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; WeightView.isHidden = true
        case "몸무게" : ActionLabel.text = "체중"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true;
        default:
            return
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
