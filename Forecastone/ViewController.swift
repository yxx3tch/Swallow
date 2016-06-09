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
    
    var precipArray: [Int] = [Int](count:8, repeatedValue:0)
    var player: AVAudioPlayer?
    var soundManager = SEManager()
    var sound: String = " "
    var a = 0.0
    var b:Int = 0
    let height:CGFloat = UIScreen.mainScreen().bounds.size.height
    let width:CGFloat = UIScreen.mainScreen().bounds.size.height
    var d:CGFloat = 0.0
    let color       = UIColor(red: 0, green: 0.5, blue: 0.5, alpha: 0.5)
    var n:CGFloat = 0
    var k = 0.0
    var timer1:NSTimer!
    var timer2:NSTimer!
    var flag = 0
    //let sampleDrawing:UIView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let urlString = "http://www.drk7.jp/weather/xml/13.xml"
        let url = NSURL(string: urlString)!
        let parser = NSXMLParser(contentsOfURL: url)!
        let delegate = MyParserDelegate()

        parser.delegate = delegate
        parser.parse()
        
        for i in 0...7 {
            precipArray[i] = delegate.send(i)
        }
        
        //precipArray = [20, 90, 30, 0, 80, 20, 60, 50]


        print(precipArray)
//        for i in 0...8 {
//            a = Double(i) * 2.4
//            //k = Double(i) * 2.4/(2*2)
//            NSTimer.scheduledTimerWithTimeInterval(a, target: self, selector: "bar", userInfo: nil, repeats: false)
//            NSTimer.scheduledTimerWithTimeInterval(a, target: self, selector: "sel", userInfo: nil, repeats: false)
//        }
    }
    
    func play(){
        flag = 1
        for i in 0...8 {
            a = Double(i) * 2.4
            //k = Double(i) * 2.4/(2*2)
            //timer1 = NSTimer.scheduledTimerWithTimeInterval(a, target: self, selector: "bar", userInfo: nil, repeats: false)
            timer2 = NSTimer.scheduledTimerWithTimeInterval(a, target: self, selector: "sel", userInfo: nil, repeats: false)
            //NSRunLoop.currentRunLoop().addTimer(timer1, forMode: NSRunLoopCommonModes)
            //NSRunLoop.currentRunLoop().addTimer(timer2, forMode: NSRunLoopCommonModes)
        }
    }
    
    func initial(){
        b=0
        d=0
        flag=0
        //Background.removeFromSuperview()
        timer2.invalidate()
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sel() {
        bar()
        if(b == 8) {
            b = 0
            tone(precipArray[b])
            d = 0

        }
        else {
        tone(precipArray[b])
        b += 1
        print(b)

        }
    }
    
    func bar() {
        //while(d<width/16 * n){
        let sampleDrawing = UIView(frame: CGRectMake(d, 0, width/16, height))
        //self.sampleDrawing.sendSubviewToBack()
        sampleDrawing.backgroundColor = color
        view.addSubview(sampleDrawing)
        sampleDrawing.setNeedsDisplay()
        d += width/16
        //}
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
//            for i in 0...8 {
//            a = Double(i) * 2.4
//            NSTimer.scheduledTimerWithTimeInterval(a, target: self, selector: "sel", userInfo: nil, repeats: false)
//        }
        if(flag==1){
            initial()
        }
        play()

    }
    
}


