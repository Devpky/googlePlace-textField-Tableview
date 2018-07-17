//
//  ViewController.swift
//  googlePlace
//
//  Created by Pawan Yadav on 16/07/18.
//  Copyright © 2018 invetech. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var tableData = [GMSAutocompletePrediction]()
    
    
    
    var fetcher: GMSAutocompleteFetcher?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.edgesForExtendedLayout = []
        
        let nsBoundsCorner = CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)
        
        let bounds = GMSCoordinateBounds(coordinate: nsBoundsCorner, coordinate: nsBoundsCorner)
        
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        fetcher  = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
        
        txtField?.addTarget(self, action: #selector(textFieldDidChange(textField:)),for: .editingChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(textField: UITextField)
    {
        fetcher?.sourceTextHasChanged(txtField.text!)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return tableData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var section = indexPath.section
        var row = indexPath.row
        
        let cell1 : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell1")
        
        cell1.selectionStyle = UITableViewCellSelectionStyle.none
        cell1.backgroundColor = UIColor.clear
        cell1.contentView.backgroundColor = UIColor.clear
        cell1.textLabel?.textAlignment = NSTextAlignment.left
        cell1.textLabel?.textColor = UIColor.black
        cell1.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        cell1.textLabel?.text = tableData[indexPath.row].attributedFullText.string
        return cell1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        txtField.text = tableData[indexPath.row].attributedFullText.string
        getLatLongFromAutocompletePrediction(prediction:tableData[indexPath.row])
    }
    
    func getLatLongFromAutocompletePrediction(prediction:GMSAutocompletePrediction){
        
        let placeClient = GMSPlacesClient()
        
        placeClient.lookUpPlaceID(prediction.placeID!) { (place, error) -> Void in
            if let error = error {
                //show error
                return
            }
            
            if let place = place {
                place.coordinate.longitude //longitude
                place.coordinate.latitude //latitude
            } else {
                //show error
            }
        }
    }
}

extension ViewController: GMSAutocompleteFetcherDelegate {
    
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        tableData.removeAll()
        
        for prediction in predictions{
            
            tableData.append(prediction)
            
        }
        tableView.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print(error.localizedDescription)
    }
}
