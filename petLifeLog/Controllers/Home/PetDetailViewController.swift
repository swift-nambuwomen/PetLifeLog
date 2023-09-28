//
//  PetDetailViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/28.
//

import UIKit

//TO DO : 스토리보드 스택뷰 고정되게 조정 필요함

class PetDetailViewController: UIViewController {
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
    
    func drawUI() {
        var actionName = "hair" // TO DO : 디테일뷰 종류 선택에 따라 6개 액션 중 하나 변수로 들어오게 하기
        switch actionName {
        case "food" : ActionLabel.text = "사료"; PooShapeView.isHidden = true; PooColorView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true
        case "poo" : ActionLabel.text = "배변"; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true
        case "hospital" : ActionLabel.text = "병원"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true; WeightView.isHidden = true
        case "hair" : ActionLabel.text = "미용"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; WeightView.isHidden = true
        case "walk" : ActionLabel.text = "산책"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; WeightView.isHidden = true
        case "weight" : ActionLabel.text = "체중"; PooShapeView.isHidden = true; PooColorView.isHidden = true; FoodSelectView.isHidden = true; FoodBrandView.isHidden = true; FoodGramView.isHidden = true; HospitalSelectView.isHidden = true; ExpencesView.isHidden = true; HairSelectView.isHidden = true; TimeView.isHidden = true;
        default:
            actionName = "nothing"
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
