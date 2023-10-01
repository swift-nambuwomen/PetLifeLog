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
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        // Do any additional setup after loading the view.
    }
    
    func drawUI() {
        diaryDate.text = selectedDate + " 일기" // 메인에서 선택된 날짜의 일기를 추가해야 하므로 타이틀은 그 날짜로
        //TODO: 다이어리는 하루 하나 등록 가능하기에, 다이어리 기존 데이터가 있을 시 데이터 들고와서 뿌려줘야 함
    }
    
    
    // MARK: 등록 버튼 - 다이어리 수정/저장. 저장된 데이터를 가지고 홈으로 돌아갈 수 있도록 스토리보드에서 unwind함
    @IBAction func addDiary(_ sender: Any) {
        // 저장할 데이터 : pet_act테이블에 act_date= selectedDate, pet_id=접속된 개 아이디, user_id=접속된 유저 아이디, diary_content=텍스트필드내용, diary_image=이미지뷰, diary_open_yn=스위치바상태
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
