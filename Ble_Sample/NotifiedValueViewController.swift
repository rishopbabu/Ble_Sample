//
//  NotifiedValueViewController.swift
//  Ble_Sample
//
//  Created by Rishop Babu on 03/06/24.
//

import Foundation
import UIKit

/// NotifiedValueViewController
class NotifiedValueViewController: UIViewController {
    
    // MARK: - Properties
    /// Properties
    var notifiedValue: String!
    var valueLabel: UILabel!
    
    // MARK: - View Did Load
    
    /// Called after the controller's view is loaded into memory. Sets up the table view and initiates service discovery on the peripheral.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.text = notifiedValue
        valueLabel.textAlignment = .center
        view.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        navigationItem.title = "Notified Value"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissView))
    }
    
    /// Dismiss the view
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}

