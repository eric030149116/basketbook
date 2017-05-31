//
//  newGroupVC.swift
//  basketbookCounter
//
//  Created by WuTungHan on 2017/5/18.
//  Copyright © 2017年 WuTungHan. All rights reserved.
//

import UIKit
import Firebase
class newGroupVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var newGroupTextField: UITextField!
    
    // 連上 Firebase
    var ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        // 隱藏 navigationBar條
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    // 自訂 回傳輸入球隊值的方法
    private func textFieldShouldReturn(_ newGroupTextField:UITextView) -> Bool {
        self.newGroupTextField.resignFirstResponder()
        createGroup()
        return true
    }
    
     // 用不到
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    
    @IBAction func newGroupBtn(_ sender: Any) {
        
        // 收鍵盤
        self.newGroupTextField.resignFirstResponder()
        
        // 按下按鈕 新增隊伍
        createGroup()
    }
    

    // 建立 自訂新增球隊的方法
    func createGroup() {
        
        let groupName = self.newGroupTextField.text?.trimmingCharacters(in: CharacterSet.init(charactersIn: " "))
        if(groupName != "")
        {
            
            // 使用者ID
            let uid = Auth.auth().currentUser!.uid
            //時間
            let t = Int(Date().timeIntervalSince1970)
            // 用使用者 ID 取得 球隊名稱
            let key = ref.child("groups").childByAutoId().key
            // 球隊陣列
            let gPost = ["members" : 1, "name" : groupName!] as [String : Any]
            
            let mPost = ["\(t)" : uid]
            //let MPost = ["\(t)" : key]
            let childUpdates = ["/groups/\(key)/" : gPost, "/members/\(key)/" : mPost]
            self.ref.updateChildValues(childUpdates)
            self.ref.child("memberships/\(uid)/\(t)/").setValue(key)
            self.navigationController?.popViewController(animated: true)
        }
    }

}
