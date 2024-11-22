//
//  SearchLocationDataSource.swift
//  SwiftWeather
//
//  Created by Jagjeetsingh Labana on 18/11/2024.
//  Copyright © 2024 Jake Lin. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData
class SearchLocationDataSource : NSObject {
    //MARK:- VARIABLES
    private let tableView: UITableView
    private let textField: UITextField
    private let viewModel: SearchLocationViewModel
    private let viewController: SearchLocationViewController
    
    
    //MARK: - INIT
    init(tableView: UITableView, textField:UITextField, viewModel: SearchLocationViewModel,viewController:SearchLocationViewController) {
        self.tableView = tableView
        self.textField = textField
        self.viewModel = viewModel
        self.viewController = viewController
        self.tableView.register("LocationTableViewCell")
    }
}

extension SearchLocationDataSource : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.getHeaderCount()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowCount(section)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headerView = UIView(frame: CGRect(x: 20, y: 0, width: tableView.frame.width - 40 , height: 40))
        headerView.backgroundColor = .clear
        headerView.layer.shadowColor = UIColor.black.cgColor
        headerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        headerView.layer.shadowRadius = 2
        headerView.layer.shadowOpacity = 0.7
        let label = UILabel(frame: headerView.frame)
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        if section == 0 && viewModel.getResultCount() > 0 {
            label.text = "Searched Result"
        } else {
            label.text = "Saved Places"
        }
        label.textColor = .white
        headerView.addSubview(label)
        return viewModel.getHeaderCount() > 0 ? headerView : nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.getHeaderCount() > 0 ? 40 : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as? LocationTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.buttonFavourite.tag = (indexPath.section*1000)+indexPath.row
        cell.buttonFavourite.addTarget(self, action: #selector(actionFavourite(_ :)), for: .touchUpInside)
        if indexPath.section == 0 && viewModel.getResultCount() > 0 {
            let mapItem = viewModel.getResult(at: indexPath.row)
            let city = mapItem.placemark.locality ?? "Unknown City"
            let country = mapItem.placemark.country ?? "Unknown Country"
            cell.buttonFavourite.isSelected = false
            cell.labelLocationName?.text = "\(city), \(country)"
        } else {
            cell.buttonFavourite.isSelected = true
            if let savedLocation = viewModel.getSavedPlace(at: indexPath.row) {
                cell.labelLocationName?.text = savedLocation.location_name
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && viewModel.getResultCount() > 0 {
            let mapItem = viewModel.getResult(at: indexPath.row)
            let city = mapItem.placemark.locality ?? "Unknown City"
            let country = mapItem.placemark.country ?? "Unknown Country"
            let latitude = mapItem.placemark.coordinate.latitude
            let longitude = mapItem.placemark.coordinate.longitude
            
            print("Searched Location:")
            print("Name: \(city), \(country)")
            print("Latitude: \(latitude)")
            print("Longitude: \(longitude)")
            
            //    let locationInfo = "Name: \(city), \(country)\nLatitude: \(latitude)\nLongitude: \(longitude)"
            let selectedLocation = CLLocation(latitude: latitude, longitude: longitude)
            viewController.popVCWithSelection(selectedLocation)
        } else {
            if let savedLocation = viewModel.getSavedPlace(at: indexPath.row) {
                if let latitude = CLLocationDegrees(savedLocation.latitude ?? ""), let longitude = CLLocationDegrees(savedLocation.longitude ?? "") {
                    let selectedLocation = CLLocation(latitude: latitude, longitude: longitude)
                    print("Saved Location:")
                    print("Name: \(savedLocation.location_name ?? "")")
                    print("Latitude: \(latitude)")
                    print("Longitude: \(longitude)")
                    viewController.popVCWithSelection(selectedLocation)
                }
            }
        }
        
    }
    @objc func actionFavourite(_ sender: UIButton){
        let tag = sender.tag
        let row = tag % 1000
        let section = tag / 1000
        let placeName = sender.accessibilityHint ?? ""
        if viewModel.getResultCount() > 0 && section == 0{
            // Add as Favourite & Save
            let mapItem = viewModel.getResult(at: row)
            let city = mapItem.placemark.locality ?? "Unknown City"
            let country = mapItem.placemark.country ?? "Unknown Country"
            let latitude = mapItem.placemark.coordinate.latitude
            let longitude = mapItem.placemark.coordinate.longitude
            viewModel.saveObject(name: "\(city), \(country)", latitude: "\(latitude)", longitude: "\(longitude)")
            self.textField.text = ""
            self.viewModel.removeAllSearchResult()
            self.tableView.reloadData()
        } else {
            //Remove from saved
            viewModel.removeSavedPlace(at: row)
            self.tableView.reloadData()
        }
    }
}

extension SearchLocationDataSource: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
