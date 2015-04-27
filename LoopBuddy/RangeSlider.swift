//
//  RangeSlider.swift
//  CustomSlider
//
//  Created by Westley Russell on 3/22/15.
//  Copyright (c) 2015 Westley Russell. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {
    
    var minimumValue: Double = 0.0{
        didSet{
            updateLayerFrames()
        }
    }
    var maximumValue: Double = 1.0{
        didSet{
            updateLayerFrames()
        }
    }
    var lowerValue: Double = 0.0{
        didSet{
            updateLayerFrames()
        }
    }//value set by user
    var upperValue:Double = 1.0{
        didSet{
            updateLayerFrames()
        }
    }//value set by user
    
    //used for rendering
    let trackLayer = RangeSliderTrackLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    
    var preveiousLocation = CGPoint()
    
    var trackTintColor:UIColor = UIColor(white: 0.9, alpha: 1.0){
        didSet{
            trackLayer.setNeedsDisplay()
        }
    }
    var trackHighlightTintColor:UIColor = UIColor(red:32/255, green:108/255, blue:128/255, alpha:1.0){
        didSet{
            trackLayer.setNeedsDisplay()
        }
    }
    var thumbTintColor:UIColor = UIColor(red:245/255, green:99/255, blue:86/255, alpha:1.0){
        didSet{
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    var curvaceousness: CGFloat = 0.0{
        didSet{
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    
    
    var thumbWidth: CGFloat{
        return CGFloat(bounds.height)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(upperThumbLayer)
        
        updateLayerFrames()
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.rectByInsetting(dx: 0.0, dy: bounds.height/3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        lowerThumbLayer.frame = CGRect(x:lowerThumbCenter - thumbWidth / 10.0, y: 0.0, width: thumbWidth/10, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperThumbLayer.frame = CGRect(x:upperThumbCenter - thumbWidth / 10.0, y: 0.0, width: thumbWidth/10, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        CATransaction.commit()
        
    }
    
    func positionForValue(value: Double) -> Double{
        return Double(bounds.width - thumbWidth/10) * (value - minimumValue) / (maximumValue - minimumValue) + Double(thumbWidth/10)
    }
    
    override var frame: CGRect{
        didSet{
            updateLayerFrames()
        }
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        preveiousLocation = touch.locationInView(self)
        
        if lowerThumbLayer.frame.contains(preveiousLocation){
            lowerThumbLayer.highlighted = true
        }
        else if upperThumbLayer.frame.contains(preveiousLocation){
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    func boundValue(value: Double, toLowerValue lowerValue:Double, upperValue:Double)->Double{
        return min(max(value, lowerValue), upperValue)
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let location = touch.locationInView(self)
        
        //determine how much the user has dragged
        let deltaLocation = Double(location.x - preveiousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
        
        preveiousLocation = location
        
        //update the values
        if lowerThumbLayer.highlighted{
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        }
        else if upperThumbLayer.highlighted{
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        
        
        sendActionsForControlEvents(.ValueChanged)
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
    

}
