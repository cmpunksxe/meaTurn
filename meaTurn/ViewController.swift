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
    
    //different rotation angles for different image alignment (0,45,90,135,180,-45,-90,-135)
    var rotationAngleArray = [0, M_PI/4, M_PI/2, (3*M_PI)/4, M_PI, -M_PI/4, -M_PI/2, (-3*M_PI)/4]
    
    var leftImageIndex: Int = 0
    var imgViewIndex: Int = 0
    var points: Int = 0
    var winingpoints: Int = 25
    var rightImageViewArray:Array<Any> = []
    var ImageArray:Array<Any> = []
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //add background image to parent view
        if let image = UIImage(named: "dott.png") {
            view.backgroundColor = UIColor(patternImage: image)
        }
        
        rightImagView1.tag = 1
        rightImagView2.tag = 2
        rightImagView3.tag = 3
        
        loadImageArray()
        loadandAlignImages()
        
        //add tap gesture in rightImagView1 for clicking in image
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.image1Taped(_:)))
        rightImagView1.isUserInteractionEnabled = true
        tapGestureRecognizer1.numberOfTapsRequired = 1
        rightImagView1.addGestureRecognizer(tapGestureRecognizer1)
        
        //add tap gesture in rightImagView1 for clicking in image
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.image2Taped(_:)))
        rightImagView2.isUserInteractionEnabled = true
        tapGestureRecognizer2.numberOfTapsRequired = 1
        rightImagView2.addGestureRecognizer(tapGestureRecognizer2)
        
        //add tap gesture in rightImagView1 for clicking in image
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.image3Taped(_:)))
        rightImagView3.isUserInteractionEnabled = true
        tapGestureRecognizer3.numberOfTapsRequired = 1
        rightImagView3.addGestureRecognizer(tapGestureRecognizer3)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //hide status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //dissmiss alert and start new game
    func alertClose(_ sender:AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
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
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
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
                Alert(title:"Congratulation", message:"You win the game")
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
        
        "icon31.png","icon32.png","icon33.png","icon34.png","icon35.png","icon36.png","icon38.png","icon39.png","icon40.png",
     "icon41.png","icon42.png","icon92.png","icon93.png","icon94.png","icon95.png","icon96.png","icon97.png","icon98.png","icon99.png","icon100.png",
    "icon101.png","icon102.png","icon103.png","icon104.png","icon105.png","icon106.png","icon107.png","icon108.png","icon109.png","icon110.png",
    "icon111.png","icon112.png","icon113.png","icon114.png","icon115.png","icon116.png","icon117.png","icon118.png","icon119.png","icon120.png",
    "icon121.png","icon122.png","icon123.png","icon124.png","icon125.png","icon126.png","icon127.png","icon128.png","icon129.png","icon130.png",
    
        "icon131.png","icon132.png","icon133.png","icon134.png","icon135.png","icon136.png","icon137.png" ]
        
      
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

    //right side imageview1 tap event
    func image1Taped(_ sender:AnyObject){
        
        playSound()
        
        if(sender.view.tag == imgViewIndex){
            print("True")
            points += 1
            pointLbl.text = String(points) + "/25"
        }
        else{
            print("False")
        }
        
        loadandAlignImages()
    }
    
    //right side imageview2 tap event
    func image2Taped(_ sender:AnyObject){
        
        playSound()
        
        if(sender.view.tag == imgViewIndex){
            print("True")
            points += 1
            pointLbl.text = String(points) + "/25"
        }
        else{
            print("False")
        }
        
        loadandAlignImages()
    }
    
    //right side imageview3 tap event
    func image3Taped(_ sender:AnyObject){
        
        playSound()
        
        if(sender.view.tag == imgViewIndex){
            print("True")
            points += 1
            pointLbl.text = String(points) + "/25"
        }
        else{
            print("False")
        }
        
        loadandAlignImages()
    }
    
    //play a sound with image click
    func playSound() {
        guard let url = Bundle.main.url(forResource: "click", withExtension: "mp3") else {
            print("url not found")
            return
        }
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
}

