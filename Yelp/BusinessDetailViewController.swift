//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Daniel Ku on 2/15/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessDetailViewController: UIViewController{
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        businessImage.setImageWith((business.imageURL)!)
        nameLabel.text = business.name
        ratingImage.setImageWith((business.ratingImageURL)!)
        reviewCount.text = "\(business.reviewCount!) Reviews"
        distanceLabel.text = business.distance
        addressLabel.text = business.address
        categoryLabel.text = business.categories
//        userImage.setImageWith(business.reviewImageURL!)
//        nameLabel.text = business.reviewName
//        ratingImage.setImageWith(business.reviewRatingURL!)
//        reviewText.text = business.reviewExcerpt
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
