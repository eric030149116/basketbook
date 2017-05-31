//
//  groupDetailVC.swift
//  basketbookCounter
//
//  Created by WuTungHan on 2017/5/19.
//  Copyright © 2017年 WuTungHan. All rights reserved.
//

import UIKit
import Firebase

class groupDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var joinBut: UIButton!
    @IBOutlet weak var numBut: UIButton!
    @IBOutlet weak var memberTableView: UITableView!
    
    
    var groupName = "group name"
    var groupID = ""
    var members = [String]()
    var ref = Database.database().reference()
    var isMember = false
    var memNum = 0
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = false
        self.memberTableView.delegate = self
        self.memberTableView.dataSource = self
    }
    @IBAction func joinLeaveToggle(_ sender: AnyObject) {
        if(self.isMember){
            self.setMembershipStatus(false)
            self.leaveGroup()
            self.joinBut.setTitle("Join Group", for:[])
        } // leave the group and update button label
        else{
            self.setMembershipStatus(true)
            self.joinGroup()
            self.joinBut.setTitle("Leave Group", for: [])
        } // join the group and update button label
        self.loadData()
        self.navigationController?.popViewController(animated: true)
    }


    
    func joinGroup()
    {
        let uid = Auth.auth().currentUser!.uid
        let t = Int(Date().timeIntervalSince1970)
        let key = self.groupID
        let num = self.memNum + 1
        
        self.ref.child("groups/\(key)/members/").setValue(num)
        self.ref.child("memberships/\(uid)/\(t)/").setValue(key)
        self.ref.child("members/\(key)/\(t)/").setValue(uid)
        self.loadData()
    } // joinGroup()
    
    func leaveGroup()
    {
        let uid = Auth.auth().currentUser!.uid
        let key = self.groupID
        let num = self.memNum - 1
        var t = ""
        
        for pair in  (UIApplication.shared.delegate as! AppDelegate).memberships
        {
            if(pair.1 == key)
            {
                t = pair.0
                break
            }
        }
        
        self.ref.child("groups/\(key)/members/").setValue(num)
        self.ref.child("memberships/\(uid)/\(t)/").setValue(nil)
        self.ref.child("members/\(key)/\(t)/").setValue(nil)
    } // leaveGroup
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadData()
        self.navigationItem.title = self.groupName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadData()
    }
    
    func updateMembers(_ mem: String){
        self.members.append(mem)
    }
    
    func setMembershipStatus(_ status: Bool)
    {
        self.isMember = status
    }
    
    func checkMembership(){
        if(self.members.contains((Auth.auth().currentUser?.displayName)!))
        {
            self.setMembershipStatus(true)
        }
        else{
            self.setMembershipStatus(false)
        }
    }
    
    func updateView(){
        
        
        if(self.isMember){
            self.joinBut.setTitle("Leave Group", for: UIControlState())
        }
        else{
            self.joinBut.setTitle("Join Group", for: UIControlState())
        }
        //self.numBut.titleLabel?.text = "\(members.count) members"
        self.numBut.setTitle("\(members.count) members", for: UIControlState())
    }
    
    func loadData(){
        //self.members = [String]()
        self.setMembershipStatus(false)
        ref.child("/members/\(groupID)/").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get groups
            //NSLog("\(snapshot)")
            let num = snapshot.childrenCount
            if(num > 0)
            {
                let values = (snapshot.value as? Dictionary<String, String>)!
                let memberIDs = [String](values.values)
                if memberIDs.contains((Auth.auth().currentUser?.uid)!){
                    self.setMembershipStatus(true)
                }
                for userID in memberIDs
                {
                    self.ref.child("usernames").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        //NSLog("\(snapshot)")
                        let username = snapshot.value as! String
                        //self.members.append(username)
                        self.updateMembers(username)
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
                
            }
            //self.members = userNames
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        self.checkMembership()
        self.updateView()
        self.memberTableView.reloadData()
        
    } // load member names
    
    //table view delegate and datasource methods
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell")
        if(indexPath.item >= self.memNum)
        {
            return cell!
        }
        cell?.textLabel?.text = members[indexPath.item]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
