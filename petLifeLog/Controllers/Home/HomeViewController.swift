//
//  HomeViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/26.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentDate: UINavigationItem! // 오늘 날짜 지정하기 위해서
    var current_date = "" //네비바용 날짜
    var current_time = "" //기록용 시간
    //var models = [Model]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getDateTime()
    }
    
    func getDateTime() {
        let formatter = DateFormatter()
        
        // 네비바 타이틀 설정용 날짜
        formatter.dateFormat = "yyyy-MM-dd"
        current_date = formatter.string(from: Date())
        currentDate.title = current_date
        
        // 기록용 시간
        formatter.dateFormat = "HH:mm"
        current_time = formatter.string(from: Date())
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        //tableView.separatorStyle = .none //cell구분선 없애기
    }


    // 세그웨이를 이용하여 모달 뷰로 전환하기. 오늘 날짜 넘겨주기
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddDiary" || segue.identifier == "toReadDiary" {
            let targetVC = segue.destination as! AddDiaryViewController
            targetVC.currentDate = current_date
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)

            return cell
    }

}
