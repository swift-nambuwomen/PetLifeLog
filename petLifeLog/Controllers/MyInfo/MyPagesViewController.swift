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
    
    @IBOutlet weak var lblBeautyCost: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblHospitalCost: UILabel!
    @IBOutlet weak var lblFeedCost: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    var pet:[Pets] = []
    var cost:[CostData] = []
    var selectedRowIndex: Int? // 현재 선택된 행의 인덱스
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        
        if USER_ID == 0 {
            print("로그인정보 없음")
        }else{
            getPetInfo(userId: USER_ID)
        }
        
        if let nickName = NICK_NAME {
            navigationItem.title = "\(nickName)님의 강아지들"
        }
        
        textYearMonth.isHidden = true
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        dateFormatter.locale = Locale(identifier: "ko_KR")

        let yearMonth = dateFormatter.string(from: currentDate)
        
        getPetCost(pet: PET_ID, actDate: yearMonth + "-01")
        //tabelview custom cell 왼쪽여백 없애기
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.separatorInset = .zero
//        tableView.directionalLayoutMargins = .zero
//        tableView.layoutMargins = .zero
        
        tableView.dataSource = self
        tableView.reloadData()
        textYearMonth.delegate = self
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
    @objc func buttonTapped(_ sender: UIButton) {
        if let cell = sender.superview?.superview as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            // 이전에 선택된 버튼의 인덱스 업데이트
            let rowIndex = indexPath.row
            let selectedPet = pet[rowIndex]
            
            print("새로운 petId ::: \(selectedPet.id)")
            print(PET_ID)
            
            //PET_ID, PET_NAME 변경
            UserDefaults.standard.setValue(selectedPet.id, forKey: PetDefaultsKey.petId.rawValue)
            UserDefaults.standard.setValue(selectedPet.name, forKey: PetDefaultsKey.petName.rawValue)
            PET_ID = UserDefaults.standard.integer(forKey: PetDefaultsKey.petId.rawValue)
            PET_NAME = UserDefaults.standard.string(forKey: PetDefaultsKey.petName.rawValue)
        }
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pet.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //custom cell 여백없애기
//        cell.directionalLayoutMargins = .zero
//        cell.layoutMargins = .zero
//        cell.contentView.directionalLayoutMargins = .zero
//        cell.contentView.layoutMargins = .zero
        
        let pet = pet[indexPath.row]
        
        let lblName = cell.viewWithTag(1) as? UILabel
        let lblBreed = cell.viewWithTag(2) as? UILabel
        let lblBirth = cell.viewWithTag(3) as? UILabel
        let lblSex = cell.viewWithTag(4) as? UILabel
        let imageProfile = cell.viewWithTag(5) as? UIImageView
        let btnPetSelect = cell.viewWithTag(6) as? UIButton
        
        print(pet)
        //이미지주소 https://stpetlifelog.blob.core.windows.net/petphoto/46/e99e3bd2-21cd-4d79-99cd-0dbde67fbb4a
        if pet.profileImage != "" && IMAGE_URL != "" {
            let imageName = IMAGE_URL + "/" + pet.profileImage

            if let url = URL(string: imageName) {
                // 캐시된 이미지 삭제
                ImageCache.default.removeImage(forKey: url.cacheKey)
                
                imageProfile?.kf.indicatorType = .activity
                imageProfile?.clipsToBounds = true
                imageProfile?.layer.cornerRadius = 20
                
                DispatchQueue.main.async {
                    imageProfile?.kf.setImage(
                        with: url,
                        placeholder: UIImage(named: "dogDefault3"),
                        options: [
                            .cacheOriginalImage
                        ],
                        completionHandler: nil
                    )
                }
                imageProfile?.image = UIImage(named: "dogDefault3")
            }
        } else {
            // 이미지가 없을시 기본 이미지 표시
            imageProfile?.image = UIImage(named: "dogDefault3")
        }
        
        //petId = pet.id
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
        btnPetSelect?.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        print("\(PET_ID) , \(pet.id)")
        if PET_ID == pet.id {
            btnPetSelect?.setTitle("V", for: UIControl.State.normal)
            //btnPetSelect?.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            btnPetSelect?.setTitle("펫선택", for: UIControl.State.normal)
        }
        
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
        detailVC?.petId = PET_ID
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func getPetInfo(userId:Int){
        let str = SITE_URL + "/api/pet/list?"
        let params:Parameters = ["userId":USER_ID]
        
        let alamo = AF.request(str, method: .get, parameters: params)

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
                        
                        let totalCost = self.cost[0].feedAmount + self.cost[0].hospitalCost + self.cost[0].beautyCost
                            self.lblTotal.text = "\(totalCost)"
                    }else{
                        
                    }
                }
            }
        }
    }

    @IBAction func actLogout(_ sender: Any) {
        Utils.delUserDefault(mode: "all")
        UserDefaults.standard.synchronize()
        
        let loginStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        if let vc = loginStoryboard.instantiateViewController(identifier: "login") as? LoginViewController {
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}


