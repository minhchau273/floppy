//
//  ViewController.swift
//  floppy
//
//  Created by Harley Trung on 9/29/15.
//  Copyright © 2015 cheetah. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var birdView: UIImageView!
    
    var timer: NSTimer?
    var starting = false
    var uuid: String?
    
    var animator = UIDynamicAnimator()
    var gravity = UIGravityBehavior()
    var collision = UICollisionBehavior()
    var pipeProperties: UIDynamicItemBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "bg")?.drawInRect(self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        animator.addBehavior(gravity)
        
        collision.addItem(birdView)
        
        animator.addBehavior(collision)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onStart(sender: UIButton) {
        
        if starting {
            timer?.invalidate()
            animator.removeAllBehaviors()
        } else {
            starting = true
            
            gravity.addItem(birdView)
            
            uuid = NSUUID().UUIDString
            
            drawPipes()
            timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        }
        
        
    }
    
    func onTimer() {
        // draw new pipes
        drawPipes()
        
        // remove out of bound pipes
    }
    
    
    func drawPipes() {
        let frameHeight = Int(view.frame.height)
        
        let gapHeight = 200
        
        let minTopHeight = 50
        let maxTopHeight = Int(frameHeight * 40 / 100)
        let maxTopDelta = maxTopHeight - minTopHeight
        
        let rightBoundX = view.frame.width
        
        let r = arc4random_uniform(UInt32(maxTopDelta))
        let topPipeHeight: Int = minTopHeight + Int(r)
        
        let topPipe = UIImageView(image: UIImage(named: "pipeTop"))
        topPipe.frame = CGRect(x: Int(rightBoundX), y: 0, width: 40, height: topPipeHeight)
        
        let bottomPipeHeight = frameHeight - topPipeHeight - gapHeight
        
        let bottomPipe = UIImageView(image: UIImage(named: "pipeBottom"))
        bottomPipe.frame = CGRect(x: Int(rightBoundX), y: Int(view.frame.height) - bottomPipeHeight, width: 40, height: bottomPipeHeight)
        
        view.addSubview(topPipe)
        view.addSubview(bottomPipe)
        
        collision.addItem(topPipe)
        collision.addItem(bottomPipe)
        
        pipeProperties = UIDynamicItemBehavior(items: [topPipe, bottomPipe])
        pipeProperties!.addLinearVelocity(CGPoint(x: -50, y: 0), forItem: topPipe)
        pipeProperties!.addLinearVelocity(CGPoint(x: -50, y: 0), forItem: bottomPipe)
        pipeProperties!.resistance = 0
        pipeProperties!.density = 1000
        
        animator.addBehavior(pipeProperties!)
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        
        let birdItemBehavior = UIDynamicItemBehavior(items: [birdView])
        animator.addBehavior(birdItemBehavior)
        
        let initialVelocity = birdItemBehavior.linearVelocityForItem(birdView)
        print(initialVelocity)
        
        let push = UIPushBehavior(items: [birdView], mode: UIPushBehaviorMode.Instantaneous)
        
        let upY = abs(initialVelocity.y)
        
        birdItemBehavior.addLinearVelocity(CGPoint(x: 0, y: -upY), forItem: birdView)
        push.pushDirection = CGVectorMake(0, -1.5)
        push.active = true
        animator.addBehavior(push)
        
        
    }
    
    
    
    
    
    
    
}