//
//  ViewController.swift
//  redDemo
//
//  Created by 王俊钢 on 2019/6/18.
//  Copyright © 2019 wangjungang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var start: UIButton!
    
    @IBOutlet weak var end: UIButton!
    var timer:Timer = Timer.init()//定时器
    var moveLayer :CALayer = CALayer.init()//动画layer
    var bgView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgView.frame = self.view.bounds
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(self.click))
        bgView.addGestureRecognizer(tap)
        self.view.addSubview(bgView)
        
        self.view.bringSubviewToFront(start)
        self.view.bringSubviewToFront(end)
    }
    
    @objc func click(tapgesture:UITapGestureRecognizer) -> Void {
        let touchPoint = tapgesture.location(in: bgView)
        
        if let sublayers = bgView.layer.sublayers {
            for e in sublayers.enumerated() {
                if (e.element.presentation()!.hitTest(touchPoint) != nil) {
                    //print("点中了第\(e.index)个元素")
                    print(e.element.presentation()!.frame)
                    
                    let imageV = UIImageView.init()
                    imageV.image = UIImage.init(named: "x")
                    imageV.frame = e.element.presentation()!.frame
                    self.view.addSubview(imageV)
                    self.view.bringSubviewToFront(imageV)
                    self.endAction(sender: NSNull())
                    break
                }
            }
        }
    }
    
    @IBAction func beginAction(sender: AnyObject) {
        //防止timer重复添加
        self.timer.invalidate()
        
        self.timer =  Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.showRain), userInfo: "", repeats: true)
        
    }
    
    
    @objc func showRain(){
        
        //创建画布
        let imageV = UIImageView.init()
        imageV.image = UIImage.init(named: "x")
        imageV.frame = CGRect.init(x: 0, y: 0, width: 140, height: 140)
        //这里把这句消除动画有问题
        self.moveLayer = CALayer.init()
        self.moveLayer.bounds = (imageV.frame)
        self.moveLayer.anchorPoint = CGPoint.init(x: 0, y: 0)
        //此处y值需比layer的height大
        self.moveLayer.position = CGPoint.init(x: 0, y: -140)
        self.moveLayer.contents = imageV.image!.cgImage
        
        bgView.layer.addSublayer(self.moveLayer)
        //画布动画
        self.addAnimation()
        
    }
    
    //给画布添加动画
    func addAnimation() {
        //此处keyPath为CALayer的属性
        let  moveAnimation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath:"position")
        //动画路线，一个数组里有多个轨迹点
//        moveAnimation.values = [NSValue.init(cgPoint: CGPointMake(CGFloat(Float(arc4random_uniform(320))), 10)),NSValue.init(cgPoint: CGPointMake(CGFloat(Float(arc4random_uniform(320))), 500))]
        
        let float1 = (arc4random_uniform(320))
        
        let float2 = (arc4random_uniform(320))

        moveAnimation.values = [NSValue.init(cgPoint: CGPoint.init(x: Int(float1), y: 10)),NSValue.init(cgPoint: CGPoint.init(x: Int(float2), y: 500))]
        
        //动画间隔
        moveAnimation.duration = 5
        //重复次数
        moveAnimation.repeatCount = 1
        //动画的速度
        moveAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        self.moveLayer.add(moveAnimation, forKey: "move")
    }
    
    @IBAction func endAction(sender: AnyObject) {
        
        self.timer.invalidate()
        //停止所有layer的动画
        
        if let sublayers = bgView.layer.sublayers {
            for item in sublayers {
                item.removeAllAnimations()
                item.removeFromSuperlayer()
            }
        }
    }

}

