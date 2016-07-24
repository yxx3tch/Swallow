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
    
    @IBOutlet weak var resetbutton: UIButton!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var recbutton: UIButton!
    
    
    
    let fileManager = NSFileManager()
    var recorder: [AVAudioRecorder!] = Array(count:10,repeatedValue:nil)
    var recPlayer: [AVAudioPlayer!] = Array(count:10,repeatedValue:nil)
    let fileName: [String] = ["rec0.wav", "rec10.wav", "rec20.wav", "rec30.wav", "rec40.wav", "rec50.wav", "rec60.wav", "rec70.wav", "rec80.wav", "rec90.wav"]
    
    var now: String = ""
    var from: String = ""
    var playlength: Int = 0
    
    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }
    
    var preprecipArray: [Int] = [Int](count:11, repeatedValue:0)
    var precipArray: [Int] = [Int](count:8, repeatedValue:0)
    
    var player: AVAudioPlayer?
    var soundManager = SEManager()
    var sound: String = " "
    var a = 0.0
    var b:Int = 0
    var c:Int = 0
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
    var timer3:NSTimer!
    var flag = 0
    var recflag = 0
    var first = 0
    var moveView:UIView!
    var time:Int = 0
    var colorNum:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.layoutIfNeeded()
        self.setupAudioRecorder(10)
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

        //precipArray = [20, 90, 30, 0, 80, 20, 60, 50] //for debug
        
        //左スワイプ検知
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.didSwipe(_:)))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(leftSwipe)
        //moveView.addGestureRecognizer(leftSwipe)
        
        //右スワイプ検知
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.didSwipe(_:)))
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(rightSwipe)
        //moveView.addGestureRecognizer(rightSwipe)
        
        //上スワイプ検知
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.didSwipe(_:)))
        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(upSwipe)
        //moveView.addGestureRecognizer(upSwipe)

        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.didSwipe(_:)))
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(downSwipe)
        //moveView.addGestureRecognizer(downSwipe)
        moveView.hidden = true

    
        self.navigationController?.setNavigationBarHidden(true, animated: true)

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
        if self.restorationIdentifier == "rec"{
        recbutton.setTitle("■", forState: .Normal)
        }else{
        button.setTitle("■", forState: .Normal)
        }
        moveView.hidden = false
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
        moveView.hidden = true
        if self.restorationIdentifier == "rec"{
            recbutton.setTitle("▶︎", forState: .Normal)
            for i in 0 ... 7
            {
                recPlayer[i].stop()
            }
        }else{
            button.setTitle("▶︎", forState: .Normal)
        }
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
    
    func recanim(b:Int){
        let span:CGFloat = width/10
        k = span * CGFloat(b)
        //if (self.colorNum > 3){
        //    self.colorNum = 0
        //}
        UIView.animateWithDuration(2.4,delay: 0.0,options: [UIViewAnimationOptions.CurveEaseOut,UIViewAnimationOptions.AllowAnimatedContent],
                                   animations: {() -> Void  in
                                    self.moveView.frame.origin.x = -self.width + self.k
                                    self.moveView.backgroundColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 0.5)
            },completion: {(Bool) -> Void in
                if(b == 8){
                    //self.initial()
                }
                
        })
        //self.colorNum += 1
    }
    
    func tone(i: Int) {
        if self.restorationIdentifier == "main" { //1画面目で使うwavのファイル名を入れてください
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
        if self.restorationIdentifier == "sub01" { //2画面目で使うwavのファイル名を入れてください
        switch i {
        case 0:
            sound = "90.wav"
        case 10:
            sound = "80.wav"
        case 20:
            sound = "70.wav"
        case 30:
            sound = "60.wav"
        case 40:
            sound = "50.wav"
        case 50:
            sound = "40.wav"
        case 60:
            sound = "30.wav"
        case 70:
            sound = "20.wav"
        case 80:
            sound = "10.wav"
        case 90:
            sound = "0.wav"
        default:
            break
            }
        soundManager.sePlay(sound)
        }
        
        if self.restorationIdentifier == "sub02" { //3画面目で使うwavのファイル名を入れてください
            switch i {
            case 0:
                sound = "90.wav"
            case 10:
                sound = "80.wav"
            case 20:
                sound = "70.wav"
            case 30:
                sound = "60.wav"
            case 40:
                sound = "50.wav"
            case 50:
                sound = "40.wav"
            case 60:
                sound = "30.wav"
            case 70:
                sound = "20.wav"
            case 80:
                sound = "10.wav"
            case 90:
                sound = "0.wav"
            default:
                break
            }
            soundManager.sePlay(sound)
        }
        
        if self.restorationIdentifier == "rec" {
            switch i {
            case 0:
                playlength = 0
            case 10:
                playlength = 1
            case 20:
                playlength = 2
            case 30:
                playlength = 3
            case 40:
                playlength = 4
            case 50:
                playlength = 5
            case 60:
                playlength = 6
            case 70:
                playlength = 7
            case 80:
                playlength = 8
            case 90:
                playlength = 9
            default:
                break
            }
            for i in 0...playlength {
                recplay(i)
            }
        }
        
    }

    @IBAction func Replay(sender: AnyObject) {
        if(flag == 0){
            bar()
            play()
        }else{
            initial()
        }
    }
    
    @IBAction func Rec(sender: AnyObject) {
        if recflag == 0 {
        recbutton.setTitle("■", forState: .Normal)
        moveView.hidden = false
        //recbutton.titleLabel?.font = UIFont.systemFontOfSize(25)
        timer3 = NSTimer.scheduledTimerWithTimeInterval(2.4, target: self, selector: #selector(ViewController.recording), userInfo: nil, repeats: true)
        recflag = 1
        }
        else if recflag == 1 {
            recbutton.setTitle("●", forState: .Normal)
            recorder[c].stop()
            for i in 0 ... c - 1
            {
                recPlayer[i]?.stop()
            }
            timer3.invalidate()
            c = 0
            moveView.removeFromSuperview()
            self.moveView = UIView(frame: CGRectMake(-self.width, 0, self.width, self.height))
            self.moveView.backgroundColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 0.5)
            self.view.addSubview(self.moveView)
            self.view.sendSubviewToBack(self.moveView)
            recflag = 0
        }
        else if flag == 0 && recflag == 2{
            play()
        }
        else if flag == 1 && recflag == 2 {
            initial()
        }
    }
    
    @IBAction func reset(sender: AnyObject) {
        if flag == 1{
            initial()
        }
        resetbutton.hidden = true
        recbutton.setTitle("●", forState: .Normal)
        recflag = 0
    }
    
    
    func recording () {
        if(c == 10) {
            //play()
            //d = 0
            recanim(c)
            //initial()
            recbutton.setTitle("▶︎", forState: .Normal)
            recorder[c - 1].stop()
            for i in 0 ... c - 1
            {
                recPlayer[i]?.stop()
            }
            timer3.invalidate()
            c = 0
            moveView.removeFromSuperview()
            self.moveView = UIView(frame: CGRectMake(-self.width, 0, self.width, self.height))
            self.moveView.backgroundColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 0.5)
            self.view.addSubview(self.moveView)
            self.view.sendSubviewToBack(self.moveView)
            recflag = 2
            resetbutton.hidden = false
        }
        else {
            if c != 0{
                recorder[c - 1].stop()
                for i in 0...c - 1{
                    recplay(i)
                }
            }
            recorder[c].record()
            c += 1
            print(c)
            recanim(c)
        }
    
    }
    
    func recplay(i:Int) {
        do {
            try recPlayer[i] = AVAudioPlayer(contentsOfURL: self.documentFilePath(i))
        } catch {
            print("再生時にerror出たよ(´・ω・｀)")
        }
        recPlayer[i]?.play()
    }
    
    //スワイプ検知時の動作
    func didSwipe(sender: UISwipeGestureRecognizer){
        now = self.restorationIdentifier!
        if self.restorationIdentifier != "sub02" && self.restorationIdentifier != "rec" && sender.direction == UISwipeGestureRecognizerDirection.Left{
            if flag == 1 {
            initial()
            }
            switch now{
                case "main" :
            performSegueWithIdentifier("migiswipe1",sender: nil)
                case "sub01" :
            performSegueWithIdentifier("migiswipe2",sender: nil)

            default:
                break
            }

        }
        

        if self.restorationIdentifier != "rec" && sender.direction == UISwipeGestureRecognizerDirection.Down{
            if flag == 1{
                initial()
            }
            performSegueWithIdentifier("ueswipe",sender: nil)
            //self.restorationIdentifier = "sub02"
        }
        
        if self.restorationIdentifier! == "rec" && sender.direction == UISwipeGestureRecognizerDirection.Up{
            if flag == 1{
                initial()
            }
            if recflag == 1{
                recorder[c].stop()
                for i in 0 ... c
                {
                    recPlayer[i]?.stop()
                }
                timer3.invalidate()
                c = 0
                moveView.removeFromSuperview()
                recflag = 0
            }
            
            print(from)
            switch from{
            case "main" :
                performSegueWithIdentifier("shitaswipe1",sender: nil)
            case "sub01" :
                performSegueWithIdentifier("shitaswipe2",sender: nil)
            case "sub02" :
                performSegueWithIdentifier("shitaswipe3",sender: nil)
            default:
                break
            //self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            //self.restorationIdentifier = "main"
            }
        }
        
        if self.restorationIdentifier != "main" && self.restorationIdentifier != "rec" && sender.direction == UISwipeGestureRecognizerDirection.Right{
            if flag == 1{
            initial()
            }
            performSegueWithIdentifier("hidariswipe",sender: nil)
            //unwindToTop(RippleCustomSegueUnwind)

        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        let secondViewController = segue.destinationViewController as! ViewController
        secondViewController.from = self.now
    }
    
    func setupAudioRecorder(length:Int) {
        // 再生と録音機能をアクティブにする
        for i in 0...length - 1 {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! session.setActive(true)
        let recordSetting : [String : AnyObject] = [
            AVEncoderAudioQualityKey : AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey : 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        do {
            try recorder[i] = AVAudioRecorder(URL: self.documentFilePath(i), settings: recordSetting)
            //recorder!.delegate = self
            //recorder!.meteringEnabled = true
            recorder[i].prepareToRecord() // creates/overwrites the file at soundFileURL
            
        } catch {
            print("初期設定でerror出たよ(-_-;)")
        }
        }

    }

    func documentFilePath(i :Int)-> NSURL {
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let dirURL = urls[0]
        return dirURL.URLByAppendingPathComponent(fileName[i])
    }

    
}


