//
//  TeamLeaderboardViewController.swift
//  Leaderboard
//
//  Created by 邱柏盛 on 2017/5/30.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TeamLeaderboardViewController: ButtonBarPagerTabStripViewController, IndicatorInfoProvider {
    
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
        
        let teamWins = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamWins")
        let teamWinR = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamWinR")
        let teamPts = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamPts")
        let teamReb = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamReb")
        let teamAst = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamAst")
        let teamStl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamStl")
        let teamBlk = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamBlk")
        let teamFGR = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamFGR")
        let team3PR = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "team3PR")
        let teamFTR = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "teamFTR")
        
        return [teamWins, teamWinR, teamPts, teamReb, teamAst, teamStl, teamBlk, teamFGR, team3PR, teamFTR]
    }
    
    // MARK: XLPagerTabStrip Protocol
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Team")
    }

}
