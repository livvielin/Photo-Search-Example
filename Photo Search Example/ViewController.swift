//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Livvie Lin on 2/16/15.
//  Copyright (c) 2015 Livvie Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchInstagramByHashtag("dogs")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        searchInstagramByHashtag(searchBar.text)
    
    }
    
    func searchInstagramByHashtag(searchString: String) {
        let manager = AFHTTPRequestOperationManager()
        manager.GET( "https://api.instagram.com/v1/tags/\(searchString)/media/recent?client_id=bf88a9bc7f58497ba3bb81e2dc40d846",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("JSON: " + responseObject.description)
                if let dataArray = responseObject["data"] as? [AnyObject] {
                    var urlArray:[String] = []
                    for dataObject in dataArray {
                        if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                            urlArray.append(imageURLString)
                        }
                    }
                    
                    // display urlArray in ScrollView
                    self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(dataArray.count))
                    for var i = 0; i < urlArray.count; i++ {
                        let imageData = NSData(contentsOfURL: NSURL(string: urlArray[i])!)
                        if let imageDataUnwrapped = imageData {
                            let imageView = UIImageView(frame: CGRectMake(0, 320*CGFloat(i), 320, 320))
                            imageView.setImageWithURL(NSURL(string: urlArray[i]))
                            self.scrollView.addSubview(imageView)
                        }
                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }


}