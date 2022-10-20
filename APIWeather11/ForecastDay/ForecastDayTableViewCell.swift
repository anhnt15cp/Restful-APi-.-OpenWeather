//
//  ForecastDayTableViewCell.swift
//  APIWeather11
//
//  Created by Tuấn Anh on 19/10/2022.
//

import UIKit

class ForecastDayTableViewCell: UITableViewCell {

    @IBOutlet weak var daysLb: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var conditonWeather: UILabel!
    @IBOutlet weak var tempLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    func configuration(model: CurrentWeather) {
        daysLb.text = model.dt_txt ?? ""
        conditonWeather.text = model.weather?.first?.description ?? ""
        tempLb.text = String(format: "%@%@", model.main?.tempMin ?? "" , model.main?.tempMax ?? "")
    }
    
    
}
