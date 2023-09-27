//
//  BoardDetailViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/27.
//

import UIKit

class BoardDetailViewController: UIViewController {

    var post:[String:String] = [:]
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postContent: UITextView!
    //@IBOutlet weak var postImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        // Do any additional setup after loading the view.
    }
    
    func drawUI() {
        postTitle.text = post["title"]
        postContent.text = post["content"]
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
