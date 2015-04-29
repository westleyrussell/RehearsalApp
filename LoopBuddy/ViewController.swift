//
//  ViewController.swift
//  LoopBuddy
//
//  Created by Westley Russell on 3/23/15.
//  Copyright (c) 2015 Westley Russell. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

class ViewController: UIViewController, AVAudioPlayerDelegate {
    var counter = 0
    let rangeSlider  = RangeSlider(frame: CGRectZero)
    let red = UIColor(red:245/255, green:99/255,blue:86/255,alpha:1.0)
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tempoLabel: UILabel!

    @IBOutlet weak var saveSampleButton: UIButton!
    @IBOutlet weak var saveSample: UIButton!
    @IBOutlet weak var tempoStepper: UIStepper!
    @IBOutlet weak var sliderEndPoint: UITextField!
    @IBOutlet weak var sliderStartPoint: UITextField!

    var songName:String = ""
    var song = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sweet Dreams", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    var timer:NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red:247/255, green:247/255,blue:247/255,alpha:1.0)
        //self.saveSample.layer.cornerRadius = 15.0

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        songName = appDelegate.songTitle
        println(songName)
        println(appDelegate.songUrl)
        self.songTitle.text = songName
        if var path = appDelegate.songUrl{
            println(path)
            self.song = path
        }
        
        if self.revealViewController() != nil {//set the menu button action listenter
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())//allows gesture use for viewing menu
            //TODO:Fix bug where using slider also brings out menu
        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: song, error: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = 0
        self.playButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
        audioPlayer.enableRate = true
        audioPlayer.delegate = self
        
        view.addSubview(rangeSlider)
        
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        rangeSlider.lowerValue = appDelegate.songStart
        rangeSlider.upperValue = appDelegate.songEnd
        
        setSongConstraints(rangeSlider.lowerValue, songEnd: rangeSlider.upperValue)
        

        self.saveSampleButton.layer.cornerRadius = 20.0
        
        self.tempoStepper.wraps = false
        self.tempoStepper.autorepeat = true
        self.tempoStepper.maximumValue = 2.0
        self.tempoStepper.minimumValue = 0.3 //anything lower and sound gets distorted
        self.tempoStepper.value = 1.0
        self.tempoStepper.stepValue = 0.1
    }
    
    
    override func viewDidLayoutSubviews() {
        let margin:CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length + 80, width: width, height: 31.0)
        
    }
    

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        audioPlayer.finalize()
    }

    func rangeSliderValueChanged(rangeSlider: RangeSlider){
        println("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
        setSongConstraints(rangeSlider.lowerValue, songEnd: rangeSlider.upperValue)
        
    }
    
    

    @IBAction func playButton(sender: AnyObject) {
        if self.playButton.currentImage == UIImage(named:"Play.png"){
            self.playButton.setImage(UIImage(named:"Pause.png"), forState: .Normal)
            audioPlayer.play()
        }
        //if self.playButton.titleLabel?.text == "Play"{
            //self.playButton.setTitle("Pause", forState: .Normal)
            //self.playButton.setImage(UIImage(named:"Pause.png"), forState: .Normal)
            //self.playButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15.0)
            
        //}
        else{
            
            self.playButton.setImage(UIImage(named:"Play.png"), forState: .Normal)
            
            audioPlayer.pause()
        }

    }
    
    @IBAction func resetButton(sender: AnyObject) {
        self.tempoStepper.value = 1.0
        rangeSlider.lowerValue = 0.0
        rangeSlider.upperValue = 1.0
        audioPlayer.rate = Float(self.tempoStepper.value)
        updateTempoLabel(audioPlayer.rate)
        setSongConstraints(rangeSlider.lowerValue, songEnd: rangeSlider.upperValue)
    }
    
    func updateTempoLabel(value: Float){
        self.tempoLabel.text = value.description
    
    }
    
    func setSongConstraints(songStart: Double, songEnd: Double){
        audioPlayer.currentTime = getStartPoint()
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkTime", userInfo: songStart, repeats:true)
        updateTimeTexts(getStartPoint(), end: getEndPoint())
    }
    
    func updateTimeTexts(start: Double, end: Double){
        sliderStartPoint.text = secondsToTime(start)
        sliderEndPoint.text = secondsToTime(end)
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully
        flag: Bool) {
            setSongConstraints(rangeSlider.lowerValue, songEnd: rangeSlider.upperValue)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
    }
    
    func checkTime() {
        if audioPlayer.currentTime >= audioPlayer.duration * rangeSlider.upperValue
        {
            timer.invalidate()
            setSongConstraints(rangeSlider.lowerValue, songEnd: rangeSlider.upperValue)
        }
    }
    
    func setStartPoint(value: Double) {
        var start = value
        if value < 0 { start = 0 }
        if value > 1.0 { start = 1.0 }
        setSongConstraints(start, songEnd: rangeSlider.upperValue)
    }
    
    func setEndPoint(value: Double) {
        var end = value
        if value < 0 { end = 0 }
        if value > 1.0 { end = 1.0 }
        setSongConstraints(rangeSlider.lowerValue, songEnd: end)
    }
    
    func getStartPoint() -> Double {
        return rangeSlider.lowerValue * audioPlayer.duration
    }
    
    func getEndPoint() -> Double {
        return rangeSlider.upperValue * audioPlayer.duration
    }
    @IBAction func saveSamplePress(sender: UIButton) {

            let alertController = UIAlertController(title: "Save Sample", message:
                "Save this sample of Song Title?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func tempoValueChanged(sender: UIStepper) {
        let speed = Double(round(10 * sender.value) / 10)
        tempoLabel.text = speed.description
        audioPlayer.rate = Float(speed)
    }
    @IBAction func startPointSet(sender: UITextField) {
        //setStartPoint(timeToPortion(sender.text))
    }

    @IBAction func endPointSet(sender: UITextField) {
        //setStartPoint(timeToPortion(sender.text))
    }
    
    func secondsToTime(seconds: Double) -> String {
        let hour = Int(seconds / 3600)
        let min = Int((seconds % 3600) / 60)
        let sec = Int(seconds % 60)
        
        var h = String(hour)
        if hour < 10 { h = "0" + h }
        var m = String(min)
        if min < 10 { m = "0" + m }
        var s = String(sec)
        if sec < 10 { s = "0" + s }
    
        if hour == 0 { return m + ":" + s }
        else { return h + ":" + m + ":" + s }
    }
    
    func timeToPortion(time: String) -> Double {
        return secondsToPortion(timeToSeconds(time))
    }
    
    //will break if not properly formatted. Oops.
    func timeToSeconds(time: String) -> Double {
        var result = 0.0
        if countElements(time) > 5 { //has hours
            result += (time.substringFromIndex(advance(time.endIndex, -2)) as NSString).doubleValue
            result += 60 * (time[Range(start: advance(time.endIndex, -5), end: advance(time.endIndex, -3))] as NSString).doubleValue
            result += 3600 * (time.substringToIndex(advance(time.endIndex, -6)) as NSString).doubleValue
        }
        else { //no hours
            result += 60.0 * (time.substringToIndex(advance(time.startIndex, 2)) as NSString).doubleValue
            result += (time.substringFromIndex(advance(time.startIndex, 3)) as NSString).doubleValue
        }
        
        return result
    }
    
    func secondsToPortion(seconds: Double) -> Double {
        return seconds / audioPlayer.duration
    }
}

