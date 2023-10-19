//
//  DiaryViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/24.
//

import UIKit
import Alamofire

class DiaryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var segment: UISegmentedControl!

    @IBOutlet weak var collectionView: UICollectionView!

    var diaryAll:[DiaryList] = []
    var diary:[DiaryList] = []
    let memberID = UserDefaults.standard.integer(forKey: "userId")
    //사용자 이름 표시
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if segment.selectedSegmentIndex == 0{
            getDiary()
        }else{
            getDiaryAll()
        }
    }

//    func imageAzure(){
//        let account = AZSCloudStorageAccount(fromConnectionString:AZURE_STORAGE_CONNECTION_STRING) //I stored the property in my header file
//        let blobClient: AZSCloudBlobClient = account.getBlobClient()
//        let blobContainer: AZSCloudBlobContainer = blobClient.containerReferenceFromName("<yourContainerName>")
//        blobContainer.createContainerIfNotExistsWithAccessType(AZSContainerPublicAccessType.Container, requestOptions: nil, operationContext: nil) { (NSError, Bool) -> Void in
//           if ((NSError) != nil){
//              NSLog("Error in creating container.")
//           }
//           else {
//              let blob: AZSCloudBlockBlob = blobContainer.blockBlobReferenceFromName(<nameOfYourImage> as String) //If you want a random name, I used let imageName = CFUUIDCreateString(nil, CFUUIDCreate(nil))
//              let imageData = UIImagePNGRepresentation(<yourImageData>)
//
//              blob.uploadFromData(imageData!, completionHandler: {(NSError) -> Void in
//              NSLog("Ok, uploaded !")
//              })
//            }
//        }
//    }

    @IBAction func meOrAll(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //me
            getDiary()
        } else {
            //all
            getDiaryAll()
        }
    }
    
    //===============다이어리 데이터 조회(나)===============
    func getDiary(completion: (() -> Void)? = nil){

        let str = "http://127.0.0.1:8000/api/pet/diaryList?"
        let params:Parameters = ["userId":memberID]
        
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
                self.collectionView.reloadData() // 데이터가 로드된 후 CollectionView를 갱신
            }
        }
        
    }
    
    //===============다이어리 데이터 조회(전체)===============
    func getDiaryAll(completion: (() -> Void)? = nil){
        let str = "http://127.0.0.1:8000/api/pet/diaryAll"
        let alamo = AF.request(str, method: .get)
        
        alamo.responseDecodable(of:[DiaryList].self) { response in
            if let error = response.error {
                    print("Error: \(error.localizedDescription)")
            }else {
                // 성공적으로 디코딩된 데이터 처리
                if let result = response.value {
                    print(result)
                    self.diaryAll = result
                }
            }
            DispatchQueue.main.async {
                            completion?()
                self.collectionView.reloadData() // 데이터가 로드된 후 CollectionView를 갱신
            }
        }
        
    }
    
    //=================CollectionView 처리 =====================================
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0{
            return diary.count
        }else{
            return diaryAll.count
        }
        
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        //나와 전체일기일때 구분하여 표시
        if segment.selectedSegmentIndex == 0{
            
            let diaryData = diary[indexPath.row]
            
            let lblDate = cell.viewWithTag(1) as? UILabel
            lblDate?.text = diaryData.act_date

            if let imageView = cell.viewWithTag(2) as? UIImageView, let textView = cell.viewWithTag(3) as? UITextView {
                // 이미지가 없는 경우 텍스트 뷰에 데이터 표시
                if diaryData.diary_image == "" {
                    imageView.frame.size.height = 0
                    imageView.isHidden = true
                    textView.text = diaryData.diary_content
                    textView.backgroundColor = .clear
                    cell.layer.cornerRadius = 20
                } else {
                    //imageViewHeightConstraint?.constant = 80
                    imageView.isHidden = false
                    imageView.image = UIImage(named: diaryData.diary_image)
                    // 이미지 뷰 크기 조절 (0.5배 축소)
                    //imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.3)
                    textView.text = diaryData.diary_content // 이미지가 있는 경우 텍스트를 지우거나 다른 내용을 설정
                    cell.layer.cornerRadius = 20
                    textView.backgroundColor = .clear
                }
            }
        }
        else{
            let diaryAllData = diaryAll[indexPath.row]

            let lblDate = cell.viewWithTag(1) as? UILabel
            lblDate?.text = diaryAllData.act_date
            
            //다이어리 공개된 데이터만 표시(전체일기 표시할때)
//            let imageName = cell.viewWithTag(2) as? UIImageView
//
//            if diaryAllData.diary_image == "" {
//                imageName?.isHidden = true
//            }else{
//                imageName?.image = UIImage(named: diaryAllData.diary_image)
//                imageName?.isHidden = false
//            }
//
//            let textView = cell.viewWithTag(3) as? UITextView
//            textView?.text = diaryAllData.diary_content
//
//            // 텍스트뷰 크기 조절
//            textView?.isScrollEnabled = false
//            //textView?.sizeToFit()
//            textView?.backgroundColor = .clear
            
            if let imageView = cell.viewWithTag(2) as? UIImageView, let textView = cell.viewWithTag(3) as? UITextView {
                // 이미지가 없는 경우 텍스트 뷰에 데이터 표시
                if diaryAllData.diary_image == "" {
                    imageView.frame.size.height = 0
                    imageView.isHidden = true
                    textView.text = diaryAllData.diary_content
                    textView.backgroundColor = .clear
                    cell.layer.cornerRadius = 20
                } else {
                    //imageViewHeightConstraint?.constant = 80
                    imageView.isHidden = false
                    imageView.image = UIImage(named: diaryAllData.diary_image)
                    // 이미지 뷰 크기 조절 (0.5배 축소)
                    imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.3)
                    textView.text = diaryAllData.diary_content // 이미지가 있는 경우 텍스트를 지우거나 다른 내용을 설정
                    cell.layer.cornerRadius = 20
                    textView.backgroundColor = .clear
                }
            }
            
            cell.layer.cornerRadius = 20
        }
        return cell
    }
}

extension DiaryViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if segment.selectedSegmentIndex == 0{
//            let diaryText = diary[indexPath.row]
//        }else{
//            let diaryText = diaryAll[indexPath.row]
//        }

//        var width = collectionView.bounds.width - 16 // 여기서 16은 여백 등을 고려한 값
//        //print("\(diaryText.diary_content) \(collectionView.bounds.width)")
//        collectionView.backgroundColor = UIColor(hex: "#E0F2F7")
//
//        // 텍스트뷰의 높이에 따라 동적으로 계산된 높이를 설정합니다.
//        let imageName = diaryText.diary_image
//        let textView = UITextView()
//        textView.text = diaryText.diary_content
//
//        var dynamicHeight = 0.0
//
//        //이미지의 파일이름체크하여 공백제거하고 nil체크하여 이미지가 없으면 사이즈 작게, 이미지 있으면 높이조절하여 크기조절
//        //9월 14일 데이터화면표시 체크, 이미지는 없지만 글자수는 많음. 이미지틀만큼 비어있음.
//        if imageName.trimmingCharacters(in: .whitespaces) == "" {
//            dynamicHeight = 50.0
//            let size = textView.sizeThatFits(CGSize(width: collectionView.frame.width, height: CGFloat.greatestFiniteMagnitude))
//            textView.backgroundColor = .clear
//            textView.sizeToFit()
//            return CGSize(width: collectionView.frame.width, height: size.height + dynamicHeight)
//        } else {
//            dynamicHeight = 200.0
//            // 이미지 데이터가 없는 경우, 텍스트 뷰의 크기에 맞게 설정
//            let size = textView.sizeThatFits(CGSize(width: collectionView.frame.width, height: CGFloat.greatestFiniteMagnitude))
//            textView.backgroundColor = .clear
//            textView.sizeToFit()
//            return CGSize(width: collectionView.frame.width, height: size.height + dynamicHeight)
//        }

//        return CGSize(width: 360, height: 240)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            // 컬렉션 뷰 내용의 인셋을 설정
            // UIEdgeInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 첫 번째 셀 위쪽 간격을 설정
        }
    
    //collectionview 셀의 수평 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    //collectionview 셀의 수직 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

//색상컬러
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
