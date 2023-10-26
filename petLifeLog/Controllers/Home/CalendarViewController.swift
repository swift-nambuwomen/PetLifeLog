//
//  CalendarViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/10/01.
//

import UIKit

// today, selected_date는 홈컨트롤러의 글로벌 변수를 가져다 씀
class CalendarViewController: UIViewController {
    var new_date = ""
    
    @IBOutlet weak var calendar: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("캘린더뷰 호출 - 홈에 선택된 날짜", selected_date)
        setupCalendarAttribute() // 선택 가능한 날짜 범위 지정
    }
    
    func setupCalendarAttribute() {
        calendar.setDate(selected_date.toDate()!, animated: true) // 네비바 선택된 날짜가 달력에 자동선택되게
       // calendar.minimumDate = pet_birth.toDate() // 강아지 생일부터 선택 가능
        calendar.maximumDate = today.toDate() // 미래 기록은 안되게
    }
    
    
    //MARK: 캘린더 클릭시 호출될 함수
    @objc func onDateClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("onDateClicked() called")
        new_date = calendar.date.toDateString()
        
    }
    
    
    // MARK: [홈으로] 버튼 - 스토리보드상에서 unwind segue로 홈으로 연결됨.
    // MARK: [날짜선택] 버튼 - 선택해야 새로운 date가 변수에 지정, 저장되어 홈으로 보내짐
    @IBAction func setDate(_ sender: Any) {
        new_date = calendar.date.toDateString()
        print("새로 선택된 날짜 \(selected_date) 가지고")
    // TODO: 지금은 [날짜 선택] 버튼 입력 후 [홈으로] 버튼 눌러야 데이터 적용&화면 전환 됨. 모달창 바로 사라지면서 홈뷰 새 날짜에 맞춰 reload 되도록 하는 방법
//        guard let pvc = self.presentingViewController else { return }
//        self.dismiss(animated: true) {
//            pvc.present(HomeViewController(), animated: true, completion: nil)
//        }
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
