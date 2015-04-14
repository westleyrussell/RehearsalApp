//
//  ViewController.swift
//  LoopBuddy
//
//  Created by Westley Russell on 3/23/15.
//  Copyright (c) 2015 Westley Russell. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    var counter = 0
    let rangeSlider  = RangeSlider(frame: CGRectZero)
    let red = UIColor(red:245, green:99,blue:86,alpha:1.0)
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var sliderRate: UISlider!
    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    var song = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sweet Dreams", ofType: "mp3")!)
    var audioPlayer = AVAudioPlayer()
    var timer:NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(red:247/255, green:247/255,blue:247/255,alpha:1.0)
        
        if self.revealViewController() != nil {//set the menu button action listenter
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())//allows gesture use for viewing menu
        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: song, error: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.numberOfLoops = 0
        self.playButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
        audioPlayer.enableRate = true
        audioPlayer.delegate = self
        
        view.addSubview(rangeSlider)
        
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        
        
        setSongConstraints(rangeSlider.lowerValue, songEnd: rangeSlider.upperValue)
        
        

    }
    
    override func viewDidLayoutSubviews() {
        let margin:CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length + 15, width: width, height: 31.0)
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
    
    @IBAction func sliderRate(sender: AnyObject) {
        audioPlayer.rate = self.sliderRate.value
        updateSliderValue(audioPlayer.rate)
    }
    
    @IBAction func resetButton(sender: AnyObject) {
        self.sliderRate.value = 1.0
        rangeSlider.lowerValue = 0.0
        rangeSlider.upperValue = 1.0
        audioPlayer.rate = self.sliderRate.value
        updateSliderValue(audioPlayer.rate)
        setSongConstraints(rangeSlider.lowerValue, songEnd: rangeSlider.upperValue)
    }
    
    func updateSliderValue(value: Float){
    self.sliderValue.text = value.description
    
    }
    
    func setSongConstraints(songStart: Double, songEnd: Double){
        audioPlayer.currentTime = audioPlayer.duration * songStart
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "checkTime", userInfo: songStart, repeats:true)
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
    
    

}

