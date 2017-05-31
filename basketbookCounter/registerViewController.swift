//
//  registerViewController.swift
//  basketbookCounter
//
//  Created by WuTungHan on 2017/4/27.
//  Copyright © 2017年 WuTungHan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class registerViewController: UIViewController {
    @IBOutlet weak var usernameRegisterTextField: UITextField!
    @IBOutlet weak var passwordRegisterTextField: UITextField!
    @IBOutlet weak var emailRegisterTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Do any additional setup after loading the view.
    }
    
    // 監控鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // 收回鍵盤
    func textFieldShouldReturn(_ usernameLogTextField:UITextField, _ passwordLogTextField:UITextField, _ emailLogTextField:UITextField) -> Bool {
        usernameLogTextField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func registerBtn(_ sender: Any) {
        if (emailRegisterTextField.text == "" || passwordRegisterTextField.text == "" || usernameRegisterTextField.text == "") {
            let alertController = UIAlertController(title: "錯誤", message: "請輸入完整的資料", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailRegisterTextField.text!, password: passwordRegisterTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "login")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "錯誤", message: "輸入的密碼至少為六碼", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
