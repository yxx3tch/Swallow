//
//  UpdownCustomSegue.swift
//  Forecastone
//
//  Created by yxx3tch on 2016/07/21.
//  Copyright © 2016年 Satoru Hosaka. All rights reserved.
//

import UIKit

class UpdownCustomSegue: UIStoryboardSegue {
    
    override func perform() {
        
        //遷移元と遷移先のビューを取得する。
        let firstView = self.sourceViewController.view
        let secondView = self.destinationViewController.view
        
        //画面高さを取得
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        //識別子で配置場所を分ける。
        if(identifier == "shitaswipe") {
            //画面上側の外に配置する。
            secondView.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight*2)
        } else {
            //画面左側の外に配置する。
            secondView.frame = CGRectMake(0, -screenHeight, screenWidth, 0)
        }
        
        //遷移元ビューに遷移先ビューを追加する。
        firstView.addSubview(secondView)
        
        //アニメーション
        UIView.animateWithDuration(0.5,delay: 0, options:UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            secondView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
            //firstView.frame = CGRectMake(0, screenHeight, screenWidth, screenHeight*2)
        }) { (Finished) -> Void in
            
            //遷移先のビューコントローラーをモーダル表示にする。
            self.sourceViewController.presentViewController(self.destinationViewController, animated: false, completion: nil)
        }
        
    }
}