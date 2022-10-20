//
//  HourlyWeatherTableViewCell.swift
//  APIWeather11
//
//  Created by Tuấn Anh on 18/10/2022.
//

import UIKit

class HourlyWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    var currentWeather: [CurrentWeather] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCollection()
      
    }
    func setupCollection() {
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        let nib = UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: nil)
        myCollectionView.register(nib, forCellWithReuseIdentifier: "HourlyWeatherCollectionViewCell")
       
       if let layout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
           layout.minimumLineSpacing = 0
           layout.minimumInteritemSpacing = 0
           layout.itemSize = CGSize(width: 100, height: 100)
           layout.scrollDirection = .horizontal
            
        }
    }
    
    func bindData(hourlyForecast: [CurrentWeather]) {
        self.currentWeather = hourlyForecast
        myCollectionView.reloadData()
        
        
    }
    func loadImageFromInternet(icon: String, completed: ((UIImage?) -> Void)?) {
        URLSession.shared.dataTask(with: NSURL(string: icon)! as URL, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                completed?(image)
            })
            
        }).resume()
    }
    
}
extension HourlyWeatherTableViewCell: UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currentWeather.count
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyWeatherCollectionViewCell", for: indexPath) as! HourlyWeatherCollectionViewCell
        let category = currentWeather[indexPath.row]
        cell.configuration(model: category)
        if let icon = category.weather?.first?.icon {
            loadImageFromInternet(icon: "https://openweathermap.org/img/wn/\(icon)@2x.png") { image in
                cell.iconImage.image = image
            }
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: myCollectionView.bounds.width, height: myCollectionView.bounds.height)
    }
    
    
}
