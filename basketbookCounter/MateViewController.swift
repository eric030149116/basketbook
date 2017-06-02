//
//  MateViewController.swift
//  basketbookCounter
//
//  Created by WuTungHan on 2017/5/31.
//  Copyright © 2017年 WuTungHan. All rights reserved.
//

import UIKit
import Firebase
import MultipeerConnectivity

class MateViewController: UIViewController, MCSessionDelegate, MCAdvertiserAssistantDelegate, MCBrowserViewControllerDelegate,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var groupsTableView: UITableView!
    
    var peerID:MCPeerID!
    var session:MCSession!
    var browser:MCBrowserViewController!
    var advertiser:MCAdvertiserAssistant? = nil
    
    var isConnected = false
    
    // tableView 宣告的變數在這邊
    var ref = Database.database().reference()
    var groupIDs: NSArray = []
    var groupData = [Dictionary<String, AnyObject>]()
    var groupID = ""
    var groupName = ""
    var memNum = 0
    
    @IBAction func connectBtn(_ sender: Any) {
    }

    override func viewDidLoad() {
        
        self.navigationController?.isNavigationBarHidden = true
        self.groupsTableView.delegate = self
        self.groupsTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        //self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadData()
        //self.groupsTableView.reloadData()
    }

    
    // 藍牙方法在這
    func sendData() {
        //...
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            isConnected = true
            browser.dismiss(animated: true, completion: nil)
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            isConnected = false
            print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let str = String(data: data, encoding: String.Encoding.utf8)
        //※point!!（必須同步）
        DispatchQueue.main.async {
            print("data : \(String(describing: str))")
            
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    }
    
    func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browser.dismiss(animated: true, completion: nil)
    }
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
            print("wwwwwwwww\(snapshot)")
            let num = snapshot.childrenCount
            if(num > 0)
            {
                
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
        
        self.groupsTableView.reloadData()
        (UIApplication.shared.delegate as! AppDelegate).updateMemberships()
    }
    
    
    // table view 方法在這邊
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (groupIDs.count == 0) {
            
            let alertController = UIAlertController(title: "哇喔！", message: "您還沒有加入任何一支球隊！請先加入或創建一支球隊。", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        }
        return self.groupIDs.count
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.groupID = self.groupIDs[indexPath.item] as! String
        self.groupName = self.groupData[indexPath.item]["name"]! as! String
        
    // 在select 下判斷（如果選到哪一隊....）
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")
        cell?.textLabel?.text = groupData[indexPath.item]["name"] as? String

        return cell!
    }

}
