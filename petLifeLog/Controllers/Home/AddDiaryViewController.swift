//
//  AddDiaryViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/27.
//

import UIKit

class AddDiaryViewController: UIViewController {

    @IBOutlet weak var diaryDate: UILabel!
    @IBOutlet weak var diaryContent: UITextView!
    var currentDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        // Do any additional setup after loading the view.
    }
    
    func drawUI() {
        diaryDate.text = currentDate + " 일기"
    }
    
    
    // 등록 버튼
    @IBAction func addDiary(_ sender: Any) {
        //값 저장 구현
        
        self.dismiss(animated: true)
    }
    
    // 취소 버튼
    @IBAction func closeDiary(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
