//
//  MateViewController.swift
//  basketbookCounter
//
//  Created by WuTungHan on 2017/5/31.
//  Copyright © 2017年 WuTungHan. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MateViewController: UIViewController, MCSessionDelegate, MCAdvertiserAssistantDelegate, MCBrowserViewControllerDelegate {
    
    var peerID:MCPeerID!
    var session:MCSession!
    var browser:MCBrowserViewController!
    var advertiser:MCAdvertiserAssistant? = nil
    @IBAction func connectBtn(_ sender: Any) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
