//
//  PlayerLeaderboardViewController.swift
//  Leaderboard
//
//  Created by 邱柏盛 on 2017/5/29.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PlayerLeaderboardViewController: ButtonBarPagerTabStripViewController, IndicatorInfoProvider {

    let purpleInspireColor = UIColor(red:0.13, green:0.03, blue:0.25, alpha:1.0)
    
    override func viewDidLoad() {
        
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
        
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
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let playerPts = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerPts")
        let playerReb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerReb")
        let playerAst = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerAst")
        let playerStl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerStl")
        let playerBlk = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerBlk")
        let playerFGR = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerFGR")
        let player3PR = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "player3PR")
        let playerFTR = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "playerFTR")
        
        return [playerPts, playerReb, playerAst, playerStl, playerBlk, playerFGR, player3PR, playerFTR]
    }
    
    // MARK: XLPagerTabStrip Protocol
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Player")
    }

}
