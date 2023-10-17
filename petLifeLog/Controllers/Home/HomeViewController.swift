//
//  HomeViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/26.
//

import UIKit
import Alamofire

// 테스트용 임시 데이터(홈에서 쓰이는 5개의 컨트롤러는 이 글로벌 변수의 user,pet,birth를 가져다 씀)
let user_id = 1 // 로그인 후 들고 있어야 할 user_id값
let pet_id = 1 // 로그인 후 들고 있어야 할 user_id의 현재 선택 되어있는 pet_id의 값
let pet_birth = "2021-04-16" // 로그인 후 들고 있어야 할 현재 pet의 강아지 생일

// 글로벌 변수 - 다른 컨트롤러에서도 쓰임
let baseURL = "http://127.0.0.1:8000/"
var selected_date = "" // 네비바용. 사용자가 선택한 날짜. yyyy-MM-dd.
var today = "" // < > 날짜 이동 버튼, 날짜에 따라 비활성화 처리용 대조 데이터.
let picker = UIImagePickerController()
class HomeViewController: UIViewController {
    // AF로 가져온 Act를 [actdetail]과 diary로 분리함
    var act:Act?
    var actdetail:[Actdetail]?
    var petDiary:PetDiary?
    let paths = "api/pet/act/list"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateBtn: UIButton! // 날짜 지정하기 위함
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var prevBtn: UIBarButtonItem!
    
    // 다이어리용
    @IBOutlet weak var diaryImgView: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var diaryContent: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let now = Int(Date().timeIntervalSince1970) // unixTime. 1972년 1월 1일부터로부터 몇초가 경과했는지
        setDate(now)
        today = selected_date // nextDate버튼 비활성화 처리 위하여 오늘 날짜와 비교하기 위해서 받아두기
        nextBtn.isEnabled = false // 오늘 다음 날짜의 기록은 없으니 처음엔 > 버튼 비활성화로 시작하기
        print("called 홈뷰 DidLoad")
        getActDataViaAF() // get선택 날짜의 테이블뷰 액션 셀의 row들에 보여줄 액션, 다이어리 셀에 보여줄 다이어리 data
        setupTableView() // 날짜 맞게 테이블뷰 셋업
        setupDiaryView() // 다이어리 내용 있을시 셋업
        picker.delegate = self // 카메라 피커
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkDateCaseLogic()
        getActDataViaAF() //테이블뷰 데이터도 바뀐 selected_date 날짜의 데이터로 불러오기
    }
    
    
    // MARK: UI, 데이터 셋업

    // AF - 메인 네비바상의 선택된 날짜에 현재 접속된 유저의 선택된 강아지의 기록(액션,일기)이 있다면 가져와라.
    func getActDataViaAF() {
        let url = "\(baseURL+paths)"
        let params:Parameters = ["pet_id":pet_id, "act_date":selected_date]
        let dataRequest = AF.request(url, method: .get, parameters: params)

        print("called GET ActionList")
        dataRequest.responseDecodable(of: Act.self) { [self] response in
            //print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            //print("Result: \(response.result)")
            switch response.result {
                case .success:
                    guard let result = response.value else { return }
                    print("GET 펫액션 via AF 응답 결과", result)
                    self.act = result // PetAct
                    self.actdetail = result.actdetail // PetActDetail
                    
                    // 받아온 데이터에서 다이어리 객체 세팅.
                    let the_diary_content = result.diary_content
                    let the_diary_image = result.diary_image
                    let the_diary_yn = result.diary_open_yn
                    self.petDiary = PetDiary(id: self.act?.id ?? 0, diary_image: the_diary_image, diary_content: the_diary_content, diary_open_yn: the_diary_yn)
                case .failure(let error):
                    print("GET 응답 에러", error.localizedDescription)
                    self.petDiary = nil
                    self.actdetail = nil
                }
            //새로운 데이터로 화면 그려주기
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.setupDiaryView()
            }
        }
    }
    
    // AF - 테이블뷰 셀 스와이프시 등록된 액션 삭제
    func deleteDataViaAF(_ pk:Int){
        print("called 액션 삭제 스와이프 via AF")
        let paths = "api/pet/act/\(pk)"
        let url = "\(baseURL+paths)"
        
        let dataRequest = AF.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default)
        dataRequest.responseData { response in
            switch response.result {
            case .success:
                print("액션 삭제 DELETE 응답 결과", response)
                //self.alert(title: "삭제되었습니다")
            case .failure(let error):
                self.alert(title: "삭제실패")
                print("액션 삭제 DELETE 에러", error)
                break
            }
        }
    }
    
    func setupDiaryView() {
        // 다이어리 이미지 있으면 카메라 버튼 비활성화 되게
        //cameraBtn.isHidden = false
        cameraBtn.isEnabled = true
        if petDiary?.diary_image != nil {
            //cameraBtn.isHidden = true
            cameraBtn.isEnabled = false
        }

        diaryContent.text = petDiary?.diary_content
        diaryImgView.image = UIImage(named: petDiary?.diary_image ?? "white")
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension // 동적 셀 높이
        //tableView.separatorStyle = .none //cell구분선 없애기
    }
    
    
    
    // MARK: 네비바 날짜 설정
    // 네비바 날짜가 오늘이라면 오른쪽 버튼 비활성화, 강아지생일이라면 왼쪽 버튼 비활성화
    func checkDateCaseLogic() {
        nextBtn.isEnabled = true
        prevBtn.isEnabled = true
        if selected_date == today {
            nextBtn.isEnabled = false
        }
        if selected_date == pet_birth {
            prevBtn.isEnabled = false
        }
    }

    //날짜 -1 버튼(<)
    @IBAction func prevDate(_ sender: Any) {
        let navidate = selected_date.toDate() //yyyy-MM-dd 스트링을 Date타입으로 변환
        let navidatenum = navidate!.timeIntervalSince1970 // Date타입을 unixTime으로 변환
    
        let prevDay = Int(navidatenum) - 86400 // unixTime을 Int로 변환하여 하루(86400) 빼기
        setDate(prevDay)
        checkDateCaseLogic()
        getActDataViaAF() // 테이블뷰 데이터도 바뀐 selected_date 날짜의 데이터로 불러오기
    }
    
    //날짜 +1 버튼(>)
    @IBAction func nextDate(_ sender: Any) {
        let navidate = selected_date.toDate()
        let navidatenum = navidate!.timeIntervalSince1970
        
        let nextDay = Int(navidatenum) + 86400
        setDate(nextDay)
        checkDateCaseLogic()
        getActDataViaAF() // 테이블뷰 데이터도 바뀐 selected_date 날짜의 데이터로 불러오기
    }
    
    // 날짜 연산 -> 문자열로 변환 -> 전역변수 날짜 업데이트 -> 네비바에 해당 날짜 표시
    func setDate(_ date: Int) {
        let timeInterval = TimeInterval(date) // Int를 unixTime으로 변환
        let changedDate = Date(timeIntervalSince1970: timeInterval) // unixTime을 Date타입으로 변환
        selected_date = changedDate.toDateString() // Date를 스트링으로 변환 후 selected_date갱신.갱신된 날짜에서 재연산하여야하니까 최종 변환값을 대입해줘야함.
        dateBtn.setTitle(selected_date, for:.normal) // 갱신된 날짜 보여주기
    }
    
    
    
    // MARK: 카메라
    @IBAction func addDiaryPic(_ sender: Any) {
        let alert =  UIAlertController(title: "다이어리 사진", message: "사진을 앨범에서 가져오거나 카메라로 찍으세요.", preferredStyle: .actionSheet)
    
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
    
    
    
    
    
    // MARK: 화면 전환시 데이터 전달 - selected_date는 글로벌 변수로 둬서 모든 컨트롤러에서 공통으로 쓰도록 함
    // 상세페이지에서 선택된 cell의 액션 데이터 뿌려줘야 함.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddDiary" { // 다이어리 추가 모달창으로 가는 segue
            let targetVC = segue.destination as! AddDiaryViewController
            targetVC.petDiary = petDiary ?? nil // 일기페이지에서 기존 데이터 있으면 뿌려줘야
        }
        else if segue.identifier == "toActionDetail" { // 액션 상세 편집 모달창으로 가는 segue
            if let selected = tableView.indexPathForSelectedRow {
                if let targetVC = segue.destination as? PetDetailViewController {
                    targetVC.petAction = actdetail?[selected.row] ?? nil // 상세페이지에서 기존 데이터 뿌려줘야
                }
            }
        }
    }
    
    
    // MARK: 뒤로 가기(unwind segue). 데이터를 가지고 홈으로 돌아옵니다.
    @IBAction func unwindToHome (_ unwindSegue : UIStoryboardSegue) {
        // 캘린더 - [홈으로] 버튼으로부터
        let calendarVC = unwindSegue.source as? CalendarViewController
        if calendarVC?.new_date != "" { //new_date가 초기설정값인 ""이 아니라면
            dateBtn.setTitle(calendarVC?.new_date, for: .normal) // 받아온 new_date를 네비바 타이틀에 설정
            if let calendarVC { selected_date = calendarVC.new_date} // 받아온 new_date를 갱신날짜 변수에 지정
            checkDateCaseLogic()
            getActDataViaAF() //테이블뷰 데이터도 바뀐 selected_date 날짜의 데이터로 불러오기
            print("데이터 갱신하여 뒤로가기 unwindToHome")
        }
        
        //Add Action6개 등록버튼(신규등록)으로부터
        //let addActionVC = unwindSegue.source as? AddPetActionViewController
        
        //Add Diary 등록버튼(신규등록,수정)으로부터
        //let addDiaryVC = unwindSegue.source as? AddDiaryViewController
        
        //Action 디테일뷰 등록버튼(수정)으로부터
        //let editActionVC = unwindSegue.source as? PetDetailViewController
        
    }

}





// MARK: - 테이블뷰 세팅
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // 액션 셀 하나
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actdetail?.count ?? 0// 셀 row 수는 Act 안의 Actdetail 데이터의 개수
    }
    
    // getDataset()으로 불러들여온 dataset을 꺼내서 diaryCell,actionCell의 각 컴포넌트에 매치해서 넣어준다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath)
        
        guard let petActions = actdetail else { fatalError() }
        let petAction = petActions[indexPath.row] // 액션 하나에 대한 정보
        
        let lblActTime = cell.viewWithTag(1) as? UILabel // 시간
        let actImgView = cell.viewWithTag(2) as? UIImageView // 액션대표이미지
        let lblActName = cell.viewWithTag(3) as? UILabel // 액션명
        let lblActDetail = cell.viewWithTag(4) as? UILabel // 액션 필수 디테일
        let lblMemo = cell.viewWithTag(5) as? UILabel // 메모
        let memoImgView = cell.viewWithTag(6) as? UIImageView // 액션 메모 이미지
        
        // 시간
        lblActTime?.text = petAction.act_time
        
        // 액션명,액션대표이미지
        let act_id = petAction.act // 알라모파이어로 가져온 데이터 내의 act명
        let act_name = petAction.act_name
        switch act_id { // 액션별로 보여줄 대표 이미지가 다르므로 분기 처리
            case 1: actImgView?.image = UIImage(named: "walk")
            case 2: actImgView?.image = UIImage(named: "poo")
            case 3: actImgView?.image = UIImage(named: "food")
            case 4: actImgView?.image = UIImage(named: "hospital")
            case 5: actImgView?.image = UIImage(named: "hair")
            case 6: actImgView?.image = UIImage(named: "weight")
            default: actImgView?.image = UIImage(named: "walk")
        }
        
        // 디테일 - 액션별로 테이블뷰 셀에 보여줄 디테일이 다르므로 분기 처리(액션 라벨, 각 액션 디테일들)
        switch act_id {
            case 1: lblActName?.text = act_name; lblActDetail?.text = "\(String(petAction.walk_spend_time ?? 0))분"
            case 2: lblActName?.text = act_name; lblActDetail?.text = "\(petAction.ordure_color ?? "") \( petAction.ordure_shape ?? "")"
            case 3: lblActName?.text = act_name; lblActDetail?.text = "\(petAction.feed_type ?? "") \(petAction.feed_name ?? "") \(petAction.feed_amount ?? 0)g"
            case 4: lblActName?.text = act_name; lblActDetail?.text = "\(petAction.hospital_type ?? "") \(petAction.hospital_cost ?? 0)원"
            case 5: lblActName?.text = act_name; lblActDetail?.text = "\(String((petAction.beauty_cost) ?? 0))원"
        case 6: lblActName?.text = act_name; lblActDetail?.text =  "\(String((petAction.weight) ?? 0.0))kg"
            default: lblActName?.text = ""
        }
        
        // 다이어리 뷰의 메모
        lblMemo?.text = petAction.memo
        
        // 다이어리 뷰의 메모 사진
        memoImgView?.image = UIImage(named: "white") // Azure blob 적용전까지는 white로 세팅
        //memoImgView?.image = UIImage(named: petAction.actdetail?.memo_image ?? "white") // white 아닌 nil로는 ?

        return cell
    }
    
    
    // 테이블 액션 셀 삭제 가능하게
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var result = false
        if indexPath.section == 0 { result = true } // 액션들 섹션
        return result
    }
    
    // row를 밀어서 삭제하기
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // TODO: datasource뿐 아니라 실제 DB에서도 삭제되게 처리하기
        if editingStyle == .delete {
            //TODO: 삭제할거냐고 응답 따라 삭제
            let pk = actdetail?[indexPath.row].id ?? 0
            print("스와이프된 셀의 petActDetail의 pk는 ", pk)
            deleteDataViaAF(pk) // 알라모파이어로 DB 데이터 삭제
            actdetail?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }

}

// MARK: HTTP응답 Alert 띄우기 위함
extension UIViewController {
  typealias AlertActionHandler = ((UIAlertAction) -> Void)
  
  /// only 'title' is required parameter. you can ignore rest of them
  ///
  /// - Parameters:
  ///   - title: Title string. required.
  ///   - message: Message for alert.
  ///   - okTitle: Title for confirmation action. If you don't probide 'okHandler', this will be ignored.
  ///   - okHandler: Closure for confirmation action. If it's implemented, alertController will have two alertAction.
  ///   - cancelTitle: Title for cancel/dissmis action.
  ///   - cancelHandler: Closure for cancel/dissmis action.
  ///   - completion: Closure will be called right after the alertController presented.
  func alert(title: String,
             message: String? = nil,
             okTitle: String = "OK",
             okHandler: AlertActionHandler? = nil,
             cancelTitle: String? = nil,
             cancelHandler: AlertActionHandler? = nil,
             completion: (() -> Void)? = nil) {
    
    let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    if let okClosure = okHandler {
        let okAction: UIAlertAction = UIAlertAction(title: okTitle, style: UIAlertAction.Style.default, handler: okClosure)
      alert.addAction(okAction)
        let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: UIAlertAction.Style.cancel, handler: cancelHandler)
      alert.addAction(cancelAction)
    } else {
        if cancelTitle != nil {
    
        let cancelAction: UIAlertAction = UIAlertAction(title: okTitle, style: UIAlertAction.Style.cancel, handler: cancelHandler)
            alert.addAction(cancelAction)
      } else {
          let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: cancelHandler)
            alert.addAction(cancelAction)
      }

    }
    self.present(alert, animated: true, completion: completion)
  }
}


// MARK: - 날짜 변환. 데이터 저장시 항상 고정된 타임존으로
extension String {
    func toDate() -> Date? { // db상 받아온 act_date의 문자타입 데이터를 날짜타입으로 변환하기 위한 용도
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}


extension String {
    func toTime() -> Date? { // 액션 시간 받은거 저장하려고. 액션디테일화면의 datepicker에 받은시간대로 띄우기 위함.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

extension Date {
    func toDateString() -> String { // < > 버튼 누를시 날짜 연산하여 네비바에 날짜 포맷팅해서 입력하기 위한 용도
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: self)
    }
}

extension Date {
    func toTimeString() -> String { // 액션 시간 받으려고. 액션디테일화면의 datepicker의 시간을 DB로 보내기 위함.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return dateFormatter.string(from: self)
    }
}


// MARK: 카메라 익스텐션
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage? = nil // update 할 이미지
        newImage = newImage?.resizeWithWidth(width: 100)
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.diaryImgView.image = newImage // 받아온 이미지를 update
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        //cameraBtn.isHidden = true
        cameraBtn.isEnabled = false
        
    }
}
