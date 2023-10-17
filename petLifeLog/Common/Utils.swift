//
//  Utils.swift
//  petLifeLog
//
//  Created by jso on 2023/10/13.
//

import UIKit

class Utils {

    static func displayAlert(title: String, message: String, comfirm:String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Default", style: .default, handler: nil)

        alertController.addAction(UIAlertAction(title: "\(comfirm)", style: .cancel))


        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("keyWindow has no rootViewController")
        }

        viewController.present(alertController, animated: true, completion: nil)
    }
    
    
    static func delUserDefault(mode:String) {
        if mode == "user" {
            UserDefaultsKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
        } else if mode == "pet" {
            PetDefaultsKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
        } else if mode == "all"{
            PetDefaultsKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
            UserDefaultsKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
        }
    }
    
    
}


