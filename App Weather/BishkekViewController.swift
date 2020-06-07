//
//  ViewController.swift
//  App Weather
//
//  Created by Aba-Bakri on 6/6/20.
//  Copyright © 2020 Ababakri Ibragimov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation

class BishkekViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let apiKey = "15d4af3159cec4b92dccf03706bf4701"
    
    var locationManager = CLLocationManager()
    var city = "Bishkek"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = city
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations[0]
        AF.request("http://api.openweathermap.org/data/2.5/weather?q=Bishkek&appid=\(apiKey)").responseJSON { response in
            
            if let responseStr = response.value {
                    let jsonResponse = JSON(responseStr)
                    let jsonWeather = jsonResponse["weather"].array![0]
                    let jsonTemp = jsonResponse["main"]
                    let iconName = jsonWeather["icon"].stringValue

                    self.cityLabel.text = jsonResponse["name"].stringValue
                    self.conditionImageView.image = UIImage(named: iconName)
                    self.conditionLabel.text = jsonWeather["main"].stringValue
                    self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)) - 273)℃"

                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "EEEE"
                    self.dayLabel.text = dateFormatter.string(from: date)
                }
            }
            self.locationManager.stopUpdatingLocation()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    @IBAction func almatyButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "BishkekViewController") as! BishkekViewController
        vc.title = "Almaty"
        vc.city = "Almaty"
        vc.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Add", style: .plain, target: self, action: nil)]
        navigationController?.pushViewController(vc, animated: true)
    }
}

