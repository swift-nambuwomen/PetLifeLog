//
//  DiaryViewController.swift
//  petLifeLog
//
//  Created by ! on 2023/09/24.
//

import UIKit

class DiaryViewController: UIViewController {
    @IBOutlet weak var view1: UITableView!

    @IBOutlet weak var view2: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func meOrAll(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            //me
            view1.isHidden = false
            view2.isHidden = true
        } else {
            //all
            view1.isHidden = true
            view2.isHidden = false
        }
    }
}
