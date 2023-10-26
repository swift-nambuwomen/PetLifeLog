//
//  StatsViewController.swift
//  petLifeLog
//
//  Created by jso on 2023/10/14.
//

import UIKit
import FSCalendar

class StatsViewController: UIViewController {


    @IBOutlet weak var calendar: FSCalendar!
    
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
        UserDefaults.standard.synchronize()
        
        
        
//        UserDefaults.standard.setValue("고돌스", forKey: PetDefaultsKey.petName.rawValue)
//        UserDefaults.standard.setValue("no-image", forKey: PetDefaultsKey.petImage.rawValue)
//        UserDefaults.standard.setValue(100, forKey: PetDefaultsKey.petId.rawValue)
//
//        UserDefaults.standard.synchronize()
//        PET_ID = UserDefaults.standard.integer(forKey: PetDefaultsKey.petId.rawValue)
//        PET_NAME = UserDefaults.standard.integer(forKey: PetDefaultsKey.petName.rawValue)
//        PET_IMG = UserDefaults.standard.integer(forKey: PetDefaultsKey.petImage.rawValue)
        //        self.navigationController?.popToRootViewController(animated: true)
//        UserDefaultsKey.allCases.forEach { //UserDefaults.standard.removeObject(forKey: $0.rawValue) }
        // Do any additional setup after loading the view.
        
        // In loadView or viewDidLoad
//        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
//        calendar.dataSource = self
//        calendar.delegate = self
       // view.addSubview(calendar)
       // self.calendar = calendar
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

extension StatsViewController: FSCalendarDataSource,FSCalendarDelegate {
    
}
