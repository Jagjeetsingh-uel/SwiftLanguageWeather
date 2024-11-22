//
//  SearchLocationViewController.swift
//  SwiftWeather
//
//  Created by Jagjeetsingh Labana on 18/11/2024.
//  Copyright © 2024 Jake Lin. All rights reserved.
//

import UIKit
import CoreLocation
class SearchLocationViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchViewLeftConstraint: NSLayoutConstraint! //20 - 60
    
    @IBOutlet weak var viewSearchView: UIView!
    
    
    var dataSource: SearchLocationDataSource?
    var viewModel = SearchLocationViewModel()
    var completion : (CLLocation) -> () = {_ in}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = SearchLocationDataSource(tableView: tableView, textField: textField, viewModel: viewModel, viewController: self)
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        textField.delegate = dataSource
        self.textField.becomeFirstResponder()
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchViewLeftConstraint.constant = 60
        UIView.animate(withDuration: 0.5) {
            self.viewSearchView.layoutIfNeeded()
        }
    }
    @objc private func textFieldDidChange(_ textField: UITextField) {
            guard let query = textField.text, !query.isEmpty else {
                viewModel.removeAllSearchResult()
                tableView.reloadData()
                self.textField.text = ""
                self.clearButton.isHidden = true
                return
            }
        self.clearButton.isHidden = false
        viewModel.searchForCity(query: query) { isReloadData in
            if isReloadData {
                self.tableView.reloadData()
            }
        }
    }
    func manageSelection(completion : @escaping (CLLocation) -> ()) {
        self.completion = completion
    }
    func popVCWithSelection(_ selection: CLLocation) {
        searchViewLeftConstraint.constant = 20
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.navigationController?.popViewController(animated: false)
            self.completion(selection)
        }
    }
    //MARK: - IBAction
    @IBAction func actionClearSearch(_ sender: Any) {
        self.textField.text = ""
        self.viewModel.removeAllSearchResult()
        self.tableView.reloadData()
    }
    @IBAction func actionBack(_ sender: Any) {
        searchViewLeftConstraint.constant = 20
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.navigationController?.popViewController(animated: false)
        }
    }
    
}
