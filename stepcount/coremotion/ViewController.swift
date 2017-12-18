//
//  ViewController.swift
//  coremotion
//
//  Created by Nisha Raghu on 14/08/17.
//  Copyright © 2017 cmpe297. All rights reserved
//

import UIKit
import Darwin
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet var stepCount: UILabel!
    @IBOutlet var ascFloor: UILabel!
    @IBOutlet var descFloor: UILabel!
    @IBOutlet var distance: UILabel!
    
    @IBOutlet weak var activityText: UILabel!
    
    let activityManager = CMMotionActivityManager()
    var timer: Timer!
    var initialStartDate : NSDate?
    let pedoMeter = CMPedometer()
    var lastActivity : CMMotionActivity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update() {
    
        countStepsMotion()
    }
   

    //Helper function to count step
    func countStepsMotion() {
        if (CMPedometer.isStepCountingAvailable() && CMPedometer.isFloorCountingAvailable()) {
            print("support step count...")
            if initialStartDate == nil {
                initialStartDate = NSDate(timeIntervalSinceNow: -(1 * 60 * 60)) //1 hour ago
            }
            pedoMeter.startUpdates(from: initialStartDate! as Date, withHandler: { data, error in
                guard let data = data else {
                    return
                }
                print("check updating...")
                if error != nil {
                    print("Error obtaining pedometer data: \(error)")
                } else {
                    print(data)
                    DispatchQueue.main.async(execute: { () -> Void in
                    
                        self.ascFloor.text = "\(data.floorsAscended!)"
                        self.descFloor.text = "\(data.floorsDescended!)"
                        self.stepCount.text = "\(data.numberOfSteps)"
                        var distance = data.distance?.doubleValue
                        distance = Double(round(80 * distance!) / 100)
                        self.distance.text = "\(distance!)"
                    })
                }
            })
        } else {
            print("Step count is not available")
        }
    }
    
    @IBAction func startBtn(_ sender: UIButton) {
        if initialStartDate == nil {
            initialStartDate = NSDate()
        }
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        print(timer)
    }

    @IBAction func stopBtn(_ sender: UIButton) {
        self.timer.invalidate()
        pedoMeter.stopUpdates()
    }


    @IBAction func closeBtn(_ sender: UIButton) {
        exit(0)
    }
}
