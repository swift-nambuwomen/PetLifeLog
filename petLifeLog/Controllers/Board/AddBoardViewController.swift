//
//  AddDiaryViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/25.
//

import UIKit

class AddBoardViewController: UIViewController {

    @IBOutlet weak var boardTitle: UITextField!
    @IBOutlet weak var boardContent: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func addBoard(_ sender: Any) {
        var newPost:[String:String] = [:]
        
        newPost = ["user_id":"1","user_nick":"고돌언니", "profile_img":"twinlake", "reply_cnt":"0","reg_date":"2023-09-25"] //로그인사용자정보
        
        if let title = boardTitle.text {
            newPost["title"] = title
        }
        if let content = boardContent.text {
            newPost["content"] = content
        }

        posts.append(newPost)
        
        self.navigationController?.popViewController(animated: true)
        
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
