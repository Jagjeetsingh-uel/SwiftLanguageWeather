//
//  SearchLocationViewModel.swift
//  SwiftWeather
//
//  Created by Jagjeetsingh Labana on 18/11/2024.
//  Copyright © 2024 Jake Lin. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class SearchLocationViewModel {
    private var searchResults: [MKMapItem] = []
    private var coreDataStack = CoreDataStack.shared

}
extension SearchLocationViewModel {
    func getHeaderCount() -> Int {
        var count = 0
        count += getResultCount() > 0 ? 1 : 0
        count += getSavedPlaceCount() > 0 ? 1 : 0
        return count
    }
    func getRowCount(_ section: Int) -> Int {
        var count = 0
        if section == 0 && searchResults.count > 0 {
            count = getResultCount()
        } else {
            count = getSavedPlaceCount()
        }
        return count
    }
    
    func removeAllSearchResult(){
        searchResults.removeAll()
    }
    func getResultCount() -> Int {
        return searchResults.count
    }
    func getResult(at index: Int) -> MKMapItem {
        searchResults[index]
    }
    func searchForCity(query: String,completion : @escaping (Bool) -> ()) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .address
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error searching for city: \(error.localizedDescription)")
                return
            }

            if let response = response {
                // Filter results for city-level matches
                self.searchResults = response.mapItems.filter {
                    $0.placemark.locality != nil
                }
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    
    //MARK: CORE DATA
    func saveObject(name:String,latitude:String,longitude:String) {
        let savedLocation = SavedLocation(context: getContext())
            savedLocation.latitude = latitude
            savedLocation.longitude = longitude
            savedLocation.location_name = name
            saveContext()

    }
    func getSavedPlaceCount() -> Int {
        coreDataStack.getAllSavedLocations()?.count ?? 0
    }
    
    func getSavedPlace(at index: Int) -> SavedLocation? {
        guard let data = coreDataStack.getAllSavedLocations() else {
            return nil
        }
        return data[index]
    }
    func removeSavedPlace(at index: Int){
        if let placeObj = getSavedPlace(at: index) {
            coreDataStack.delete(item: placeObj)
        }
    }
    func getContext() -> NSManagedObjectContext{
        coreDataStack.persistentContainer.viewContext
    }
    
    func saveContext(){
        coreDataStack.save()
    }
}
