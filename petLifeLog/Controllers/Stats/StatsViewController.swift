//
//  StatsViewController.swift
//  petLifeLog
//
//  Created by jso on 2023/10/14.
//

import UIKit

class StatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("test")
//        UserDefaults.standard.removeObject(forKey: "UserId")
//        UserDefaults.standard.removeObject(forKey: "isLogined")
//        UserDefaults.standard.removeObject(forKey: "nickName")
//        UserDefaults.standard.removeObject(forKey: "petName")
//        UserDefaults.standard.removeObject(forKey: "petImage")
//        UserDefaults.standard.removeObject(forKey: "petId")
        Utils.delUserDefault(mode: "all")
//        self.navigationController?.popToRootViewController(animated: true)
//        UserDefaultsKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
        // Do any additional setup after loading the view.
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
