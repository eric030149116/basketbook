//
//  homeVC.swift
//  basketbookCounter
//
//  Created by WuTungHan on 2017/5/19.
//  Copyright © 2017年 WuTungHan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class homeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groupsTableView: UITableView!
    
    // 連上 Firebase
    var ref = Database.database().reference()
    // 自訂 球隊 iD 的空陣列
    var groupIDs: NSArray = []
    // 自訂 球隊內容的空陣列
    var groupData = [Dictionary<String, AnyObject>]()
    var groupID = ""
    var groupName = ""
    var memNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

     // 用不到
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    // 更新使用者
    func updateUserName(){
        let userObj = Auth.auth().currentUser
        let uid = (userObj?.uid)! as String
        self.ref.child("usernames/\(uid)/").setValue(userObj?.displayName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
        //隱藏 navigationBar
        self.navigationController?.isNavigationBarHidden = true
        self.groupsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.loadData()
        self.groupsTableView.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.updateMemberships()
    }
    
    func loadData()
    {
        // firebase 語法 存取資料庫的方法(快照 -> snapshot)
        ref.child("/groups/").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get groups
           // NSLog("\(snapshot)")
            // children ＝ 資料庫下面的子表
            let num = snapshot.childrenCount
            if(num > 0)
            {
                let values = (snapshot.value as? Dictionary<String, Dictionary<String, AnyObject>>)!
                self.groupIDs = [String](values.keys) as NSArray
                

                self.groupData = (([Dictionary<String, AnyObject>])(values.values) as NSArray) as! [Dictionary<String, AnyObject>]
                NSLog("\(self.groupData)")
                NSLog("共有\(values.count)支球隊")
                self.groupsTableView.reloadData()
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    
    
    
    
    // table view delegate 和 datasource 的方法（必做）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupIDs.count
    }
    
    // 設定 Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.groupID = groupIDs[indexPath.item] as! String
       // print("aaaa:::::\(groupData[indexPath.row]["name"])")
//        self.groupName = ((self.groupData[indexPath.row] as? [String:String])?["name"])!
        // self.groupName = self.groupData[indexPath.item]["name"] as! String
//        self.memNum = ((self.groupData[indexPath.item] as? [String:Int])?["members"])!
        //self.memNum = self.groupData[indexPath.item]["members"] as! Int
        self.performSegue(withIdentifier: "groupDetail", sender: self)
    }
    // 設定 Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")

        print("aaaa:::::\(String(describing: groupData[indexPath.row]["members"]))")
        cell?.textLabel?.text = groupData[indexPath.row]["name"] as? String
        let value = groupData[indexPath.row]["members"] as! Int
        cell?.detailTextLabel?.text =  String(value)
        
        return cell!
    }
    
    // 準備 segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "groupDetail")
        {
            if let destinationVC = segue.destination as? groupDetailVC{
                destinationVC.groupID = self.groupID
                destinationVC.groupName = self.groupName
                destinationVC.memNum = self.memNum
            }
        }
    }


    
}
