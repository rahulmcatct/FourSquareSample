//
//  VenueListViewController.swift
//  VenueSearch
//
//  Created by Rahul Tamrakar on 09/03/17.
//  Copyright © 2017 Rahul Tamrakar. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class VenueListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    let apiEndpoint = "https://api.foursquare.com/v2/venues/search"
    let authToken   = "NFN51HFQGZBX4KFFNSX3PA0GZCXUSB2VJHKDIX23WWNVS12F"
    
    var venueList:[[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        // Refresh Venue List
        refreshVenueList()
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        refreshVenueList()
    }
    
    func refreshVenueList() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        manager.stopUpdatingLocation()
        fetchVenues(forLocation: locValue)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            fallthrough
        case .restricted:
            fallthrough
        case .notDetermined:
            let alert = UIAlertController.init(title: "Error", message: "Please check location services for app", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        default: break
        }
    }
    
    
    // Fetch venue list from FourSquare for location
    func fetchVenues(forLocation location:CLLocationCoordinate2D) {
        
        // Construct url
        let url = "\(apiEndpoint)?ll=\(location.latitude),\(location.longitude)&oauth_token=\(authToken)&v=\(todayDate)"
        
        Alamofire.request(url)
            .validate()
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                }
                
                guard let responseJSON = response.result.value as? [String: Any],
                let responseObj = responseJSON["response"] as? [String: Any],
                let venueList = responseObj["venues"] as? [[String: Any]]
                    else {
                        print("Invalid information received from the service")
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        return
                }

                // reset venue list
                self.venueList.removeAll()
                
                // filter required information
                for venue in venueList {
                    self.venueList.append(Dictionary(dictionaryLiteral: ("name",venue["name"]!),("location",venue["location"]!)))
                }
                
                // Reload table data
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // Formatted today date as String
    var todayDate: String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: today)
    }

    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Display venue Name
        cell.textLabel?.text        =  self.venueList[indexPath.row]["name"] as! String?
        
        // Display venue distance
        let location = self.venueList[indexPath.row]["location"] as? [String: Any]
        if location != nil {
            cell.detailTextLabel?.text  =  "Distance: \(location?["distance"]!) meters"
        }
        else{
            cell.detailTextLabel?.text = nil
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showVenueDetailSegue", sender: self.venueList[indexPath.row])
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let targetVC: VenueDetailViewController  = segue.destination as! VenueDetailViewController
        targetVC.venueDetail = sender as! [String : Any]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
