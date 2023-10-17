//
//  MyPagesViewController.swift
//  TeamProject
//
//  Created by hope1049 on 2023/09/25.
//

import UIKit
import Alamofire


class MyPagesViewController: UIViewController, UITableViewDataSource, UITabBarDelegate,
    UIGestureRecognizerDelegate{
    //양육자 변수
    @IBOutlet weak var tabbarItem: UITabBarItem!
    let memberID = 1
    var saveType = ""
    var pet:[Pets] = []
    var petId = 0
    var selectedRowIndex: Int? // 현재 선택된 행의 인덱스
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblMemberName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("******\(userDefaultId)")
        lblMemberName.text = "\(memberID)님의 강아지들"
        
        getPetInfo(member: memberID)
        
        tableView.dataSource = self

        //tableView.delegate = self
        
    }
    
    //닫기버튼 눌렀을때 화면 갱신
    @IBAction func back(_ segue:UIStoryboardSegue){
        getPetInfo(member: memberID)
        tableView.reloadData()
    }
    
    @IBAction func actInsert(_ sender: UIButton){
        
    }
    
    //펫 선택시 모든 화면의 공통변수 PetId 변경하기
    //선택된 로우는 글자색 다르게 또는 셀 색변경
    @IBAction func actPetSelect(_ sender: Any) {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if pet.count > 0{
//            saveType = "U"
//        }
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
        
        if let image = pet.profileImage as String? {
            imageProfile?.image = UIImage(named: image)
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

        // 버튼에 액션 추가
        btnPetSelect?.tag = indexPath.row
        btnPetSelect?.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func buttonTapped(sender: UIButton) {
        let rowIndex = sender.tag
        let selectedPet = pet[rowIndex]
        
        petId = selectedPet.id
        userDefaultId = petId
        print("펫id : \(petId)")
        
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
        
        let itemImage = selectedPet.profileImage
        
        if let originalImage = UIImage(named: itemImage) {
            let imageSize = CGSize(width: 20, height: 20) // 원하는 크기로 조절
            let resizedImage = UIGraphicsImageRenderer(size: imageSize).image { _ in
                originalImage.draw(in: CGRect(origin: .zero, size: imageSize))
            }
            tabBarItem.image = resizedImage
        }
        
        
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
    
    //양육자의 Id를 앱실행할때 유지
    func loadSetting(){
//        let userDefaults = UserDefaults.standard
//        lblName.text = userDefaults.string(forKey: "name")
    }

    //url에서 데이터 가져오기

    func getPetInfo(member:Int){
        
        let str = "http://127.0.0.1:8000/api/pet/list?"
        let params:Parameters = ["userId":member]
        
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
    
    //메인에서 화면전환후 되돌아가기할때 호출
//    @IBAction func back(_ segue: UIStoryboardSegue) {
//        loadSetting()
//    }

}
