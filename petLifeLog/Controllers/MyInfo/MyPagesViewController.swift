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
    let memberID = "1"
    var saveType = ""
    var pet:[Pets] = []
    var longPressGesture: UILongPressGestureRecognizer!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblMemberName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMemberName.text = "\(memberID)님의 강아지들"
        
        getPetInfo(pet: 1)
        
//        // 길게 누르기 제스처 생성
//                longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//                longPressGesture.delegate = self
//        self.tabbarItem.addGestureRecognizer(longPressGesture)
        
        tableView.dataSource = self
        //tableView.delegate = self
        
    }

    // 롱 프레스 제스처 핸들러
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: point) {
                // 롱 프레스된 아이템의 인덱스 판별
                let selectedRow = indexPath.row
                print("선택된 행: \(selectedRow)")
                // 여기에서 선택한 아이템에 대한 작업을 수행할 수 있습니다.
            }
        }
    }
    
    //닫기버튼 눌렀을때 화면 갱신
    @IBAction func back(_ segue:UIStoryboardSegue){
        getPetInfo(pet: 2)
        tableView.reloadData()
    }
    
    @IBAction func actInsert(_ sender: UIButton){
        saveType = "I"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pet.count > 0{
            saveType = "U"
        }
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
                        
        if let image = pet.profileImage as String? {
            imageProfile?.image = UIImage(named: image)
        }
        
        lblName?.text = pet.name
        lblBreed?.text = pet.breed
        lblBirth?.text = pet.birth
        lblSex?.text = pet.sex
                    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let select = tableView.indexPathForSelectedRow else { return }
        
        let selectedPet = pet[select.row]
        
        let detailVC = segue.destination as? PetInfoViewController
        detailVC?.modalPresentationStyle = .formSheet
        detailVC?.preferredContentSize = CGSize(width: 200, height: 150)
        
        print(selectedPet)
        detailVC?.pet = [selectedPet]
        if saveType == "I"{
            detailVC?.saveType = "I"
        }
        else{
            detailVC?.saveType = "U"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //양육자의 Id를 앱실행할때 유지
    func loadSetting(){
        //let userDefaults = UserDefaults.standard
        //lblName.text = userDefaults.string(forKey: "name")
    }

    //url에서 데이터 가져오기

    func getPetInfo(pet:Int){
//        guard let query = query
//        else{
//            print("query in nil")
//            return
//        }
        
        let str = "http://127.0.0.1:8000/api/pet/list?"
        //let str = "http://127.0.0.1:8000/pets/"
        let params:Parameters = ["userId":pet]
        
        AF.request(str, method: .get, parameters: params).responseDecodable(of: [Pets].self) { response in
            print(response.result)
            switch response.result {
            case .success:
                
                break
            case .failure:
                // POST 요청 중 오류가 발생한 경우
                print(response.debugDescription)
                break
            }
        }
        
//        let alamo = AF.request(str, method: .get, parameters: params)
//
//        //alamo.responseDecodable(of:Pets.self) { response in  //데이터 한건 받을때
//        alamo.responseDecodable(of:[Pets].self) { response in
//            if let error = response.error {
//                    print("Error: \(error.localizedDescription)")
//
//            }
//            else {
//                // 성공적으로 디코딩된 데이터 처리
//                if let result = response.value {
//                    print(result)
//                    self.pet = result
//                    //self.pets.append(reuslt)
//                    self.tableView.reloadData()
//                }
//            }
//        }
    }
    
    //메인에서 화면전환후 되돌아가기할때 호출
//    @IBAction func back(_ segue: UIStoryboardSegue) {
//        loadSetting()
//    }
        
}
