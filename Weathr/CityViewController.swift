//
//  CityViewController.swift
//  Weathr
//
//  Created by Yamusa Dalhatu on 10/22/20.
//

import UIKit

protocol ChangeCityDelegate {
    
    func userEnteredANewCity(city: String)
}

class CityViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    
    // Declare the delegate variable here
    var delegate: ChangeCityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func getWeatherDataPressed(_ sender: Any) {
        
        let cityName = cityTextField.text!
        
        delegate?.userEnteredANewCity(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
