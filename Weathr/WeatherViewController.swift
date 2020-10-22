//
//  ViewController.swift
//  Weathr
//
//  Created by Yamusa Dalhatu on 10/12/20.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate{
   
    
    
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    let APP_ID = ""

    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLocationManager()
        
        
    }

    //TODO: Set up the location manager here
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    //MARK: - Location Manager Delegate Methods
    /**************************************************************************************/

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location  = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
//          print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String ] = ["lat" : latitude, "lon" : longitude, "appID" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Cannot get location!"
    }

    
    //MARK: - Networking
    /**************************************************************************************/
    func getWeatherData(url: String, parameters: [String:String]){
       
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { response in
            if response.result.isSuccess{
                print("Success! Got weather data")
                
                let weatherJSON: JSON =  JSON(response.result.value!)
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }

    
    //MARK: - JSON parsing 
    /**************************************************************************************/
    
    // Write the updateWeatherData method here:
    func updateWeatherData(json : JSON){
        
        // Optional binding
        if  let tempResult = json["main"]["temp"].double {
        
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
        updateUIWithWeatherData()
            
        } else{
            cityLabel.text = "Weather Unavailable!"
        }
    }

    
    //MARK : UI Updates
    /**************************************************************************************/
    
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city
//      temperatureLabel.text = String(weatherDataModel.temperature)
        temperatureLabel.text = "\(weatherDataModel.temperature)°C"
        weatherIcon.image = UIImage(named : weatherDataModel.weatherIconName)
    }
    
    
    func userEnteredANewCity(city: String) {
        
        let params : [String:String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCity" {
            let destinationVC = segue.destination as! CityViewController
             
            destinationVC.delegate = self
        }
    }
}

