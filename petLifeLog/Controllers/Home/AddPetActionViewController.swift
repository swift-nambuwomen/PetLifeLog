//
//  AddPetActionViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/27.
//

import UIKit

class AddPetActionViewController: UIViewController {

    var selectedDate = "" // 홈뷰컨트롤러에서 네비바상에 선택한 날짜 건네 받음. pet_act테이블의 act_date로 저장용.
    
    // TODO: 접속자 정보 받아와 구현
    var pet_id = "" // 접속자 id의 선택된 강아지 id
    var user_id = "" // 접속자 id
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // TODO: 6개 액션 등록 메소드에서 공통으로 쓸 데이터 세팅용 메소드
    func setDataset() {
        //
    }

    
    // MARK: - 등록 버튼 - 6개 액션 기록 저장하기. 저장된 데이터를 가지고 홈으로 돌아갈 수 있도록 스토리보드에서 unwind함
    @IBAction func AddFood(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =3 && pet_act_detail테이블의 feed_type
        
        setDataset()
    }
    
    
    @IBAction func AddPoo(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =2 && pet_act_detail테이블의 ordure_shape=?, ordure_color=?
        
        setDataset()
    }
    
    
    @IBAction func AddWalk(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =1
        
        setDataset()
    }
    
    
    @IBAction func AddWeight(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =6 && pet_act_detail테이블의 weight=?
        
        setDataset()
    }
    
    @IBAction func AddHair(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =5
        
        setDataset()
    }
    
    
    @IBAction func AddHospital(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= 해당 날짜, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, act_id =4 && pet_act_detail 테이블의 hospital_type = ?
        
        setDataset()
    }
    
    
    // MARK: - 취소 버튼 - 저장없이 창 닫기
    @IBAction func closeView1(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeView2(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeView3(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeView4(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeView5(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeView6(_ sender: Any) {
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
