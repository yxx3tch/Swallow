//
//  UpdownCustomSegueUnwind.swift
//  Forecastone
//
//  Created by yxx3tch on 2016/07/21.
//  Copyright © 2016年 Satoru Hosaka. All rights reserved.
//

import UIKit

class UpdownCustomSegueUnwind: UIStoryboardSegue {
    
    override func perform() {
        
        //遷移元と遷移先のビューを取得する。
        let firstView = self.sourceViewController  as UIViewController!
        let secondView = self.destinationViewController as UIViewController!
        
        //画面高さを取得
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        //識別子で配置場所を分ける。
        if(identifier == "shitaswipe") {
            //画面上側の外に配置する。
            secondView.view.frame = CGRectMake(0, screenHeight, screenWidth, 2*screenHeight)
        } else {
            //画面左側の外に配置する。
            secondView.view.frame = CGRectMake(0, screenHeight, screenWidth, 2*screenHeight)
        }
        
        //遷移元ビューに遷移先ビューを追加する。
        //secondView.view.sendSubviewToBack(firstView.view)
        firstView.view.addSubview(secondView.view)
        //secondView.view.layoutIfNeeded()

        //アニメーション
        UIView.animateWithDuration(0.5,delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            secondView.view.frame = CGRectMake(0, 0,screenWidth, screenHeight)
        }) { (Finished) -> Void in
            secondView.view.layoutIfNeeded()
            //遷移先のビューコントローラーをモーダル表示にする。
            //firstView?.presentViewController(secondView!, animated: true, completion: nil)
            //firstView.view.removeFromSuperview()
            firstView.dismissViewControllerAnimated(false, completion: nil)
            //secondView?.view.setNeedsDisplay()
            //firstView?.navigationController?.popViewControllerAnimated(true)

        }


        
    }
}
