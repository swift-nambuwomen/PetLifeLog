//
//  MyPagesViewController.swift
//  TeamProject
//
//  Created by hope1049 on 2023/09/25.
//

import UIKit
import Alamofire
import Kingfisher

class MyPagesViewController: UIViewController, UITableViewDataSource, UITabBarDelegate,
    UIGestureRecognizerDelegate, UITextFieldDelegate{
    //양육자 변수
    @IBOutlet weak var tabbarItem: UITabBarItem!

    @IBOutlet weak var textYearMonth: UITextField!
    var pet:[Pets] = []
    var cost:[CostData] = []
    var petId = 0
    var selectedRowIndex: Int? // 현재 선택된 행의 인덱스
    
    @IBOutlet weak var lblBeautyCost: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lblHospitalCost: UILabel!
    @IBOutlet weak var lblFeedCost: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if USER_ID == 0 {
            print("로그인정보 없음")
        }else{
            getPetInfo(userId: USER_ID)
        }

        
        navigationItem.title = "\(NICK_NAME)님의 강아지들"
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        // Date Picker의 시간대 설정 (한국 시간대로 설정)
        
        datePicker.timeZone = TimeZone(identifier: "Asia/Seoul")
        datePicker.date = dateFormatter.date(from: "2023-10")!
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        textYearMonth.text = dateFormatter.string(from: currentDate)
        datePicker.date = currentDate
        
        tableView.dataSource = self
        tableView.reloadData()
        textYearMonth.delegate = self
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        if let selectedDate = dateFormatter.date(from: "2023-10") {
            datePicker.date = selectedDate
        }
        
    }
    
    //+버튼으로 강아지 신규등록 및 수정

    //닫기버튼 눌렀을때 화면 갱신
    @IBAction func back(_ segue:UIStoryboardSegue){
        getPetInfo(userId: USER_ID)
        tableView.reloadData()
    }
    
    //펫 선택시 모든 화면의 공통변수 PetId 변경하기
    //선택된 로우는 글자색 다르게 또는 셀 색변경
    @IBAction func actPetSelect(_ sender: Any) {
        
    }
    
    //펫선택 버튼 누르면 userdefault값 변경(다른 화면에 적용)
    @objc func buttonTapped(sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell){
            let rowIndex = indexPath.row
            let selectedPet = pet[rowIndex]
            petId = selectedPet.id
            
            //Utils.delUserDefault(mode: "pet")
            UserDefaults.standard.setValue(petId, forKey: PetDefaultsKey.petId.rawValue)
            PET_ID = UserDefaults.standard.integer(forKey: PetDefaultsKey.petId.rawValue)
            print(petId)
            print(PET_ID)
            
            //선택한 로우와 기존에 선택된 로우의 펫id값이 다를때는 기존 색상으로 변경
            // 이전에 선택한 셀의 배경색을 초기 상태로 되돌립니다.
            if let previousSelectedIndex = selectedRowIndex {
                let previousSelectedCell = tableView.cellForRow(at: IndexPath(row: previousSelectedIndex, section: 0))
                previousSelectedCell?.backgroundColor = UIColor.white // 기본 배경색
            }
            
            // 현재 선택된 행의 셀을 가져와서 배경색을 변경
            if selectedRowIndex == rowIndex {
                // 같은 셀을 두 번 연속으로 클릭한 경우, 선택을 해제
                selectedRowIndex = nil
            } else {
                // 현재 선택한 셀의 배경색을 변경하고 선택된 행을 업데이트하여 추적
                let currentSelectedCell = tableView.cellForRow(at: IndexPath(row: rowIndex, section: 0))
                currentSelectedCell?.backgroundColor = UIColor.systemGray5 // 변경하고자 하는 배경색으로 설정
                selectedRowIndex = rowIndex
            }
            
        }

        if let inputText = textYearMonth.text {
            let components = inputText.split(separator: "-")
            if components.count == 2,
                let year = Int(components[0]),
                let month = Int(components[1]) {
                // 년과 월 추출
                print("Year: \(year), Month: \(month)")
                //펫 선택시 한달지출비용
                //getPetCost(pet: petId, actDate: datePicker.date.toString(format: "yyyy-MM-dd"))
                getPetCost(pet: petId, actDate: String(year) + "-" + String(month) + "-01")
                // 여기에서 년과 월을 사용하여 데이터를 처리
            } else {
                // 사용자가 올바른 형식("년-월")으로 입력하지 않은 경우 에러 처리
                print("올바른 형식으로 입력하세요 (예: 2023-10).")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pet.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                
        let pet = pet[indexPath.row]

        let lblName = cell.viewWithTag(1) as? UILabel
        let lblBreed = cell.viewWithTag(2) as? UILabel
        let lblBirth = cell.viewWithTag(3) as? UILabel
        let lblSex = cell.viewWithTag(4) as? UILabel
        let imageProfile = cell.viewWithTag(5) as? UIImageView
        let btnPetSelect = cell.viewWithTag(6) as? UIButton
        
        print(pet)
        //이미지  https://stpetlifelog.blob.core.windows.net/petphoto/46/e99e3bd2-21cd-4d79-99cd-0dbde67fbb4a
        if pet.profileImage != "" && IMAGE_URL != "" {
            let imageName = IMAGE_URL + "/" + pet.profileImage
            
            // 캐시된 이미지 삭제
            
            if let url = URL(string: imageName) {
                
                ImageCache.default.removeImage(forKey: url.cacheKey)
                
                let processor = RoundCornerImageProcessor(cornerRadius: 20) // 모서리 둥글게
                
                imageProfile?.kf.indicatorType = .activity
                imageProfile?.clipsToBounds = true
                imageProfile?.layer.cornerRadius = 55
                
                imageProfile?.kf.setImage(
                  with: url,
                  placeholder: UIImage(systemName: "photo"),
                  options: [
                          .processor(processor),
                          .cacheOriginalImage
                      ],
                  completionHandler: nil
                )
                
            }
            
//            if let image = URL(string: imageName) {
//                URLSession.shared.dataTask(with: image) { (data, response, error) in
//                    if let data = data, let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            imageProfile?.image = image
//                        }
//                    } else {
//                        print("이미지를 불러올 수 없습니다: \(error?.localizedDescription ?? "알 수 없는 오류")")
//                    }
//                }.resume()
//            }
        }else{
            //이미지가 없을시 기본이미지 표시
            
        }
        petId = pet.id
        lblName?.text = pet.name
        lblBreed?.text = pet.breed
        lblBirth?.text = pet.birth
        
        if pet.sex == "F"{
            lblSex?.text = "암컷"
        }
        else{
            lblSex?.text = "수컷"
        }

        // 펫버튼에 액션 추가
        btnPetSelect?.tag = indexPath.row
        btnPetSelect?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        btnPetSelect?.tag = indexPath.row
        
        return cell
    }
    
    // 사용자가 입력한 텍스트의 형식을 제어
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == textYearMonth {
                // 사용자가 "-" 문자를 입력할 수 있도록 허용
                return true
            }
            // 다른 텍스트 필드에서 입력을 제어하려면 해당 필드에 대한 처리를 추가하세요.
            return true
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let select = tableView.indexPathForSelectedRow else { return }
        
        let selectedPet = pet[select.row]
        
        let detailVC = segue.destination as? PetInfoViewController
        detailVC?.modalPresentationStyle = .formSheet
        detailVC?.preferredContentSize = CGSize(width: 200, height: 150)
        
        print(selectedPet)
        detailVC?.pet = [selectedPet]
        detailVC?.petId = petId
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func getPetInfo(userId:Int){
        //let str = "http://127.0.0.1:8000/api/pet/list?"
        let str = SITE_URL + "/api/pet/list?"
        let params:Parameters = ["userId":USER_ID]
        
        let alamo = AF.request(str, method: .get, parameters: params)

        //alamo.responseDecodable(of:Pets.self) { response in  //데이터 한건 받을때
        alamo.responseDecodable(of:[Pets].self) { response in
            if let error = response.error {
                    print("Error: \(error.localizedDescription)")
            }
            else {
                // 성공적으로 디코딩된 데이터 처리
                if let result = response.value {
                    print(result)
                    self.pet = result
                    //self.pets.append(reuslt)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //한달 지출비용
    func getPetCost(pet:Int, actDate:String){
        //let str = "http://127.0.0.1:8000/api/pet/list?"
        let str = SITE_URL + "/api/pet/costList?"
        let params:Parameters = ["pet_id":PET_ID,
                                 "act_date":actDate]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let alamo = AF.request(str, method: .get, parameters: params, headers: headers)

        print(alamo)
        //alamo.responseDecodable(of:Pets.self) { response in  //데이터 한건 받을때
        alamo.responseDecodable(of: [CostData].self) { response in
            if let error = response.error {
                    print("Error: \(error.localizedDescription)")
            }
            else {
                // 성공적으로 디코딩된 데이터 처리
                if let result = response.value {
                    print(result)
                    self.cost = result
                    //pet_id = 1, act_date = '2023-10-15' 데이터로 테스트
                    if self.cost.count >= 1{
                        self.lblFeedCost.text = "\(self.cost[0].feedAmount)"
                        self.lblHospitalCost.text = "\(self.cost[0].hospitalCost)"
                        self.lblBeautyCost.text = "\(self.cost[0].beautyCost)"
                        
                        //                    if self.cost[0].beautyCost != 0 {
                        //                        self.lblBeautyCost.text = "\(self.cost[0].beautyCost)"
                    }else{
                        
                    }
                }
            }
        }
    }

}


