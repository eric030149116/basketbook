//
//  homeViewController.swift
//  basketbookCounter
//
//  Created by WuTungHan on 2017/4/27.
//  Copyright © 2017年 WuTungHan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class homeViewController: UIViewController {
    @IBAction func logOutBtn(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }


}
