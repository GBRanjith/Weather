//
//  NextViewController.swift
//  Weather (BitCot)
//
//  Created by Ranjith on 08/04/23.
//

import UIKit
import CoreLocation
class nextSevendayViewController: UIViewController
{
    var listvalues:[List] = []
    var city: String?
    var contry: String?
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblnextsevendays:UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    func setupUI()
    {
        lblnextsevendays.text = "Next 7 Days"      
        let attributedText = NSMutableAttributedString(string: city ?? "", attributes: [.font: UIFont.boldSystemFont(ofSize: 18), .foregroundColor: UIColor.white])
        if let city = city, let country = contry {
            let boldFont = UIFont.boldSystemFont(ofSize: 18)
            let regularFont = UIFont.systemFont(ofSize: 18)
            let attributedText = NSMutableAttributedString(string: city, attributes: [.font: boldFont, .foregroundColor: UIColor.white])
            
            let countryAttributedText = NSAttributedString(string: ", \(country)", attributes: [.font: regularFont, .foregroundColor: UIColor.lightText])
            attributedText.append(countryAttributedText)
            
            navigationItem.title = nil // Set navigation item title to nil to use the attributed title
            navigationItem.titleView = UILabel() // Create a new label for the attributed title
            (navigationItem.titleView as? UILabel)?.attributedText = attributedText // Set the attributed title to the label
        }

    }
    
}
extension nextSevendayViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NextsevendayCell", for: indexPath) as! NextsevendayCell
        let data = listvalues.first?.daily?[indexPath.row + 1]
        cell.lbldate.attributedText = weatherdateformatatt(timestamps: data?.dt ?? 0)
        cell.imgcloudicon.image = getImage(forKey: data?.weather?.first?.description ?? "")
        let degree = "\(data?.temp?.max?.kelvinToCelsius() ?? 0)".withDegreeSymbol()
        let text = "\(data?.temp?.min?.kelvinToCelsius() ?? 0) / \(degree)"
        let attributedText = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: degree)
        attributedText.addAttribute(.foregroundColor, value: UIColor.lightText, range: range)
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: range)

        cell.lbldegreests.attributedText = attributedText

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }    
    
}

