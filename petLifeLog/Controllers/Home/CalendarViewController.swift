//
//  CalendarViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/10/01.
//

import UIKit

class CalendarViewController: UIViewController {

    var petBirthday = "2023-09-10" //강아지 생일. 임시데이터.
    var today = ""
    var selected_date = ""
    var new_date = ""
    
    @IBOutlet weak var calendar: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarAttribute() // 선택 가능한 날짜 범위 지정
        //calendarGesture() // 캘린더 날짜 선택시 함수 호출하도록
    }
    
    func setupCalendarAttribute() {
        calendar.setDate(selected_date.toDate()!, animated: true) // 네비바 선택된 날짜가 달력에 자동선택되게
        calendar.minimumDate = petBirthday.toDate() // 강아지 생일부터 선택 가능
        calendar.maximumDate = today.toDate() // 미래 기록은 안되게
    }
    
    //MARK: 제스처인식기 생성 및 연결
    func calendarGesture() {
        //제스처인식기 생성
        let tapDateClickedRecognizer
        = UITapGestureRecognizer(target: self, action: #selector(onDateClicked(tapGestureRecognizer:)))
       
        // 캘린더가 상호작용할 수 있게 설정
        calendar.isUserInteractionEnabled = true
        
       // 캘린더에 제스처인식기 연결
        calendar.addGestureRecognizer(tapDateClickedRecognizer)
    }
    
    //MARK: 캘린더 클릭시 호출될 함수
    //TODO: 날짜 클릭시 클릭된 날짜를 new_date에 받고 창 사라지면서 홈으로 가게 하기
    @objc func onDateClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("onDateClicked() called")
        new_date = calendar.date.toDateString()
        
    }
    
    
//    calendar.addTarget(self, action: #selector(actDatePicker(_:)), for: .valueChanged)
//    func actDatePicker(_ sender: UIDatePicker) {
//        view.endEditing(true)
//    }
    // MARK: 홈으로 버튼 - 스토리보드상에서 unwind segue로 홈으로 연결
    @IBAction func pressedDone(_ sender: Any) {
        new_date = calendar.date.toDateString()
    }
    
    // MARK: 날짜선택 버튼 - 선택해야 새로운 date가 변수에 지정, 저장되어 홈으로 보내짐
    @IBAction func setDate(_ sender: Any) {
        new_date = calendar.date.toDateString()
        print("새로 선택된 날짜", new_date)
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
