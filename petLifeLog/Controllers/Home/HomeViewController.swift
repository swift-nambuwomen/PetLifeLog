//
//  HomeViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/26.
//

import UIKit

//테스트용 임시 데이터
let user_id = "admin" // 로그인 후 들고 있어야 할 user_id값
let pet_id = "adminpet" // 로그인 후 들고 있어야 할 user_id의 현재 선택 되어있는 pet_id의 값

let today = Date() // 2023-09-29 17:05:34 +0000

//var dataset // 전역변수로 선언 미리 해주기
//임시데이터
var dataset = [["image":"twinlake", "act_name":"배변", "actmemo":"nothing special", "pootype":"초코/정상", "photo":"twinlake"],["image":"twinlake", "act_name":"배변", "actmemo":"nothing special", "pootype":"초코/정상", "photo":"twinlake"],["image":"twinlake", "act_name":"배변", "actmemo":"nothing special", "pootype":"초코/정상", "photo":"twinlake"]]

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentDate: UINavigationItem! // 오늘 날짜 지정하기 위해서
    var selected_date = "" // 네비바용. 사용자가 선택한 날짜. yyyy-mm-dd
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getDataset() // 테이블뷰 액션 셀의 row들에 보여줄 액션명, 다이어리 셀에 보여줄 다이어리 데이터 가져오기
        //getDateTime() 날짜 선택 화면이동 데이터 플로우에 따라.. will에 보일지 did에 보일지 생각하기...
        getDateTime()
    }
    
    // TODO: 날짜 연산. 달의 마지막날+1일 할 경우 다음달 1일으로 가야, 1일은 0일이 아닌 이전달 마지막날으로 가야. 고려해서 로직 다시 생각하기.
    //let dateFormatter = DateFormatter()
    // let convertDate = dateFormatter.date(from: dateStr) // Date 타입으로 변환
    //
    //날짜 -1 버튼(<)
    @IBAction func prevDate(_ sender: Any) {
        // yyyy-mm-dd -> yyyy-mm-(dd-1)
        let dd = (Int(selected_date.suffix(2)) ?? 0) - 1 //dd - 1
        let yyyymm = String(selected_date.prefix(8)) //yyyy-mm-
        let prevDate = yyyymm + String(dd)
        print(prevDate)
        let dateFormatter = DateFormatter()
        let convertPrevDate = dateFormatter.date(from: prevDate)
        print(convertPrevDate ?? 0)
        // currentDate.title =
    }
    
    //날짜 +1 버튼(>)
    @IBAction func nextDate(_ sender: Any) {
        // yyyy-mm-dd -> yyyy-mm-(dd+1)
        let dd = (Int(selected_date.suffix(2)) ?? 0) + 1 //dd + 1
        let yyyymm = (selected_date.prefix(8)) //yyyy-mm-
        let nextDate = yyyymm + String(dd)
        print(nextDate)
    }
    
    func getDateTime() {
        let formatter = DateFormatter()
        
        // 네비바 타이틀 설정용 날짜
        formatter.dateFormat = "yyyy-MM-dd"
        selected_date = formatter.string(from: Date())
        currentDate.title = selected_date
    }
    
    
    // 메인 네비바상의 선택된 날짜에 현재 접속된 유저의 선택된 강아지의 기록(액션,일기)이 있다면 가져와라.
    func getDataset() {
        // TODO: 메인화면 테이블뷰 액션 셀의 row들에 보여줄 액션명, 다이어리 셀에 보여줄 다이어리 데이터 가져오기. pet_act
        // API 통신 통해 pet_act테이블에서 selected_date==act_date 이면서 user_id==user_id, pet_id==pet_id에 일치하는 데이터를 1개 혹은 여러개 받는다.
        //pet_act(id,[act_date],[diary_content],[diary_image],diary_open_yn,reg_datetime,[act_id],pet_id,user_id) 이 중 4개 필요함
            // pet_act테이블에서 act_date와 diary_content와 diary_image와 act_id를 가져온다.
                // act_id가 있으면 cell 1에 한 행씩 act_date와 act_id를 보여주고,
                // act_id가 없으면(==diary라면) cell 2에 act_date와 diary_content와 diary_image를 보여준다.
        
        // TODO: 메인화면 테이블뷰 액션셀의 row들에 보여줄 각 액션의 세부 데이터 가져오기. pet_act_detail
        // pet_act_detail(id, act_time, memo, memo_image, walk_spend_time, ordure_shape, ordure_color, feed_type, feed_amount, feed_name, hospital_type, hospital_name, hospital_doctor, hospital_cost, beauty_cost, weight, petact_id)
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.separatorStyle = .none //cell구분선 없애기
    }
    
    
    // 세그웨이를 이용하여 모달 뷰로 전환. 메인뷰에 네비바에 선택된 날짜(act_date 데이터 add용) 넘겨주기.
    // ex)어제 날짜에서 액션 버튼 선택할 경우 어제 날짜로 해당 액션을 등록해야하기 때문에 홈뷰에서 선택된 날짜를 넘겨주는게 필요
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddDiary" { // 다이어리 추가 모달창으로 가는 segue
            let targetVC = segue.destination as! AddDiaryViewController
            targetVC.selectedDate = selected_date
        }
        if segue.identifier == "toAddAct1" || segue.identifier == "toAddAct2" || segue.identifier == "toAddAct3" || segue.identifier == "toAddAct4" || segue.identifier == "toAddAct5" || segue.identifier == "toAddAct6" { // 액션 추가 모달창으로 가는 segue 6개
            let targetVC = segue.destination as! AddPetActionViewController
            targetVC.selectedDate = selected_date
        }
    }

}


// MARK: - 테이블뷰 세팅
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 행동 기록하는 용도, 일기 용도 총 2가지 종류의 셀 섹션
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataset.count // 행동 기록 셀, 섹션0
        } else {
            return 1 // 일기 셀, 섹션1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 1 { // 일기 셀, 섹션 1
            cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell", for: indexPath)
            // cell tag활용 데이터 매칭
        } else { // 나머지 rows 전부 == 행동 기록 행들
            cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath)
            // cell tag활용 데이터 매칭
            
            
            // TODO: getDataset()으로 불러들여온 dataset을 꺼내서 diaryCell,actionCell의 각 컴포넌트에 매치해서 넣어준다.
            
            //pet_act(id, act_date,[diary_content],[diary_image],diary_open_yn,reg_datetime,[act_id],pet_id,user_id)
            
            // pet_act에서 메인 셀에 필요 데이터인 diary_content와 diary_image와 act_id를 가져온다.
                // act_id가 있으면 액션 셀에 act_date와 act_id를 보여주고, 즉, 일시와 액션명. (메인 셀에서 액션 상세 내용까지 보여주려면 pet_act_detail 데이터도 가져와야함)
                // act_id가 없으면(==diary라면) 다이어리 셀에 act_date와 diary_content와 diary_image를 보여준다.
            
            // Tag1 = 시간, Tag2 = 액션대표이미지, Tag3 = 액션명, Tag4 = 액션 필수 디테일, Tag5 = 메모, Tag6 = 액션 메모 이미지
            // 등록시간(필수), 6개액션이미지(Aseets에 등록되어있을것), 액션명(필수), 세부디테일내용(몇몇 액션만 필수), 메모내용(선택), 사진(선택)
                // 셀의 Tag2(첫번째 imageview)에 보여줄 6개 액션에 대한 image는 Assets에 넣어두고 pet_act테이블의 act_id가 1~6이냐 로직에 따라 보여주기.
            
            //세부 디테일 내용은 메인셀에서 어디까지 보여줄것인가 정하기
            // pet_act_detail(id, act_time, memo, memo_image, walk_spend_time, ordure_shape, ordure_color, feed_type, feed_amount, feed_name, hospital_type, hospital_name, hospital_doctor, hospital_cost, beauty_cost, weight, petact_id)
            
            
        }
        return cell
    }

}
