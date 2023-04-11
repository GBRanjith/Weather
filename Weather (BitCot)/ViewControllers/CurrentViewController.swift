//
//  ViewController.swift
//  Weather (BitCot)
//
//  Created by Ranjith on 08/04/23.
//

import UIKit
import CoreLocation
class CurrentViewController: UIViewController, CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var temperature: Int = 0
    var currentweather = [CurrentWeather]()
    var listdata = [List]()
    let locationManager = CLLocationManager()
    var currentlocation: CLLocation?
    let regularFont = UIFont.systemFont(ofSize: 16)
    let unitFont = UIFont.systemFont(ofSize: 12)
    
    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var lblCityAndState: UILabel!
    @IBOutlet weak var DetailsContentView: UIView!
    @IBOutlet weak var imgcurrentsts: UIImageView!
    @IBOutlet weak var lblCurrentClimatests: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lbldegree: UILabel!
    @IBOutlet weak var bottemContentView: UIView!
    
    @IBOutlet weak var imgwindicon: UIImageView!
    @IBOutlet weak var lblwindtitle: UILabel!
    @IBOutlet weak var lblwindvalue: UILabel!
    
    @IBOutlet weak var imgfeelslike: UIImageView!
    @IBOutlet weak var lblfeelsliketitle: UILabel!
    @IBOutlet weak var lblfeelslikevalue: UILabel!
    
    @IBOutlet weak var imgindexUV: UIImageView!
    @IBOutlet weak var lblindexUVtitle: UILabel!
    @IBOutlet weak var lblindexUVvalue: UILabel!
    
    @IBOutlet weak var imgpressureicon: UIImageView!
    @IBOutlet weak var lblpressuretitle: UILabel!
    @IBOutlet weak var lblpressurevalue: UILabel!
    
    
    @IBOutlet weak var lbltoday: UILabel!
    @IBOutlet weak var lblnextsevendays: UILabel!
    @IBOutlet weak var btnrightaeroicon: UIImageView!
    
      override func viewDidLoad() {
          super.viewDidLoad()
          setupLocation()
          setupUI()
      }
      
      override func viewDidAppear(_ animated: Bool) {
          navigationController?.navigationBar.tintColor = UIColor.black
         
         
      }
      
  
    func setupUI() {
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(optionsButtonAction))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(sideMenuButtonAction))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.backButtonTitle = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblnextsevendays.isUserInteractionEnabled = true
        lblnextsevendays.addGestureRecognizer(tapGesture)
//        btnrightaeroicon.addGestureRecognizer(tapGesture)
        imgwindicon.image = UIImage(named: "wind")
        imgfeelslike.image = UIImage(named: "thermometer")
        imgindexUV.image = UIImage(named: "sunicon")
        imgpressureicon.image = UIImage(named: "pressure")
        lbltoday.text = "Today"
        lblwindtitle.text = "WIND"
        lblfeelsliketitle.text = "FEELS LIKE"
        lblpressuretitle.text = "PRESSURE"
        lblindexUVtitle.text = "INDEX UV"
        imgcurrentsts.image = UIImage(named: currentweather.first?.weather?.first?.icon ?? "")
        if let cityName = currentweather.first?.name, let countryName = currentweather.first?.sys?.country {
            let boldFont = UIFont.boldSystemFont(ofSize: lblCityAndState.font.pointSize)
            let attributedText = NSMutableAttributedString(string: cityName, attributes: [.font: boldFont, .foregroundColor: UIColor.black])
            attributedText.append(NSAttributedString(string: ", \(countryName)", attributes: [.font: UIFont.systemFont(ofSize: lblCityAndState.font.pointSize - 2), .foregroundColor: UIColor.darkGray]))
            lblCityAndState.attributedText = attributedText
        } else {
            lblCityAndState.text = "Unknown"
        }
        lblwindvalue.text = "\(currentweather.first?.wind?.speed ?? 0)"
        lblfeelslikevalue.text = "\(currentweather.first?.main?.feelsLike?.kelvinToCelsius() ?? 0)".withDegreeSymbol()
        
        let pressureString = NSMutableAttributedString(string: "\(currentweather.first?.main?.pressure ?? 0)", attributes: [NSAttributedString.Key.font: regularFont])
        pressureString.append(NSAttributedString(string: " mbar", attributes: [NSAttributedString.Key.font: unitFont]))
        lblpressurevalue.attributedText = pressureString
        lblCurrentClimatests.text = currentweather.first?.weather?.first?.description ?? ""
        temperature = currentweather.first?.main?.temp?.kelvinToCelsius() ?? 0
        lbldegree.text =  "\(temperature)".withDegreeSymbol()
        lblDate.text = weatherdateformat(timestamps: currentweather.first?.dt ?? 0)
        imgcurrentsts.image = getImage(forKey: currentweather.first?.weather?.first?.description ?? "")
        DetailsContentView.roundCorners(radius: 17)
        lbltoday.text = "Today"
        lblnextsevendays.text = "Next 7 Days"
    }
  
    @objc func optionsButtonAction(){
        // Action for option button in nav bar
    }
    
    @objc func sideMenuButtonAction(){
        // Action for side menu button in nav bar
    }

    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentlocation == nil {
            currentlocation = locations.first
            locationManager.stopUpdatingLocation()
            FetchCurrentAPI()
            FetchNextSevenDayAPI()
        }
    }
    
    func FetchCurrentAPI() {
        guard let currentlocation = currentlocation else {
            return
        }
        let long = currentlocation.coordinate.longitude
        let lat = currentlocation.coordinate.latitude
        let currenturl = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=4cd569ffb3ecc3bffe9c0587ff02109f"

        URLSession.shared.dataTask(with: URL(string: currenturl)!) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Error in Validation")
                return
            }
            // Convert data to models
            do {
                let json = try JSONDecoder().decode(CurrentWeather.self, from: data)
                print(json)
                self.currentweather.append(json)
                DispatchQueue.main.async {
                    self.setupUI()
                    self.collectionview.reloadData()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func FetchNextSevenDayAPI() {
        guard let currentlocation = currentlocation else {
            return
        }

        let long = currentlocation.coordinate.longitude
        let lat = currentlocation.coordinate.latitude
        let currenturl = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&appid=4cd569ffb3ecc3bffe9c0587ff02109f"

        URLSession.shared.dataTask(with: URL(string: currenturl)!) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Error in Validation")
                return
            }
            // Convert data to models
            do {
                let json = try JSONDecoder().decode(List.self, from: data)
                print(json)
                
                self.listdata.append(json)
                DispatchQueue.main.async {
                    self.lblindexUVvalue.text = "\(json.current?.uvi ?? 0)"
                    self.collectionview.reloadData()
                   
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
        @objc func labelTapped() {
            guard let nextSevenDaysVC = storyboard?.instantiateViewController(withIdentifier: "nextSevendayViewController") as? nextSevendayViewController else {
                return
            }
            
            nextSevenDaysVC.listvalues = listdata
            nextSevenDaysVC.city = currentweather.first?.name ?? ""
            nextSevenDaysVC.contry = currentweather.first?.sys?.country ?? ""
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationController?.pushViewController(nextSevenDaysVC, animated: true)
            print("button tapper")
        }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of odd index values in the array
        return max(0, (listdata.first?.hourly?.count ?? 0) / 4 )
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayDetailsCell", for: indexPath) as! todayDetailsCell
        
        // Calculate the index of the odd item to display
        let index = indexPath.row * 2
        if indexPath.row == 0 {
            cell.lbldegree.text = "Now"
            cell.lbldegree.textColor = .white
            cell.lbltime.textColor = .white
            cell.lbltime.attributedText = dateformatforhour(timestamps: listdata.first?.hourly?[0].dt ?? 0)
            cell.imgstsimage.image = getImage(forKey: (listdata.first?.hourly?[0].weather?.first?.description?.rawValue) ?? "")
            cell.contentview.roundCorners(radius: 6)
            cell.contentview.dropShadowToView()
            cell.contentview.backgroundColor = UIColor(red: 67/255, green: 122/255, blue: 255/255, alpha: 1)
        } else {
            let data = listdata.first?.hourly?[index]
            // Display the data in the cell
            cell.lbldegree.text = "\(data?.temp?.kelvinToCelsius() ?? 0)".withDegreeSymbol()
            cell.lbltime.attributedText = dateformatforhour(timestamps: data?.dt ?? 0)
            cell.imgstsimage.image = getImage(forKey: (data?.weather?.first?.description?.rawValue) ?? "")
            cell.contentview.roundCorners(radius: 6)
            cell.contentview.dropShadowToView()
            cell.contentview.backgroundColor = .white
            // Check if this is the last cell and set the text color to black
            if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
                cell.lbldegree.textColor = .black
                cell.lbltime.textColor = .darkGray
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row * 2
        let data = listdata.first?.hourly?[index]
        lblCurrentClimatests.text = data?.weather?.first?.description?.rawValue
        temperature = data?.temp?.kelvinToCelsius() ?? 0
        lbldegree.text =  "\(temperature)".withDegreeSymbol()
        lblDate.text = weatherdateformat(timestamps: data?.dt ?? 0)
        imgcurrentsts.image = getImage(forKey: data?.weather?.first?.description?.rawValue ?? "")
        lblwindvalue.text = "\(data?.windSpeed ?? 0)"
        lblfeelslikevalue.text = "\(data?.feelsLike?.kelvinToCelsius() ?? 0)".withDegreeSymbol()
        lblindexUVvalue.text = "\(data?.uvi ?? 0)"
        let pressureString = NSMutableAttributedString(string: "\(data?.pressure ?? 0)", attributes: [NSAttributedString.Key.font: regularFont])
        pressureString.append(NSAttributedString(string: " mbar", attributes: [NSAttributedString.Key.font: unitFont]))
        lblpressurevalue.attributedText = pressureString
        
        
       
    }

 
}

