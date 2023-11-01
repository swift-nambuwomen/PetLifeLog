//
//  StatsViewController.swift
//  petLifeLog
//
//  Created by jso on 2023/10/14.
//

import UIKit
import FSCalendar
import Alamofire

class StatsViewController: UIViewController {

    @IBOutlet weak var buttonsView: UIStackView!
    
    @IBOutlet weak var calendar: FSCalendar!{
        didSet{
            calendar.delegate = self
            calendar.dataSource = self
        }
    }

    var selected_date: Date = Date()
    var events:[Date] = []
    var actCode = 0;
    let dfMatter = DateFormatter()
    var allButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dfMatter.locale = Locale(identifier: "ko_KR")
        dfMatter.dateFormat = "yyyy-MM-dd"
        getActDataViaAF()
        setCalendarUI()
        
        
//        setEvents()
        print("test")
//          Utils.delUserDefault(mode: "all")
//        UserDefaults.standard.synchronize()
//
        allButtons = buttonsView.subviews.compactMap { $0 as? UIButton }
        setBtnBackColor(color: .systemGray4)
                       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setBtnBackColor(color:UIColor) {
        for btn in allButtons {
            var btnCfg = btn.configuration
            btnCfg?.background.backgroundColor = color
            btn.configuration = btnCfg
        }
    }

    @IBAction func setActCode(_ sender: UIButton) {
        print("\(sender.tag)")
        print("all buttons == \(allButtons.count)")
        
        // 버튼 초기화
        setBtnBackColor(color: .systemGray4)
        
        var config = sender.configuration
        switch sender.tag {
        case 1: config?.background.backgroundColor = UIColor(hexCode: "#AAA517")
        case 2: config?.background.backgroundColor = UIColor(hexCode: "#FF7E79")
        case 3: config?.background.backgroundColor = UIColor(hexCode: "#FA9E04")
        case 4: config?.background.backgroundColor = UIColor(hexCode: "#01B5AD")
        case 5: config?.background.backgroundColor = UIColor(hexCode: "#09BCF1")
        case 6: config?.background.backgroundColor = UIColor(hexCode: "#ABA517")
        default: config?.background.backgroundColor = .systemGray4
        }
//        sender.backgroundColor = UIColor(hexCode: "#FF7E79")
//        sender.setBackgroundColor(.blue, for: .selected)
//        sender.tintColor = UIColor.red
        sender.configuration = config
        print(sender.configuration?.baseBackgroundColor)
//        sender.configuration?.baseBackgroundColor = UIColor(hexCode: "#FF7E79")
//        sender.tintColor = UIColor(hexCode: "#FF7E79")
//        sender.configuration = config
//        let button = UIButton(configuration: config,
//          primaryAction: UIAction() { _ in
//            print("Go")
//           })
        
        self.actCode = sender.tag
        getActDataViaAF()
    }
    
    
    func setEvents(result:[String]) {
        events = []
        for dt in result {
         
            // events
            if let myEventDate = dfMatter.date(from: dt) {
                events.append(myEventDate)
            }
        }
    }
    
    func getActDataViaAF() {
        let url = "\(statsForCalendar_url)"
        print("selected_date==\(selected_date)")
        let params:Parameters = ["pet_id":PET_ID, "act_date":selected_date.toString(format: "yyyy-MM-dd"), "act_id":actCode]
        print("params : \(params)")
        let dataRequest = AF.request(url, method: .get, parameters: params)

        print("called GET ActionList")
        dataRequest.responseDecodable(of: [String].self) { [self] response in

            switch response.result {
                case .success:
                    guard let result = response.value else { return }
                    print("GET 펫액션 via AF 응답 결과", result)
                    setEvents(result: result)
                    calendar.reloadData()
                case .failure(let error):
                    print("GET 응답 에러", error.localizedDescription)

                }
            //새로운 데이터로 화면 그려주기
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                self.setupDiaryView()
//            }
        }
    }
    
    func setCalendarUI() {
        // delegate, dataSource
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        // calendar locale > 한국으로 설정
        self.calendar.locale = Locale(identifier: "ko_KR")
        
        // 상단 요일을 한글로 변경
        self.calendar.calendarWeekdayView.weekdayLabels[0].text = "일"
        self.calendar.calendarWeekdayView.weekdayLabels[1].text = "월"
        self.calendar.calendarWeekdayView.weekdayLabels[2].text = "화"
        self.calendar.calendarWeekdayView.weekdayLabels[3].text = "수"
        self.calendar.calendarWeekdayView.weekdayLabels[4].text = "목"
        self.calendar.calendarWeekdayView.weekdayLabels[5].text = "금"
        self.calendar.calendarWeekdayView.weekdayLabels[6].text = "토"
        
        
        switch actCode {
        case 1 : self.calendar.appearance.eventDefaultColor = UIColor.red
        case 2 : self.calendar.appearance.eventDefaultColor = UIColor.yellow
        default : self.calendar.appearance.eventDefaultColor = UIColor.blue
        }

//        switch actCode {
//        case 1: self.calendar.appearance.eventDefaultColor = UIColor.red
//        case 2: self.calendar.appearance.eventDefaultColor = UIColor.systemMint
//        case 3: self.calendar.appearance.eventDefaultColor = UIColor.systemCyan
//        case 4: self.calendar.appearance.eventDefaultColor = UIColor.systemPink
//        case 5: self.calendar.appearance.eventDefaultColor = UIColor.orange
//        case 6: self.calendar.appearance.eventDefaultColor = UIColor.green
//        default: self.calendar.appearance.eventDefaultColor = .systemGray4
//        }
    
        self.calendar.appearance.eventSelectionColor = UIColor.green
        
//        setEvents()
        
//        // 월~일 글자 폰트 및 사이즈 지정
//        self.calendar.appearance.weekdayFont = UIFont..SpoqaHanSans(type: .Regular, size: 14)
//        // 숫자들 글자 폰트 및 사이즈 지정
//        self.calendar.appearance.titleFont = UIFont.SpoqaHanSans(type: .Regular, size: 16)
        
//        // 캘린더 스크롤 가능하게 지정
//        self.calendar.scrollEnabled = true
//        // 캘린더 스크롤 방향 지정
//        self.calendar.scrollDirection = .horizontal
//
//        // Header dateFormat, 년도, 월 폰트(사이즈)와 색, 가운데 정렬
//        self.calendar.appearance.headerDateFormat = "YYYY년 MM월"
////        self.calendar.appearance.headerTitleFont = UIFont.SpoqaHanSans(type: .Bold, size: 20)
//        self.calendar.appearance.headerTitleColor = UIColor(named: "F5F5F5")?.withAlphaComponent(0.9)
//        self.calendar.appearance.headerTitleAlignment = .center
//
//        // 요일 글자 색
//        self.calendar.appearance.weekdayTextColor = UIColor(named: "F5F5F5")?.withAlphaComponent(0.2)
//
//        // 캘린더 높이 지정
//        self.calendar.headerHeight = 68
//        // 캘린더의 cornerRadius 지정
//        self.calendar.layer.cornerRadius = 10
//
//        // 양옆 년도, 월 지우기
//        self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0
//
//        // 달에 유효하지 않은 날짜의 색 지정
//        self.calendar.appearance.titlePlaceholderColor = UIColor.white.withAlphaComponent(0.2)
//        // 평일 날짜 색
//        self.calendar.appearance.titleDefaultColor = UIColor.white.withAlphaComponent(0.5)
//        // 달에 유효하지않은 날짜 지우기
//        self.calendar.placeholderType = .none
//
//        // 캘린더 숫자와 subtitle간의 간격 조정
//        self.calendar.appearance.subtitleOffset = CGPoint(x: 0, y: 4)
//
//        self.calendar.select(selectedDate)
    }
    
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        self.navigationController?.popViewController(animated: true)
//        self.delegate?.dateUpdated(date: date.key)
//    }

    // 선택된 날짜의 채워진 색상 지정
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//        return appearance.selectionColor
//    }
//
//    // 선택된 날짜 테두리 색상
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
//        return UIColor.white.withAlphaComponent(1.0)
//    }
//
//    // 모든 날짜의 채워진 색상 지정
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
//        return UIColor.white
//    }
//
//    // title의 디폴트 색상
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        return UIColor.white.withAlphaComponent(0.5)
//    }
//
//    // subtitle의 디폴트 색상
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
//        return UIColor.white.withAlphaComponent(0.5)
//    }
    
    // 원하는 날짜 아래에 subtitle 지정
    // 오늘 날짜에 오늘이라는 글자를 추가해보았다
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        switch dateFormatter.string(from: date) {
//        case dateFormatter.string(from: Date()):
//            return "오늘"
//        default:
//            return nil
//        }
//    }
//
//    // 날짜의 글씨 자체를 오늘로 바꾸기
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        switch dateFormatter.string(from: date) {
//        case dateFormatter.string(from: Date()):
//            return "오늘"
//        default:
//            return nil
//        }
//    }

}

extension StatsViewController: FSCalendarDataSource,FSCalendarDelegate ,FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        return events.filter("writeDate = %@", date).count
        if self.events.contains(date){
            return 1
        } else {
            return 0
        }

//        return tasks.filter("writeDate = %@", date).count
        }
    
    // Event 표시 Dot 사이즈 조정
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let eventScaleFactor: CGFloat = 1.8
        cell.eventIndicator.transform = CGAffineTransform(scaleX: eventScaleFactor, y: eventScaleFactor)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventOffsetFor date: Date) -> CGPoint {
        return CGPoint(x: 0, y: 3)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        dfMatter.dateFormat = "yyyy-MM-dd"
        print(dfMatter.string(from: date) + " 선택됨")
    }
    
//    func calendar(calendar: FSCalendar, hasEventForDate date: NSDate) -> Bool {
//        guard let events = events else {fatalError()}
//        for data in events{
//            let order = NSCalendar.currentCalendar().compareDate(data.eventDate!, toDate: date, toUnitGranularity: .Day)
//            if order == NSComparisonResult.OrderedSame{
//                let unitFlags: NSCalendarUnit = [ .Day, .Month, .Year]
//                let calendar2: NSCalendar = NSCalendar.currentCalendar()
//                let components: NSDateComponents = calendar2.components(unitFlags, fromDate: data.eventDate!)
//                datesWithEvent.append(calendar2.dateFromComponents(components)!)
//            }
//        }
//        return datesWithEvent.contains(date)
//    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("changed")
//        selected_date = Calendar.current.date(byAdding: .day, value: +1, to: calendar.currentPage)!
        selected_date = calendar.currentPage
        print(selected_date)
        getActDataViaAF()
    }
}



