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
        self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadData()
        //self.groupsTableView.reloadData()
    }
    
    func updateGroupData(_ gData: Dictionary<String, AnyObject>)
    {
        self.groupData.append(gData)
    }
    
    func updateGroupIDs(_ gIDs: [String])
    {
        self.groupIDs = gIDs as NSArray
    }
    
    func loadData(){
        ref.child("/memberships/\((Auth.auth().currentUser?.uid)!)/").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get groups
            //NSLog("\(snapshot)")
            let num = snapshot.childrenCount
            if(num > 0)
            {
                print("qqqqqqqq\(snapshot)")
                
                let values = (snapshot.value as? Dictionary<String, String>)!
                
                
                self.groupIDs = [String](values.values) as NSArray
                for gID in self.groupIDs
                {
                    self.ref.child("groups").child(gID as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        NSLog("\(snapshot)")
                        let gData = snapshot.value as! Dictionary<String, AnyObject>
                        //self.members.append(username)
                        self.updateGroupData(gData)
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                    } // error handling
                    
                } //for
                
            } //if
            //self.members = userNames
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        self.numBut.setTitle("您創建了 \(self.groupIDs.count) 支球隊", for: UIControlState())
        self.groupsTableView.reloadData()
        (UIApplication.shared.delegate as! AppDelegate).updateMemberships()
        
        
    } // loadData()
    
    
    // table view delegate and data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupIDs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.groupID = self.groupIDs[indexPath.item] as! String
        self.groupName = self.groupData[indexPath.item]["name"]! as! String
        self.memNum = self.groupData[indexPath.item]["members"] as! Int
        self.performSegue(withIdentifier: "myGroupDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")
        cell?.textLabel?.text = groupData[indexPath.item]["name"] as? String
        let num = groupData[indexPath.item]["members"]! as! Int
        cell?.detailTextLabel?.text = "\(num)"
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
