//
//  ViewController.swift
//  ScrollViewPage
//
//  Created by Charles Martin Reed on 8/15/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var featureScrollView: UIScrollView!
    
    @IBOutlet weak var featurePageControl: UIPageControl!
    
    
    //our "data" model
    let feature1 = ["title": "Apple Watch", "price": "$0.99", "image": "watchIcon"]
    let feature2 = ["title": "More Designs", "price": "$1.99", "image": "easelIcon"]
    let feature3 = ["title": "Notifications", "price": "$0.99", "image": "notificationIcon"]
    
    //the dictionary that will hold our feature vaues
    var featureArray = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adding the features to the featureArray
        //using an array so we can iterate over it
        featureArray = [feature1, feature2, feature3]
        
        //add the slide horizontal "paging" feature for our scroll view
        featureScrollView.isPagingEnabled = true
        
        //set the content size of the scroll view - multiply the width by the number of elements we have in our featureArray
        featureScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count), height: 250)
        
        //deactivate the scroll bar
        featureScrollView.showsHorizontalScrollIndicator = false
        
        //configure our scroll bar so that when it stops scrolls, the UIPageControl element reflects the current page
        featureScrollView.delegate = self
        
        loadFeatures()
    }

    func loadFeatures() {
        //enumerated gives us pairs of the index at a loop point, and the value at that point
        for (index, feature) in featureArray.enumerated() {
            if let featureView = Bundle.main.loadNibNamed("Feature", owner: self, options: nil)?.first as? FeatureView {
                featureView.featureImageView.image = UIImage(named: feature["image"]!)
                featureView.titleLabel.text = feature["title"]
                featureView.priceLabel.text = feature["price"]
                
                //using the index to tag the button and then using that button as sender information in our buyFeature() to determine what the user wants to buy
                featureView.purchaseButton.tag = index
                
                //adding the buyFeature() to our button
                featureView.purchaseButton.addTarget(self, action: #selector(ViewController.buyFeature(sender:)) , for: .touchUpInside)
                
                featureScrollView.addSubview(featureView)
                
                //make sure the featureView is the same size as our screen width
                featureView.frame.size.width = self.view.bounds.size.width
                
                //position the views correct - first view is 0, next view is 1 x screen size, next view is 2 x screen size
                featureView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
            }
        }
        
    }
    
    @objc func buyFeature(sender: UIButton) {
        //print("The user wants to buy feature \(sender.tag)")
        //force unwrapping works here because we know that if the button is visible, the dictionary and array are not nil and therefore must contain a title we can access.
        print("The user wants to buy the \(featureArray[sender.tag]["title"]!) add-on")
    }
    
    //called when the scroll view stops scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //figure out our page number and use it to set the current page attribute in our UIPageControl element
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        featurePageControl.currentPage = Int(page)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

