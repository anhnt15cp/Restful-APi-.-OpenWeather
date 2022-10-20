//
//  HourlyWeatherCollectionViewCell.swift
//  APIWeather11
//
//  Created by Tuấn Anh on 18/10/2022.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var tempLb: UILabel!
    @IBOutlet weak var weatherConditionLb: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configuration(model: CurrentWeather) {
        timeLb.text = String(format: "%@  %@", model.main?.tempMin ?? "" , model.main?.tempMax ?? "")
        weatherConditionLb.text = model.weather?.first?.description
        tempLb.text = String(format: "%@", model.dt_txt ?? "")
        
    }
    
}
