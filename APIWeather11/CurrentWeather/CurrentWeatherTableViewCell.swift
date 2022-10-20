//
//  CurrentWeatherTableViewCell.swift
//  APIWeather11
//
//  Created by Tuấn Anh on 17/10/2022.
//

import UIKit

class CurrentWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var placeLb: UILabel!
    @IBOutlet weak var conditionWeatherImage: UIImageView!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var teampLb: UILabel!
    @IBOutlet weak var contionWeatherLb: UILabel!
    @IBOutlet weak var windLb: UILabel!
    @IBOutlet weak var pressureLb: UILabel!
    @IBOutlet weak var rainLb: UILabel!
    @IBOutlet weak var humilityLb: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configuration(model: CurrentWeather) {
        placeLb.text = model.name
        teampLb.text = String(format: "%@", model.main?.temp1 ?? "")
        contionWeatherLb.text = model.weather?.first?.main
        windLb.text = String(format: "%0 .2F met/sec", model.wind?.speed ?? 0)
        pressureLb.text = String(format: "%0 .2F hPa", model.main?.pressure ?? 0)
        rainLb.text = String(format: "%0 .2F %%", model.clouds?.all ?? 0)
        humilityLb.text = String(format: "%0 .2F %%", model.main?.humility ?? 0)
        
    }
    
}
