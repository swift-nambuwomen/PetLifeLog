//
//  Home2ViewController.swift
//  petLifeLog
//
//  Created by jso on 2023/10/23.
//

import UIKit
import Alamofire
let baseURL = SITE_URL
var selected_date = "" // 네비바용. 사용자가 선택한 날짜. yyyy-MM-dd.
var today = "" // < > 날짜 이동 버튼, 날짜에 따라 비활성화 처리용 대조 데이터.
let picker = UIImagePickerController()
class Home2ViewController: UIViewController {

    @IBOutlet weak var diaryContent: UILabel!
    @IBOutlet weak var diaryImage: UIImageView!
    @IBOutlet var aa: UIView!
    
    let user_id = UserDefaults.standard.integer(forKey: "userId") // 로그인 후 들고 있어야 할 user_id값
    let pet_id = UserDefaults.standard.integer(forKey: "petId") // 로그인 후 들고 있어야 할 user_id의 현재 선택 되어있는 pet_id의 값

    
    let pet_birth = "2021-04-16" // 로그인 후 들고 있어야 할 현재 pet의 강아지 생일

    // AF로 가져온 Act를 [actdetail]과 diary로 분리함
    var act:Act?
    var actdetail:[Actdetail]?
    var petDiary:PetDiary?
    
    @IBOutlet weak var dateBtn: UIButton! // 날짜 지정하기 위함
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var prevBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {

        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getActDataViaAF()
        // Do any additional setup after loading the view.
        
        
        super.viewDidLoad()
        print("pet_id==\(PET_ID)")
        // login check
        login()
        
        let now = Int(Date().timeIntervalSince1970) // unixTime. 1972년 1월 1일부터로부터 몇초가 경과했는지
        setDate(now)
        today = selected_date // nextDate버튼 비활성화 처리 위하여 오늘 날짜와 비교하기 위해서 받아두기
        nextBtn.isEnabled = false // 오늘 다음 날짜의 기록은 없으니 처음엔 > 버튼 비활성화로 시작하기
        print("called 홈뷰 DidLoad")
        getActDataViaAF() // get선택 날짜의 테이블뷰 액션 셀의 row들에 보여줄 액션, 다이어리 셀에 보여줄 다이어리 data
        setupTableView() // 날짜 맞게 테이블뷰 셋업
        setupDiaryView() // 다이어리 내용 있을시 셋업
        //picker.delegate = self // 카메라 피커c
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        print("userid=\(USER_ID)")
        print("PET_ID=\(PET_ID)")
        print("PET_id=\(UserDefaults.standard.integer(forKey: "petId"))")
        //checkDateCaseLogic()
        getActDataViaAF() //테이블뷰 데이터도 바뀐 selected_date 날짜의 데이터로 불러오기
    }
    
    
    // MARK: UI, 데이터 셋업

    // AF - 메인 네비바상의 선택된 날짜에 현재 접속된 유저의 선택된 강아지의 기록(액션,일기)이 있다면 가져와라.
    func getActDataViaAF() {
        let url = "\(actList_url)"
        let params:Parameters = ["pet_id":PET_ID, "act_date":selected_date]
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
//                    self.petDiary = nil
//                    self.actdetail = nil
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
//        cameraBtn.isEnabled = true
//        if petDiary?.diary_image != nil {
//            //cameraBtn.isHidden = true
//            cameraBtn.isEnabled = false
//        }

        diaryContent.text = petDiary?.diary_content

//        diaryImgView.image = UIImage(named: petDiary?.diary_image ?? "white")
    }
    
    func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
        //tableView.rowHeight = UITableView.automaticDimension // 동적 셀 높이
        //tableView.separatorStyle = .none //cell구분선 없애기
    }
    
    func setDate(_ date: Int) {
        let timeInterval = TimeInterval(date) // Int를 unixTime으로 변환
        let changedDate = Date(timeIntervalSince1970: timeInterval) // unixTime을 Date타입으로 변환
        selected_date = changedDate.toDateString() // Date를 스트링으로 변환 후 selected_date갱신.갱신된 날짜에서 재연산하여야하니까 최종 변환값을 대입해줘야함.
        dateBtn.setTitle(selected_date, for:.normal) // 갱신된 날짜 보여주기
    }
    
    func login() {
        // login check
        let isLogined = UserDefaults.standard.bool(forKey: "isLogined")

        if !isLogined {
            let loginStoryboard = UIStoryboard(name: "Auth", bundle: nil)
            if let vc = loginStoryboard.instantiateViewController(identifier: "login") as? LoginViewController {
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
        if pet_id == nil {
            let loginStoryboard = UIStoryboard(name: "MyInfo", bundle: nil)
            if let vc = loginStoryboard.instantiateViewController(identifier: "MyInfo") as? MyPagesViewController {
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
    }
    
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
}

extension Home2ViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 액션 셀 하나
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return actdetail?.count ?? 0// 셀 row 수는 Act 안의 Actdetail 데이터의 개수
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "act", for: indexPath)
            print("====")
            print(actdetail)
 
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
            default: lblActName?.text = petDiary?.diary_content
            }
            
            // 다이어리 뷰의 메모
//            lblMemo?.text = petAction.memo
//
//            // 다이어리 뷰의 메모 사진
//            memoImgView?.image = UIImage(named: "white") // Azure blob 적용전까지는 white로 세팅
            //memoImgView?.image = UIImage(named: petAction.actdetail?.memo_image ?? "white") // white 아닌 nil로는 ?
            return cell
            
        } else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "diary", for: indexPath)
            let diaryMemo = cell.viewWithTag(22) as? UILabel
            print("content == \(petDiary?.diary_content)")
            diaryMemo?.text = petDiary?.diary_content
            let diaryImage = cell.viewWithTag(21) as? UIImageView
            
            return cell
        }
    
    }
    
    
    
}


// MARK: - 날짜 변환. 데이터 저장시 항상 고정된 타임존으로

