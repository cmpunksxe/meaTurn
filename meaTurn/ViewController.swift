//
//  ViewController.swift
//  meaTurn
//
//  Created by EMC on 7/16/18.
//  Copyright © 2018 Xorgeek. All rights reserved.
//

import UIKit
//import Darwin
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var leftImagView, rightImagView1: UIImageView!
    @IBOutlet var rightImagView2: UIImageView!
    @IBOutlet var rightImagView3: UIImageView!
    @IBOutlet var pointLbl: UILabel!
    
    let backView = UIImageView()
    var congratsView = UIImageView()
    
    //different rotation angles for different image alignment (0,45,90,135,180,-45,-90,-135)
    var rotationAngleArray = [0, M_PI/4, M_PI/2, (3*M_PI)/4, M_PI, -M_PI/4, -M_PI/2, (-3*M_PI)/4]
    
    var leftImageIndex: Int = 0
    var imgViewIndex: Int = 0
    var points: Int = 0
    var winingpoints: Int = 25
    var rightImageViewArray:Array<Any> = []
    var ImageArray:Array<Any> = []
    var player: AVAudioPlayer?
    
    var tapGestureRecognizer1 = UITapGestureRecognizer()
    var tapGestureRecognizer2 = UITapGestureRecognizer()
    var tapGestureRecognizer3 = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //add splash image
        addSplashImage()
    
        //add background image to parent view
        //if let image = UIImage(named: "dott.png") {
            view.backgroundColor = .white
        //}
        
        rightImagView1.tag = 1
        rightImagView2.tag = 2
        rightImagView3.tag = 3
        
        loadImageArray()
        loadandAlignImages()
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //hide status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //add splash image
    func addSplashImage(){
        
        let splashImage = UIImage(named: "splash1.png")
        let splashImageView = UIImageView(image: splashImage)
        splashImageView.contentMode = .scaleAspectFill
        splashImageView.frame = self.view.frame
        self.view.addSubview(splashImageView)
        self.view.bringSubviewToFront(splashImageView)
        UIView.animate(withDuration: 0.3, delay: 2.0, options: .transitionFlipFromLeft, animations: {() -> Void in
            
            let y: CGFloat = 0.0
            splashImageView.frame = CGRect(x: -(self.view.frame.size.width), y: y, width: (self.view.frame.size.width), height: (self.view
                .frame.size.height))
            
        }, completion: {(_ finished: Bool) -> Void in
            if finished {
                splashImageView.removeFromSuperview()
                self.addGestures()
            }
        })

    }
    
    
    //dissmiss alert and start new game
    @objc func alertClose(_ sender:AnyObject) {
        self.dismiss(animated: true, completion: nil)
        backView.removeFromSuperview()
        congratsView.removeFromSuperview()
        removeGestures()
        addGestures()
        
        //reinitialize data & start new game
        if points == winingpoints ||  ImageArray.count == 0{
            print("alert dismiss")
            self.view.makeToast("New Game Started")
            points = 0
//            pointLbl.text = "Points : " + String(points)
            pointLbl.text = String(points) + "/25"
            loadImageArray()
            loadandAlignImages()
        }
    }
    
    //show alert
    func Alert(title:String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(alert, animated: true, completion:{
            
            self.view.superview?.isUserInteractionEnabled = true
            self.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(_:))))
            
            let dismissControl = UIControl()
            dismissControl.addTarget(self, action: #selector(self.alertClose(_:)), for: .allTouchEvents)
            dismissControl.frame = alert.view.bounds
            alert.view.addSubview(dismissControl)
            
        })
    }
    
    func loadandAlignImages(){
        
        if points == winingpoints ||  ImageArray.count == 0  {
            
            //show congrats alert when win the game
            if points == winingpoints{
                animateImage()
            }
            //show sorry alert when loose the game
            else if ImageArray.count == 0{
                Alert(title:"Sorry", message:"You loose the game")
            }
            
        }
        
        //go to next image till the game win or loose
        else if ImageArray.count>0 {
            
            loadImageintoImageView()
            
            //rotate Left side Image with random alignment
            rotateImage(imgView: leftImagView, rightImageSet:false)
        }
    }
    
    
    //load images into an array
    func loadImageArray(){
      
        ImageArray = ["icon1.png","icon2.png","icon3.png","icon4.png","icon5.png","icon6.png","icon7.png","icon8.png","icon9.png","icon10.png",
                      
        "icon11.png","icon12.png","icon13.png","icon14.png","icon15.png","icon16.png","icon17.png","icon18.png","icon19.png","icon20.png",
            
        "icon21.png","icon22.png","icon23.png","icon24.png","icon25.png","icon26.png","icon27.png","icon28.png","icon29.png","icon30.png",
        
        "icon31.png","icon32.png","icon33.png","icon34.png","icon35.png","icon36.png","icon37.png","icon38.png","icon39.png","icon40.png",
     
        "icon41.png","icon42.png","icon43.png","icon44.png","icon45.png","icon46.png","icon47.png","icon48.png","icon49.png","icon50.png",
    
        "icon51.png","icon52.png","icon53.png","icon54.png","icon55.png","icon56.png","icon57.png","icon58.png","icon59.png","icon60.png",
    
        "icon61.png","icon62.png","icon63.png","icon64.png","icon65.png","icon66.png","icon67.png","icon68.png","icon69.png","icon70.png",
    
        "icon71.png","icon72.png","icon73.png","icon74.png","icon75.png","icon76.png","icon77.png","icon78.png","icon79.png","icon80.png",
    
        "icon81.png","icon82.png","icon83.png","icon84.png","icon85.png","icon86.png","icon87.png" ]
        
    
    }
    
    
    //load images into image views
    func loadImageintoImageView(){
        
        print(ImageArray.count)
       
        let ImageIndex = Int(arc4random() % UInt32(ImageArray.count))
        leftImagView.image = UIImage(named: ImageArray[ImageIndex] as! String)
        rightImagView1.image = UIImage(named: ImageArray[ImageIndex] as! String)
        rightImagView2.image = UIImage(named: ImageArray[ImageIndex] as! String)
        rightImagView3.image = UIImage(named: ImageArray[ImageIndex] as! String)
        ImageArray.remove(at: ImageIndex)
        
        rotationAngleArray = [0, M_PI/4, M_PI/2, (3*M_PI)/4, M_PI, -M_PI/4, -M_PI/2, (-3*M_PI)/4]
        rightImageViewArray = [rightImagView1,rightImagView2,rightImagView3]
    }
    
    
    
    //rotate Images with random alignment
    func rotateImage(imgView:UIImageView, rightImageSet:Bool) {
        
        //rotate left side image
        if imgView == leftImagView{
            
            leftImageIndex = Int(arc4random() % UInt32(rotationAngleArray.count))
            animateRotatingViews(imgView:imgView, angle:CGFloat(self.rotationAngleArray[self.leftImageIndex]))
            setLeftImagetoRight(rightImageSet:true)
        }
        else{
            animateRotatingViews(imgView:imgView, angle:CGFloat(rotationAngleArray[leftImageIndex]))
            rotationAngleArray.remove(at: leftImageIndex)

            //rotate right side remaining two images
            let randomIndex1 = Int(arc4random() % UInt32(rotationAngleArray.count))
            let index: Int = (rightImageViewArray as NSArray).index(of: imgView)
            rightImageViewArray.remove(at: index)
            animateRotatingViews(imgView:(rightImageViewArray[0] as! UIImageView), angle:CGFloat(rotationAngleArray[randomIndex1]))
            rotationAngleArray.remove(at: randomIndex1)
            
            let randomIndex2 = Int(arc4random() % UInt32(rotationAngleArray.count))
            animateRotatingViews(imgView:(rightImageViewArray[1] as! UIImageView), angle:CGFloat(rotationAngleArray[randomIndex2]))

        }
        
    }
    
    
    
    //animate when rotating imageviews
    func animateRotatingViews(imgView:UIImageView, angle:CGFloat){
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: {() -> Void in
            
            imgView.transform = CGAffineTransform(rotationAngle: angle)
            
        }) { _ in }
    }

    
    

    //set left image to right side in a random imageview
    func setLeftImagetoRight(rightImageSet:Bool){
        
            imgViewIndex = Int(arc4random() % UInt32(rightImageViewArray.count))+1
            
          //  print(imgViewIndex)
            
            if rightImagView1.tag == imgViewIndex{
              //  print("imageview1")
                rotateImage(imgView: rightImagView1, rightImageSet:rightImageSet)
            }else if rightImagView2.tag == imgViewIndex{
              //  print("imageview2")
                rotateImage(imgView: rightImagView2, rightImageSet:rightImageSet)
            }else {
               // print("imageview3")
                rotateImage(imgView: rightImagView3, rightImageSet:rightImageSet)
            }

        }
    
    
    //play appropriate sound
    func playSound(){
        
        if points == winingpoints{
            playSound(Resource:"complete", Extension:"wav")
        }
        else{
            playSound(Resource:"click", Extension:"mp3")
        }
        
        //     playSound(Resource:"click", Extension:"mp3")
  
    }
    

    //right side imageview1 tap event
    @objc func image1Taped(_ sender:AnyObject){
        
        if(sender.view.tag == imgViewIndex){
            print("True")
            points += 1
            pointLbl.text = String(points) + "/25"
            playSound()
            loadandAlignImages()
        }
        else{
            print("False")
            sender.view.shake()
        }
        
    }
    
    //right side imageview2 tap event
    @objc func image2Taped(_ sender:AnyObject){
        
        if(sender.view.tag == imgViewIndex){
            print("True")
            points += 1
            pointLbl.text = String(points) + "/25"
            playSound()
            loadandAlignImages()
        }
        else{
            print("False")
            sender.view.shake()
        }
        
        
    }
    
    //right side imageview3 tap event
    @objc func image3Taped(_ sender:AnyObject){
        
            if(sender.view.tag == imgViewIndex){
                print("True")
                points += 1
                pointLbl.text = String(points) + "/25"
                playSound()
                loadandAlignImages()
            }
            else{
                print("False")
                sender.view.shake()
            }
        
    }
    
    //play a sound with image click
  //  func playSound() {
        
    func playSound(Resource:String, Extension:String) {
        
        guard let url = Bundle.main.url(forResource: Resource, withExtension: Extension) else {
            print("url not found")
            return
        }
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    
    //add tap gestures to imageviews
    func addGestures() {
        
        //add tap gesture in rightImagView1 for clicking in image
        tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.image1Taped(_:)))
        rightImagView1.isUserInteractionEnabled = true
        tapGestureRecognizer1.numberOfTapsRequired = 1
        rightImagView1.addGestureRecognizer(tapGestureRecognizer1)
        
        //add tap gesture in rightImagView2 for clicking in image
        tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.image2Taped(_:)))
        rightImagView2.isUserInteractionEnabled = true
        tapGestureRecognizer2.numberOfTapsRequired = 1
        rightImagView2.addGestureRecognizer(tapGestureRecognizer2)
        
        //add tap gesture in rightImagView3 for clicking in image
        tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.image3Taped(_:)))
        rightImagView3.isUserInteractionEnabled = true
        tapGestureRecognizer3.numberOfTapsRequired = 1
        rightImagView3.addGestureRecognizer(tapGestureRecognizer3)
    }
    
    
    
    //add a congratulation image when player score 25 points
    func animateImage(){
        
        removeGestures()
        
        let congratsImageArray = ["congrats1.png","congrats2.png","congrats3.png","congrats4.png","congrats5.png"]
        let imageIndex = Int(arc4random() % UInt32(congratsImageArray.count))
        
        //create a backview with alpha 0.7
        backView.frame = self.view.frame
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.7
        
        //create a imageview
        let congratsImage = UIImage(named: congratsImageArray[imageIndex])
        congratsView = UIImageView(image: congratsImage)
        congratsView.contentMode = .scaleAspectFit
        congratsView.frame = CGRect(x: backView.frame.size.width/4, y: backView.frame.size.height/4, width: backView.frame.size.width/2, height: backView.frame.size.height/2)
        congratsView.alpha = 1.0
       
        //add the views to parent view
        self.view.addSubview(backView)
        self.view.addSubview(congratsView)
        
        //smaller the views
        backView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        congratsView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        //animate the view
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            // animate it to the identity transform (100% scale)
            self.backView.transform = CGAffineTransform.identity
            self.congratsView.transform = CGAffineTransform.identity
        }, completion: {(_ finished: Bool) -> Void in
            // if you want to do something once the animation finishes, put it here
            
            self.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(_:))))
            
            print("anime complete")
        })
        
    }
    
    
    //remove gestures from right image views
    func removeGestures() {
        self.rightImagView1.removeGestureRecognizer(self.tapGestureRecognizer1)
        self.rightImagView2.removeGestureRecognizer(self.tapGestureRecognizer2)
        self.rightImagView3.removeGestureRecognizer(self.tapGestureRecognizer3)
    }
    
    
    
}


extension UIView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
