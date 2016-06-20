//
//  ViewController.swift
//  Forecastone
//
//  Created by Satoru Hosaka on 2015/06/30.
//  Copyright (c) 2015年 Satoru Hosaka. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var Background: UIView!
    
    @IBOutlet weak var button: UIButton!
    
    var preprecipArray: [Int] = [Int](count:11, repeatedValue:0)
    var precipArray: [Int] = [Int](count:8, repeatedValue:0)
    
    var player: AVAudioPlayer?
    var soundManager = SEManager()
    var sound: String = " "
    var a = 0.0
    var b:Int = 0
    let height:CGFloat = UIScreen.mainScreen().bounds.size.height
    let width:CGFloat = UIScreen.mainScreen().bounds.size.width
    var d:CGFloat = 0.0
//    let color       = UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 0.5)
//    let color2       = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//    let color3       = UIColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 0.5)
//    let color4       = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    let colorArray : [UIColor] = [UIColor(red: 0.0, green: 0.5, blue: 0.5, alpha: 0.5),UIColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 0.5),UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 0.5),UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)]
    var n:CGFloat = 0
    var k:CGFloat = 0.0
    var timer1:NSTimer!
    var timer2:NSTimer!
    var flag = 0
    var first = 0
    var moveView:UIView!
    var time:Int = 0
    var colorNum:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.whiteColor()
        let now = NSDate()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH"
        let string = formatter.stringFromDate(now)
        time = Int(string)!
        print(time)

        self.moveView = UIView(frame: CGRectMake(-width, 0, width, height))
        self.moveView.backgroundColor = colorArray[1]
        self.view.addSubview(self.moveView)
        
        // Do any additional setup after loading the view, typically from a nib.
        let urlString = "http://www.drk7.jp/weather/xml/13.xml"
        let url = NSURL(string: urlString)!
        let parser = NSXMLParser(contentsOfURL: url)!
        let delegate = MyParserDelegate()

        parser.delegate = delegate
        parser.parse()
        
        self.view.addSubview(moveView)
        self.view.sendSubviewToBack(moveView)
        
        for i in 0...10 {
            preprecipArray[i] = delegate.send(i)
        }
        judgenow(time)
        print(precipArray)

        //precipArray = [20, 90, 30, 0, 80, 20, 60, 50]


    }
    
    func judgenow(time:Int){
        for i in 0...7 {
            if(time<6){
                precipArray[i]=preprecipArray[i]
                colorNum = 0
                
            }
            else if(time>5 && time<12){
                precipArray[i]=preprecipArray[i+1]
                colorNum = 1

            }
            else if(time>11 && time<18){
                precipArray[i]=preprecipArray[i+2]
                colorNum = 2

            }
            else if(time > 17){
                precipArray[i]=preprecipArray[i+3]
                colorNum = 3
            }
        }
        
    }
    
    func play(){
        button.setTitle("■", forState: .Normal)
        flag = 1
        if(b == 0){
            sel()
        }
        a=2.4*Double(first)
        //for i in 0...8 {
            //if(flag==1 && stop==0){
            //a = Double(i) * 2.4
            //k = Double(i) * 2.4/(2*2)
            //timer1 = NSTimer.scheduledTimerWithTimeInterval(a, target: self, selector: "bar", userInfo: nil, repeats: false)
            
            timer2 = NSTimer.scheduledTimerWithTimeInterval(2.4, target: self, selector: #selector(ViewController.sel), userInfo: nil, repeats: true)
    }
    
    func initial(){
        judgenow(time)
        button.setTitle("▶︎", forState: .Normal)
        a = 0
        b = 0
        d = 0
        timer2.invalidate()
        //bar()
        flag = 0
        //stop = 1
        print("stop")
        moveView.removeFromSuperview()
        self.moveView = UIView(frame: CGRectMake(-self.width, 0, self.width, self.height))
        self.moveView.backgroundColor = self.colorArray[colorNum]
        self.view.addSubview(self.moveView)
        self.view.sendSubviewToBack(self.moveView)
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sel() {
        if(b == 8) {
            b = 0
            //tone(precipArray[b])
            d = 0
            anim(b)
            initial()

        }
        else {
        tone(precipArray[b])
        b += 1
        print(b)
        anim(b)
        }
    }
    
    func bar() {
        //anim()
        if(flag==1){

        d += width/16
            //sampleDrawing.removeFromSuperview()

        }
        else{
        //sampleDrawing.removeFromSuperview()
        self.view.setNeedsDisplay()
        }
    }
    
    func anim(b:Int){
        let span:CGFloat = width/8
        k = span * CGFloat(b)
        if (self.colorNum > 3){
            self.colorNum = 0
        }
        UIView.animateWithDuration(2.4,delay: 0.0,options: [UIViewAnimationOptions.CurveEaseOut,UIViewAnimationOptions.AllowAnimatedContent],
            animations: {() -> Void  in
                self.moveView.frame.origin.x = -self.width + self.k
                self.moveView.backgroundColor = self.colorArray[self.colorNum]
            },completion: {(Bool) -> Void in
                if(b == 8){
                //self.initial()
                }

        })
                self.colorNum += 1
    }
    
    func tone(i: Int) {
        switch i {
        case 0:
            sound = "0.wav"
        case 10:
            sound = "10.wav"
        case 20:
            sound = "20.wav"
        case 30:
            sound = "30.wav"
        case 40:
            sound = "40.wav"
        case 50:
            sound = "50.wav"
        case 60:
            sound = "60.wav"
        case 70:
            sound = "70.wav"
        case 80:
            sound = "80.wav"
        case 90:
            sound = "90.wav"
        default:
            break
        }
        soundManager.sePlay(sound)
    }

    @IBAction func Replay(sender: AnyObject) {
        if(flag == 0){
            bar()
            play()
        }else{
            initial()
        }
    }
    
}


