//
//  VenueDetailViewController.swift
//  VenueSearch
//
//  Created by Rahul Tamrakar on 09/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import UIKit

class VenueDetailViewController: UIViewController {

    var venueDetail:[String: Any] = [:]
    
    @IBOutlet weak var lblVenueName: UILabel!
    @IBOutlet weak var lblVenueAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblVenueName.text = venueDetail["name"] as! String?
        
        let location = venueDetail["location"] as! [String: Any]
        
        let formattedAddress:[String]? = location["formattedAddress"] as? [String]
        
        if formattedAddress != nil {
            lblVenueAddress.text = formattedAddress!.joined(separator: "\n")
        }
        else{
            lblVenueAddress.text = "No Address Found"
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
