//
//  myGroups.swift
//  basketbookCounter
//
//  Created by WuTungHan on 2017/5/19.
//  Copyright © 2017年 WuTungHan. All rights reserved.
//

import UIKit
import Firebase

class myGroups: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var numBut: UIButton!
    @IBOutlet weak var groupsTableView: UITableView!
    
    var ref = Database.database().reference()
    var groupIDs: NSArray = []
    var groupData = [Dictionary<String, AnyObject>]()
    var groupID = ""
    var groupName = ""
    var memNum = 0
    
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        self.groupsTableView.delegate = self
        self.groupsTableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
//        self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadData()
//        self.groupsTableView.reloadData()
    }
    
    // 更新球隊 data
    func updateGroupData(_ gData: Dictionary<String, AnyObject>)
    {
        self.groupData.append(gData)
        
    }
    // 更新球隊 ID
    func updateGroupIDs(_ gIDs: [String])
    {
        self.groupIDs = gIDs as NSArray
    }
    
    // 這裡撈資料
    func loadData(){
        // 得到使用者uid -> get memberships 路徑
        ref.child("/memberships/\((Auth.auth().currentUser?.uid)!)/").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get groups
            //NSLog("\(snapshot)")
            let num = snapshot.childrenCount
            if(num > 0)
            {
                
                let values = (snapshot.value as? Dictionary<String, String>)!
                print("pppppppp\(values)")
                
                self.groupIDs = [String](values.values) as NSArray
                
                for gID in self.groupIDs
                {
                    // 用每一筆球隊 ID 抓 球隊裡面的成員
                    self.ref.child("groups").child(gID as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        // 取得球員資料
                        print("\(snapshot)")
                        
                        let gData = snapshot.value as! Dictionary<String, AnyObject>
                        //self.members.append(username)
                        
                        self.updateGroupData(gData)
                        //self.groupsTableView.reloadData()
                    }) { (error) in
                        //self.groupsTableView.reloadData()
                        print(error.localizedDescription)
                        
                    } // error handling
                    //self.groupsTableView.reloadData()
                } //for
                
               // self.groupsTableView.reloadData()
            } //if
            
            //self.members = userNames
           //self.groupsTableView.reloadData()
        }) { (error) in
            //self.groupsTableView.reloadData()
            print(error.localizedDescription)
            
        }
        //self.groupsTableView.reloadData()
        self.numBut.setTitle("您所屬的 \(self.groupIDs.count) 支球隊", for: UIControlState())
        //self.groupsTableView.reloadData()
        (UIApplication.shared.delegate as! AppDelegate).updateMemberships()
        
       // self.groupsTableView.reloadData()
        
    } // loadData()
    
    
    // table view delegate and data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("IDs\(groupIDs)")
        print("data\(groupData)")
        return self.groupIDs.count
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.groupID = groupIDs[indexPath.item] as! String

        self.groupName = self.groupData[indexPath.row]["name"]! as! String
        self.memNum = self.groupData[indexPath.row]["members"] as! Int
        self.performSegue(withIdentifier: "myGroupDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")
            cell?.textLabel?.text = groupData[indexPath.row]["name"] as? String
        let value = groupData[indexPath.row]["members"] as! Int
            cell?.detailTextLabel?.text =  ("\(String(value))位")
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "myGroupDetail"){
            if let dVC = segue.destination as? groupDetailVC{
                dVC.groupID = self.groupID
                dVC.groupName = self.groupName
                dVC.memNum = self.memNum
            }
        }
    }
    
}
