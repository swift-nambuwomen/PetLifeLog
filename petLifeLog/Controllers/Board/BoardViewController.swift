//
//  BoardViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/25.
//

import UIKit

var posts = [
    ["user_id":"1","user_nick":"고돌언니","title":"안녕하세요","content":"오늘은 고돌이가 다녀온 병원에 대해 소개할게요. 동네에 새로 생긴 곳인데 의사 선생님이 친절해요.","profile_img":"twinlake","reply_cnt":"2","reg_date":"2023-09-24"],
    ["user_id":"2","user_nick":"나나","title":"반값브니다","content":"처음 가입했어요.","profile_img":"charleyrivers","reply_cnt":"0","reg_date":"2023-09-23"],
    ["user_id":"1","user_nick":"고돌언니","title":"오늘의 산책길","content":"산책길 풍경입니다.","profile_img":"twinlake","reply_cnt":"1","reg_date":"2023-09-22"]
]

class BoardViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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

extension BoardViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let board1 = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as? UIImageView
        
        if let imageName = board1["profile_img"] {
            imageView?.image = UIImage(named:imageName)
        }
        
        let lblNick = cell.viewWithTag(2) as? UILabel
        lblNick?.text = board1["user_nick"]
        
        let lblTitle = cell.viewWithTag(3) as? UILabel
        lblTitle?.text = board1["title"]
        
        let lblDate = cell.viewWithTag(4) as? UILabel
        lblDate?.text = board1["reg_date"]
        
        let lblReply = cell.viewWithTag(5) as? UILabel
        lblReply?.text = board1["reply_cnt"]
        
        return cell
    }
    
    // 세그웨이를 이용하여 디테일 뷰로 전환하기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let targetVC = segue.destination as! BoardDetailViewController
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)//sender as! IndexPath //self.tableView.indexPath(for: cell)
            targetVC.post = posts[indexPath!.row ]
        }
    }
}
