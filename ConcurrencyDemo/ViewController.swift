//
//  ViewController.swift
//  ConcurrencyDemo
//
//  Created by Hossam Ghareeb on 11/15/15.
//  Copyright © 2015 Hossam Ghareeb. All rights reserved.
//

import UIKit

let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg",
                 "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg",
                 "http://www.pulse.lk/wp-content/uploads/2015/10/ireland-02.jpg",
                 "https://i.pinimg.com/originals/ac/1d/f9/ac1df9827ddce83e4daba8fc0f36639a.jpg"]

class Downloader {
    
    class func downloadImageWithURL(url:String) -> UIImage! {
        guard let imageURL = URL(string: url) else { return UIImage() }
        let data = try? Data(contentsOf: imageURL)
        if let data = data {
            return UIImage(data: data)
        } else {
            return UIImage()
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    var queue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didClickOnStart(sender: Any) {
        let operation1 = BlockOperation { () -> Void in
            let img1 = Downloader.downloadImageWithURL(url: imageURLs[0])
            OperationQueue.main.addOperation {
                self.imageView1.image = img1
            }
        }
        operation1.completionBlock = {
            print("Operation 1 is completed, cancelled: \(operation1.isCancelled)")
        }
        queue.addOperation(operation1)
        
        let operation2 = BlockOperation { () -> Void in
            let img2 = Downloader.downloadImageWithURL(url: imageURLs[1])
            OperationQueue.main.addOperation {
                self.imageView2.image = img2
            }
        }
        operation2.completionBlock = {
            print("Operation 2 is completed, cancelled: \(operation2.isCancelled)")
        }
        operation2.addDependency(operation1)
        queue.addOperation(operation2)
        
        let operation3 = BlockOperation { () -> Void in
            let img3 = Downloader.downloadImageWithURL(url: imageURLs[2])
            OperationQueue.main.addOperation {
                self.imageView3.image = img3
            }
        }
        operation3.completionBlock = {
            print("Operation 3 is completed, cancelled: \(operation3.isCancelled)")
        }
        operation3.addDependency(operation2)
        queue.addOperation(operation3)
        
        let operation4 = BlockOperation { () -> Void in
            let img4 = Downloader.downloadImageWithURL(url: imageURLs[3])
            OperationQueue.main.addOperation {
                self.imageView4.image = img4
            }
        }
        operation4.completionBlock = {
            print("Operation 4 is completed, cancelled: \(operation4.isCancelled)")
        }
        queue.addOperation(operation4)
    }
    
    @IBAction func didClickOnCancel(_ sender: Any) {
        self.queue.cancelAllOperations()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        self.sliderValueLabel.text = "\(sender.value * 100.0)"
    }
    
}

