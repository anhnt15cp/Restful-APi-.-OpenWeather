//
//  ViewController.swift
//  APIWeather11
//
//  Created by Tuấn Anh on 17/10/2022.
//

import UIKit
import Alamofire
import ObjectMapper

enum WeatherSecction: Int,CaseIterable{
    case CurrentWeather
    case HourlyWeatherday
    case ForecastDay
}

class ViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    
    var places: LatLonPlace?
    var currentWeather: CurrentWeather?
    var currentDayForecast: [CurrentWeather]?
    var sections: [WeatherSecction] = []
    var forecastDay: [CurrentWeather]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDataFromAPI()
        setUpTable()
        sections = WeatherSecction.allCases
        
    }
    func setUpTable() {
        myTableView.dataSource = self
        myTableView.delegate = self
        let nib = UINib(nibName: "CurrentWeatherTableViewCell", bundle: nil)
        myTableView.register(nib, forCellReuseIdentifier: "CurrentWeatherTableViewCell")
        
        let nib1 = UINib(nibName: "HourlyWeatherTableViewCell", bundle: nil)
        myTableView.register(nib1, forCellReuseIdentifier: "HourlyWeatherTableViewCell")
        
        let nib2 = UINib(nibName: "ForecastDayTableViewCell", bundle: nil)
        myTableView.register(nib2, forCellReuseIdentifier: "ForecastDayTableViewCell")
    }
    
    
    func getDataFromAPI() {
        let domain = "http://api.openweathermap.org"
        let endPoint = "/geo/1.0/direct"
        let urlString = String(format: "%@%@", domain,endPoint)
        let url = URL(string: urlString)!
        
        let parameters : Parameters = [
            "q" : "Hanoi",
            "limit" : "1",
            "appid" : "f9a4df7c6f38b1adda679903647c31a3"
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters).response { response in
            let result = response.result
            DispatchQueue.main.async {
                switch result {
                case .success(let data) :
                    guard let data = data else {
                        return
                    }
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]] else {
                            return
                        }
                        //                                                print(json)
                        let place: [LatLonPlace] = Mapper<LatLonPlace>().mapArray(JSONObject: json)!
                        
                        self.places = place.first(where: { $0.country == "VN"})!
                        if let unwrapPlaces = self.places {
                            if let lon = unwrapPlaces.lon , let lat = unwrapPlaces.lat {
                                self.getCurrentWeather(lat: lat, lon: lon)
                                self.get5DayAnd3Hour(lat: lat, lon: lon)
                            }
                        }
                        
                    } catch _ {
                        print("Error")
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            
            
        }
        
    }
    func getCurrentWeather(lat: Double , lon: Double) {
        let domain = "http://api.openweathermap.org"
        let endPoint = "/data/2.5/weather"
        let urlString = String(format: "%@%@", domain,endPoint)
        let url = URL(string: urlString)!
        
        let parameters : Parameters = [
            "lat" : lat,
            "lon" : lon,
            "appid" : "f9a4df7c6f38b1adda679903647c31a3",
            "cnt" : "1",
            "units": "metric"
        ]
        AF.request(url,
                   method: .get,
                   parameters: parameters).response { response in
            let result = response.result
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print("Call Data Succes")
                    guard let data = data else {
                        return
                    }
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            return
                        }
                        //                        print(json)
                        
                        self.currentWeather = CurrentWeather(JSON: json)
                        
                        self.myTableView.reloadData()
                    } catch _ {
                        print("Error")
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        
        
    }
    func get5DayAnd3Hour(lat: Double, lon: Double) {
        let domain = "http://api.openweathermap.org"
        let endPoint = "/data/2.5/forecast"
        let urlString = String(format: "%@%@", domain,endPoint)
        let url = URL(string: urlString)!
        
        let parameters : Parameters = [
            "lat" : lat,
            "lon" : lon,
            "appid" : "f9a4df7c6f38b1adda679903647c31a3",
            "cnt" : "10",
            "units": "metric"
        ]
        AF.request(url,
                   method: .get,
                   parameters: parameters).response { response in
            let result = response.result
            
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print("Call Data Succes")
                    guard let data = data else {
                        return
                    }
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            return
                        }
                        
                        //                        print(json)
                        
                        let forecastDay1 = ForecastDays(JSON: json)
                        self.currentDayForecast = forecastDay1?.list
                        self.forecastDay = (forecastDay1!.list)!
                        self.myTableView.reloadData()
                        
                        
                        
                    } catch _ {
                        print("Error")
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
            
        }.resume()
        
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
extension ViewController: UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .HourlyWeatherday ,.CurrentWeather :
            return 1
        case .ForecastDay :
            return forecastDay?.count ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section1 = sections[indexPath.section]
        switch section1 {
            
        case .CurrentWeather :
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherTableViewCell", for: indexPath) as! CurrentWeatherTableViewCell
            
            
            if let data = self.currentWeather {
                cell.configuration(model: data)
                if let icon = data.weather?.first?.icon  {
                    loadImageFromInternet(icon: "https://openweathermap.org/img/wn/\(icon)@2x.png") { image in
                        cell.conditionWeatherImage.image  = image
                    }
                    
                }
            }
            return cell
        case .HourlyWeatherday:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyWeatherTableViewCell", for: indexPath) as! HourlyWeatherTableViewCell
            if let hourlyForecast = currentDayForecast {
                cell.bindData(hourlyForecast: hourlyForecast)
            }
            return cell
        case .ForecastDay :
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastDayTableViewCell", for: indexPath) as! ForecastDayTableViewCell
            
            if let data = self.forecastDay {
                cell.configuration(model: data[indexPath.row])
            }
            
            if let icon = self.forecastDay?[indexPath.row].weather?.first?.icon {
                loadImageFromInternet(icon: "https://openweathermap.org/img/wn/\(icon)@2x.png") { image in
                    cell.iconImage.image = image
                }
                
            }
            
            
            
           return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section] {
        case.CurrentWeather :
            return 350
        case.HourlyWeatherday :
            return 300
        case.ForecastDay :
            return 40
        }

    }
    
}
