//
//  DiaryViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/24.
//

import UIKit
import Alamofire
import Kingfisher

class DiaryViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var segment: UISegmentedControl!

    @IBOutlet weak var tableView: UITableView!
    
    var diaryAll:[DiaryList] = []
    var diary:[DiaryList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didDiaryNotification(_:)),
            name: NSNotification.Name("DiaryInsertSuccess"),
            object: nil
        )
    
        //세그먼트 설정
        
        NSLayoutConstraint.activate([
            self.segment.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.segment.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            self.segment.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            self.segment.heightAnchor.constraint(equalToConstant: 40),
        ])

        segment.translatesAutoresizingMaskIntoConstraints = false
        // 선택된 배경색 변경.
        segment.selectedSegmentTintColor = .white

        // 전체 배경색 변경
        segment.backgroundColor = .systemBlue
        
        self.segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.segment.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.blue,
//                .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
//                NSAttributedString.Key.backgroundColor: UIColor.cyan,
//                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick
            ],
            for: .selected
        )
        self.segment.addTarget(self, action: #selector(meOrAll(_:)), for: .valueChanged)
//        segment.removeSegment()
        self.view.addSubview(self.segment)
        
        getDiary()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        getDiary()
        //tableView.reloadData()
    }
    
    @IBAction func meOrAll(_ sender: Any) {
        if segment.selectedSegmentIndex == 0 {
            //me
            getDiary()

        } else {
            //all
            getDiaryAll()
        }
    }
    
    @objc func didDiaryNotification(_ notification: Notification) {
        print("didDismissDetailNotification")
        getDiary()
    }
    
    //===============다이어리 데이터 조회(나)===============
    func getDiary(completion: (() -> Void)? = nil){

        let str = SITE_URL + "/api/pet/diaryList?"
        let params:Parameters = ["userId":USER_ID]
        
        let alamo = AF.request(str, method: .get, parameters: params)
        print(alamo)
        alamo.responseDecodable(of:[DiaryList].self) { response in
            print(response.result)
            if let error = response.error {
                    print("Error: \(error.localizedDescription)")
            }
            else {
                // 성공적으로 디코딩된 데이터 처리
                if let result = response.value {
                    print(result)
                    self.diary = result
                }
            }
            DispatchQueue.main.async {
                            completion?()
                self.tableView.reloadData()
            }
        }
        
    }
    
    //===============다이어리 데이터 조회(전체)===============
    func getDiaryAll(completion: (() -> Void)? = nil){
        let str = SITE_URL + "/api/pet/diaryAll"
        let alamo = AF.request(str, method: .get)
        
        alamo.responseDecodable(of:[DiaryList].self) { response in
            if let error = response.error {
                    print("Error: \(error.localizedDescription)")
            }else {
                // 성공일때
                if let result = response.value {
                    print(result)
                    self.diaryAll = result
                }
            }
            DispatchQueue.main.async {
                            completion?()
                self.tableView.reloadData()
            }
        }
        
    }
    
    //=================tableView 처리 ===================================
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0{
            return diary.count
        }else{
            return diaryAll.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        //나와 전체일기일때 구분하여 표시
        if segment.selectedSegmentIndex == 0{
            
            let diaryData = diary[indexPath.row]
            
            let lblDate = cell.viewWithTag(1) as? UILabel
            lblDate?.text = diaryData.act_date

            if let imageView = cell.viewWithTag(2) as? UIImageView, let lblDiary = cell.viewWithTag(3) as? UILabel {
                if diaryData.diary_image != "" {
                    
                    if diaryData.diary_image != "" && IMAGE_URL != "" {
                        let imageName = IMAGE_URL + "/" + diaryData.diary_image
                        
                        if let url = URL(string: imageName) {
                            let processor = RoundCornerImageProcessor(cornerRadius: 20) // 모서리 둥글게
                            
                            imageView.kf.indicatorType = .activity
                            
                            imageView.kf.setImage(
                                with: url,
                                placeholder: UIImage(systemName: "photo"),
                                options:
                                    //.processor(processor)
                                [.cacheOriginalImage],
                                completionHandler: nil
                            )
                            
                        }
                    }else{
                        imageView.isHidden = true
                    }
                    
                }
                lblDiary.text = diaryData.diary_content
                let lblPetName = cell.viewWithTag(5) as? UILabel
                let lblUserName = cell.viewWithTag(4) as? UILabel
                lblPetName?.text = diaryData.pet_name
                lblUserName?.text = "[\(diaryData.user_name)님의] "
            }
        }
        else{
            let diaryAllData = diaryAll[indexPath.row]

            let lblDate = cell.viewWithTag(1) as? UILabel
            lblDate?.text = diaryAllData.act_date
            
            if let imageView = cell.viewWithTag(2) as? UIImageView, let lblDiary = cell.viewWithTag(3) as? UILabel {
                
                if diaryAllData.diary_image != "" && IMAGE_URL != "" {
                    let imageName = IMAGE_URL + "/" + diaryAllData.diary_image
                    
                    if let url = URL(string: imageName) {
                        let processor = RoundCornerImageProcessor(cornerRadius: 20) // 모서리 둥글게
                        
                        imageView.kf.indicatorType = .activity
                        
                        imageView.kf.setImage(
                            with: url,
                            placeholder: UIImage(systemName: "photo"),
                            options: nil,
                            //.processor(processor)
                            //[.cacheOriginalImage],
                            //],
                            completionHandler: nil
                        )
                    }
                }else{
                    imageView.isHidden = true
                }
                lblDiary.text = diaryAllData.diary_content
                let lblPetName = cell.viewWithTag(5) as? UILabel
                let lblUserName = cell.viewWithTag(4) as? UILabel
//                lblPetName?.text = diaryAllData.pet_name
//                lblUserName?.text = "(" + diaryAllData.user_name + ")"
                lblPetName?.text = diaryAllData.pet_name
                lblUserName?.text = "[\(diaryAllData.user_name)님의] "
            }  //else끝(다이어리 전체)
            
        }
        return cell
    }
    
}

// 세그먼트 셋팅
//extension UISegmentedControl {
//    func setup() {
//        // 배경색을 하얀색으로 설정
//        setBackgroundImage(imageWithColor(UIColor.white), for: .normal, barMetrics: .default)
//        // 선택된 세그먼트의 배경색을 하얀색으로 설정
//        setBackgroundImage(imageWithColor(UIColor.white), for: .selected, barMetrics: .default)
//
//        // 글자 색을 파란색으로 설정
//        setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
//
//        // 글자와의 구분선
////        setDividerImage(imageWithColor(UIColor.blue, size: CGSize(width: 3, height: 2)), forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
//    }
//
//    func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
//            let rect = CGRect(origin: .zero, size: size)
//            UIGraphicsBeginImageContext(rect.size)
//            let context = UIGraphicsGetCurrentContext()
//            context?.setFillColor(color.cgColor)
//            context?.fill(rect)
//            let image = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return image!
//        }
//
//
//    }
