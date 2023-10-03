//
//  HomeViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/26.
//

import UIKit

//테스트용 임시 데이터
let user_id = "admin" // 로그인 후 들고 있어야 할 user_id값
let pet_id = "adminpet" // 로그인 후 들고 있어야 할 user_id의 현재 선택 되어있는 pet_id의 값(pet_id로 강아지생일필요)
let petBirthday = "2023-09-10" //강아지 생일. 임시데이터.
let sample_data_date = "2023-10-04"
class HomeViewController: UIViewController {
    var petActions:[PetAction]?
    var petDiary:PetDiary?
    //var petActionDetails:[PetActionDetail]?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var dateBtn: UIButton! // 날짜 지정하기 위함
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var prevBtn: UIBarButtonItem!
    var selected_date = "" // 네비바용. 사용자가 선택한 날짜. yyyy-MM-dd
    var today = "" // < > 날짜 이동 버튼, 날짜에 따라 비활성화 처리용 대조 데이터
    
    // 다이어리용
    let picker = UIImagePickerController()
    @IBOutlet weak var diaryImgView: UIImageView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var diaryTime: UILabel!
    @IBOutlet weak var diaryContent: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let now = Int(Date().timeIntervalSince1970) // unixTime. 1972년 1월 1일부터로부터 몇초가 경과했는지
        setDate(now)
        
        today = selected_date // nextDate버튼 비활성화 처리 위하여 오늘 날짜와 비교하기 위해서 받아두기
        nextBtn.isEnabled = false // 오늘 다음 날짜의 기록은 없으니 처음엔 > 버튼 비활성화로 시작하기
        getDataset() // 세팅된 날짜의 테이블뷰 액션 셀의 row들에 보여줄 액션명, 다이어리 셀에 보여줄 다이어리 데이터 가져오기
        print("이 날짜 pet 액션들", petActions ?? "pet액션 데이터 없음")
        setupTableView() // 날짜 맞게 테이블뷰 셋업
        setupDiaryView() // 다이어리 내용 있을시 셋업
        picker.delegate = self // 카메라 피커
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: UI, 데이터 셋업
    // 메인 네비바상의 선택된 날짜에 현재 접속된 유저의 선택된 강아지의 기록(액션,일기)이 있다면 가져와라.
    func getDataset() {
        // let result = try JSONDecoder().decode(PetAction.self, from: data)
        // self.petActions = result.actions // 디테일
        //petActions:[PetActionDetail]?

        //샘플 데이터
        if selected_date == sample_data_date {
            petActions = [PetAction(act_id: 2, actions:PetActionDetail(act_time : "09:10", memo : "건강한듯", memo_image : "twinlake", ordure_shape : "정상", ordure_color : "초코")), PetAction(act_id: 3, actions:PetActionDetail(act_time : "10:39", memo : "어제 주문한 수제 간식. 잘 먹는다.", memo_image : "charleyrivers", feed_type:"간식", feed_name: "미국브랜드")), PetAction(act_id: 6, actions:PetActionDetail(act_time : "13:11", weight: 13.2))]
            
            petDiary = PetDiary(act_time: "13:26", diary_content: "오늘은 애견동반 호텔에 다녀왔다.")
        } else {
            petActions = nil
            petDiary = nil
        }
        
        
        
        // TODO: 메인화면 테이블뷰 액션 셀의 row들에 보여줄 액션명, 다이어리 셀에 보여줄 다이어리 데이터 가져오기. pet_act
        // API 통신 통해 pet_act테이블에서 act_date==selected_date 이면서 user_id==user_id, pet_id==pet_id에 일치하는 데이터를 1개 혹은 여러개 받는다.
        //pet_act(id,[act_date],[diary_content],[diary_image],diary_open_yn,reg_datetime,[act_id],pet_id,user_id) 이 중 4개 필요함
        // pet_act테이블에서 act_date와 diary_content와 diary_image와 act_id를 가져온다.
        // act_id가 있으면 cell 1에 한 행씩 act_date와 act_id를 보여주고,
        // act_id가 없으면(==diary라면) cell 2에 act_date와 diary_content와 diary_image를 보여준다.
        
        // TODO: 메인화면 테이블뷰 액션셀의 row들에 보여줄 각 액션의 세부 데이터 가져오기. pet_act_detail
        // pet_act_detail(id, act_time, memo, memo_image, walk_spend_time, ordure_shape, ordure_color, feed_type, feed_amount, feed_name, hospital_type, hospital_name, hospital_doctor, hospital_cost, beauty_cost, weight, petact_id)
    
        // Tag1 = 시간, Tag2 = 액션대표이미지, Tag3 = 액션명, Tag4 = 액션 필수 디테일, Tag5 = 메모, Tag6 = 액션 메모 이미지
    }
    
    func setupDiaryView() {
        diaryTime.text = petDiary?.act_time
        diaryContent.text = petDiary?.diary_content
        cameraBtn.isHidden = false
        if petDiary?.diary_image != nil {
            cameraBtn.isEnabled = false
        }
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
        if selected_date == petBirthday {
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
        
        //테이블뷰 데이터도 바뀐 selected_date 날짜의 데이터로 불러오기
        getDataset()
        //날짜 맞게 테이블뷰,일기 뷰 재셋업
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.setupDiaryView()
        }
    }
    
    //날짜 +1 버튼(>)
    @IBAction func nextDate(_ sender: Any) {
        let navidate = selected_date.toDate()
        let navidatenum = navidate!.timeIntervalSince1970
        
        let nextDay = Int(navidatenum) + 86400
        setDate(nextDay)
        checkDateCaseLogic()
        
        //테이블뷰 데이터도 바뀐 selected_date 날짜의 데이터로 불러오기
        getDataset()
        //날짜 맞게 테이블뷰,일기 뷰 재셋업
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.setupDiaryView()
        }
    }
    
    // 날짜 연산 -> 문자열로 변환 -> 전역변수 날짜 업데이트 -> 네비바에 해당 날짜 표시
    func setDate(_ date: Int) {
        let timeInterval = TimeInterval(date) // Int를 unixTime으로 변환
        let changedDate = Date(timeIntervalSince1970: timeInterval) // unixTime을 Date타입으로 변환
        selected_date = changedDate.toString() // Date를 스트링으로 변환 후 selected_date갱신.갱신된 날짜에서 재연산하여야하니까 최종 변환값을 대입해줘야함.
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
    
    
    
    
    
    // MARK: 화면 전환시 데이터 전달
    // 세그웨이를 이용하여 모달 뷰로 전환. 메인뷰에 네비바에 선택된 날짜(act_date 데이터 add용) 넘겨주기.
    // ex)어제 날짜에서 액션 버튼 선택할 경우 어제 날짜로 해당 액션을 등록해야하기 때문에 홈뷰에서 선택된 날짜를 넘겨주는게 필요
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddDiary" { // 다이어리 추가 모달창으로 가는 segue
            let targetVC = segue.destination as! AddDiaryViewController
            targetVC.selectedDate = selected_date
            targetVC.petDiary = petDiary ?? PetDiary() // 상세페이지에서 기존 데이터 뿌려줘야 함. 네비바 날짜의 데이터로.
        }
        else if segue.identifier == "toAddAct1" || segue.identifier == "toAddAct2" || segue.identifier == "toAddAct3" || segue.identifier == "toAddAct4" || segue.identifier == "toAddAct5" || segue.identifier == "toAddAct6" { // 액션 추가 모달창으로 가는 segue 6개
            let targetVC = segue.destination as! AddPetActionViewController
            targetVC.selectedDate = selected_date
        }
        else if segue.identifier == "toCalendar" {
            let targetVC = segue.destination as! CalendarViewController
            targetVC.today = today
            targetVC.selected_date = selected_date
        }
        else if segue.identifier == "toActionDetail" { // 액션 상세 편집 모달창으로 가는 segue
            if let selected = tableView.indexPathForSelectedRow {
                if let targetVC = segue.destination as? PetDetailViewController {
                    targetVC.petAction = petActions?[selected.row] ?? PetAction() // 상세페이지에서 선택된 액션 데이터 뿌려줘야 함.
                }
            }
        }
    }
    
    
    // MARK: 뒤로 가기(unwind segue). 데이터를 가지고 홈으로 돌아옵니다.
    @IBAction func unwindToHome (_ unwindSegue : UIStoryboardSegue) {
        //캘린더 홈으로 버튼으로부터
        let calendarVC = unwindSegue.source as? CalendarViewController
        if calendarVC?.new_date != "" { //new_date가 초기설정값인 ""이 아니라면
            dateBtn.setTitle(calendarVC?.new_date, for: .normal) // 받아온 new_date를 네비바 타이틀에 설정
            if let calendarVC { selected_date = calendarVC.new_date} // 받아온 new_date를 갱신날짜 변수에 지정
            checkDateCaseLogic()
            
            //테이블뷰 데이터도 바뀐 selected_date 날짜의 데이터로 불러오기
            getDataset()
            //날짜 맞게 테이블뷰,일기 뷰 재셋업
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.setupDiaryView()
            }
            
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
        return petActions?.count ?? 0// 액션 셀 row 수는 데이터의 개수
    }
    
    // getDataset()으로 불러들여온 dataset을 꺼내서 diaryCell,actionCell의 각 컴포넌트에 매치해서 넣어준다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath)
        
        guard let petActions1 = petActions else { fatalError() }
        let petAction = petActions1[indexPath.row] // 액션 하나에 대한 정보
        
        let lblActTime = cell.viewWithTag(1) as? UILabel // 시간
        let actImgView = cell.viewWithTag(2) as? UIImageView // 액션대표이미지
        let lblActName = cell.viewWithTag(3) as? UILabel // 액션명
        let lblActDetail = cell.viewWithTag(4) as? UILabel // 액션 필수 디테일
        let lblMemo = cell.viewWithTag(5) as? UILabel // 메모
        let memoImgView = cell.viewWithTag(6) as? UIImageView // 액션 메모 이미지
        
        // 시간
        lblActTime?.text = petAction.actions?.act_time
        
        // 액션명,액션대표이미지
        switch petAction.act_id {
            case 1: lblActName?.text = "산책"; actImgView?.image = UIImage(named: "walk")
            case 2: lblActName?.text = "배변"; actImgView?.image = UIImage(named: "poo")
            case 3: lblActName?.text = "사료"; actImgView?.image = UIImage(named: "food")
            case 4: lblActName?.text = "병원"; actImgView?.image = UIImage(named: "hospital")
            case 5: lblActName?.text = "미용"; actImgView?.image = UIImage(named: "hair")
            case 6: lblActName?.text = "몸무게"; actImgView?.image = UIImage(named: "weight")
            default: print("none")
        }
        
        // 디테일 - 액션별로 보여줄 디테일이 다르므로 분기 처리
        switch petAction.act_id {
            case 1: lblActDetail?.text = petAction.actions?.walk_spend_time
            case 2: lblActDetail?.text = "\(petAction.actions?.ordure_color ?? "") \( petAction.actions?.ordure_shape ?? "")"
            case 3: lblActDetail?.text = "\(petAction.actions?.feed_type ?? "") \(petAction.actions?.feed_name ?? "") \(petAction.actions?.feed_amount ?? "")"
            case 4: lblActDetail?.text = petAction.actions?.hospital_name
        case 5: lblActDetail?.text = String((petAction.actions?.beauty_cost)!)
        case 6: lblActDetail?.text =  String((petAction.actions?.weight)!)
            default: print("none")
        }
        
        // 메모
        lblMemo?.text = petAction.actions?.memo
        
        // 메모 사진
        memoImgView?.image = UIImage(named: petAction.actions?.memo_image ?? "white")
        
        
        
        //pet_act(id, act_date,[diary_content],[diary_image],diary_open_yn,reg_datetime,[act_id],pet_id,user_id)
        
        // pet_act에서 메인 셀에 필요 데이터인 diary_content와 diary_image와 act_id를 가져온다.
            // act_id가 있으면 액션 셀에 act_date와 act_id를 보여주고, 즉, 일시와 액션명. (메인 셀에서 액션 상세 내용까지 보여주려면 pet_act_detail 데이터도 가져와야함)
            // act_id가 없으면(==diary라면) 다이어리 셀에 act_date와 diary_content와 diary_image를 보여준다.
        
        // Tag1 = 시간, Tag2 = 액션대표이미지, Tag3 = 액션명, Tag4 = 액션 필수 디테일, Tag5 = 메모, Tag6 = 액션 메모 이미지
        // 등록시간(필수), 6개액션이미지(Aseets에 등록되어있을것), 액션명(필수), 세부디테일내용(몇몇 액션만 필수), 메모내용(선택), 사진(선택)
            // 셀의 Tag2(첫번째 imageview)에 보여줄 6개 액션에 대한 image는 Assets에 넣어두고 pet_act테이블의 act_id가 1~6이냐 로직에 따라 보여주기.
        
        //세부 디테일 내용은 메인셀에서 어디까지 보여줄것인가 정하기
        // pet_act_detail(id, act_time, memo, memo_image, walk_spend_time, ordure_shape, ordure_color, feed_type, feed_amount, feed_name, hospital_type, hospital_name, hospital_doctor, hospital_cost, beauty_cost, weight, petact_id)
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
        guard editingStyle == .delete else { return }
        petActions?.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
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



extension Date {
    func toString() -> String { // < > 버튼 누를시 날짜 연산하여 네비바에 날짜 포맷팅해서 입력하기 위한 용도
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
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
        cameraBtn.isHidden = true
        
    }
}
