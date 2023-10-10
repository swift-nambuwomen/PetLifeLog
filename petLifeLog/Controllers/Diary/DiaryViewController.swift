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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var diary:[PetAction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //textView.delegate = self

        getPetInfo(query: 5) {
            // collectionView 관련 코드를 여기에 작성
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    @IBAction func meOrAll(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //me
            
        } else {
            //all
           
        }
    }
    
    //===============다이어리 데이터 조회===============
    func getPetInfo(query:Int?, completion: @escaping () -> Void){
//        guard let query = query
//        else{
//            print("query in nil")
//            return
//        }
        
        let str = "http://127.0.0.1:8000/api/pet/act/list2/"
//        let params:Parameters = ["query":query]
        
        let alamo = AF.request(str, method: .get)

        
        //alamo.responseDecodable(of:Pets.self) { response in  //데이터 한건 받을때
        alamo.responseDecodable(of:[PetAction].self) { response in
            if let error = response.error {
                    print("Error: \(error.localizedDescription)")
            }
            else {
                // 성공적으로 디코딩된 데이터 처리
                if let result = response.value {
                    print(result)
                    self.diary = result
                    //self.pets.append(reuslt)
                    
                }
            }
            DispatchQueue.main.async {
                    completion()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diary.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        let diaryData = diary[indexPath.row]

        //다이어리 공개된 데이터만 표시(전체일기 표시할때)
        let imageName = cell.viewWithTag(2) as? UIImageView

        if diaryData.diaryImage == "" {
            imageName?.isHidden = true
            // 이미지뷰의 높이를 0으로 설정하여 숨깁니다.
            imageName?.frame.size.height = 0
        }else{
            imageName?.image = UIImage(named: diaryData.diaryImage)
            imageName?.isHidden = false
            // 이미지가 있는 경우 이미지뷰의 높이를 조절합니다.
            imageName?.frame.size.height = 100 // 이미지의 높이에 따라 조절하세요.
        }

        let textView = cell.viewWithTag(3) as? UITextView
        textView?.text = diaryData.diaryContent
        
        // 텍스트뷰 크기 조절
        textView?.isScrollEnabled = false
        textView?.sizeToFit()
        
        textView?.backgroundColor = .clear

        //셀 테두리 표현
//        cell.layer.borderWidth = 2.0;
//        cell.layer.borderColor = UIColor.white.cgColor
        //cell.backgroundColor = UIColor(hex: "#EFFBF5")
        cell.layer.cornerRadius = 30
        
        return cell
    }
    
}

extension DiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트 뷰의 내용이 변경될 때마다 호출됩니다.
        // 텍스트 뷰의 높이를 동적으로 조절하고 최대 높이를 설정합니다.
        let maxHeight: CGFloat = 200 // 최대 높이
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))

        if newSize.height <= maxHeight {
            textViewHeightConstraint.constant = newSize.height
        } else {
            textViewHeightConstraint.constant = maxHeight
        }
    }
}


extension DiaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let diaryText = diary[indexPath.row]
        
        let width = collectionView.bounds.width - 16 // 여기서 16은 여백 등을 고려한 값
        
        collectionView.backgroundColor = UIColor(hex: "#E0F2F7")
        
        // 텍스트뷰를 생성하여 텍스트를 설정하고, 폭을 위에서 계산한 것처럼 설정합니다.
        let textView = UITextView()
        textView.text = diaryText.diaryContent
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.frame.size = CGSize(width: width, height: .greatestFiniteMagnitude)
        textView.isScrollEnabled = false
        textView.sizeToFit()
        
        // 텍스트뷰의 높이에 따라 동적으로 계산된 높이를 설정합니다.
        
        if let imageName = Bool(diaryText.diaryImage){
            if imageName {
                let dynamicHeight = textView.frame.height + 120 // 이미지와 다른 요소에 따라 조절
                return CGSize(width: width, height: dynamicHeight)
            }else{
                let dynamicHeight = textView.frame.height + 20
                return CGSize(width: width, height: dynamicHeight)
            }
        }else{
            return CGSize(width: view.frame.width-40, height: view.frame.height/4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            // 컬렉션 뷰 내용의 인셋을 설정
            // UIEdgeInsets(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)
            return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0) // 첫 번째 셀 위쪽 간격을 설정
        }
    
    //collectionview 셀의 수평 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    //collectionview 셀의 수직 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
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
