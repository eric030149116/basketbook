//
//  ViewController.swift
//  basketbookCounter
//
//  Created by WuTungHan on 2017/4/27.
//  Copyright © 2017年 WuTungHan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var emailLogTextField: UITextField!

    @IBOutlet weak var passwordLogTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        // Do any additional setup after loading the view, typically from a nib.
    }
    // 監控鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // 收回鍵盤
    func textFieldShouldReturn(_ emailLogTextField:UITextField, _ jpasswordLogTextField:UITextField) -> Bool {
        emailLogTextField.resignFirstResponder()
        return true
    }

    @IBAction func loginBtn(_ sender: Any) {
        if self.emailLogTextField.text == "" || self.passwordLogTextField.text == "" {
            
            // 提示用戶是不是忘記輸入 textfield ？
            
            let alertController = UIAlertController(title: "錯誤", message: "請輸入帳號或密碼", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            Auth.auth().signIn(withEmail: self.emailLogTextField.text!, password: self.passwordLogTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    // 登入成功，打印 ("You have successfully logged in")
                    
                 self.performSegue(withIdentifier: "home", sender: self)

                    
                } else {
                    
                    // 提示用戶從 firebase 返回了一個錯誤。
                    let alertController = UIAlertController(title: "錯誤", message: "錯誤的Email或密碼", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

