//
//  ServicesViewController.swift
//  Ble_Sample
//
//  Created by Rishop Babu on 02/06/24.
//

import UIKit
import CoreBluetooth

class ServicesViewController: UIViewController {
    
    var peripheral: CBPeripheral!
    var services: [CBService] = []
    var tableView: UITableView!
    
    /// /// Called after the controller's view is loaded into memory. Sets up the table view and initiates service discovery on the peripheral.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "BLE Services"
        navigationItem.backButtonTitle = "back"
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
}

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
    /// Returns the number of rows (services) in the specified section.
    /// - Parameters:
    ///   - tableView: The table view requesting the information.
    ///   - section: The index number of the section.
    /// - Returns: The number of rows in the section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    /// Provides a cell object for the specified row in the table view.
    /// - Parameters:
    ///   - tableView: The table view requesting the cell.
    ///   - indexPath: The index path locating the row in the table view.
    /// - Returns: An object representing a cell of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") ?? UITableViewCell(style: .default, reuseIdentifier: "ServiceCell")
        let service = services[indexPath.row]
        cell.textLabel?.text = service.uuid.uuidString
        return cell
    }
    
    /// Tells the delegate that the specified row is now selected and navigates to the characteristics view controller.
    /// - Parameters:
    ///   - tableView: The table view informing the delegate about the new row selection.
    ///   - indexPath: The index path locating the selected row in the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service = services[indexPath.row]
        let characteristicsViewController = CharacteristicsViewController()
        characteristicsViewController.service = service
        characteristicsViewController.peripheral = peripheral
        navigationController?.pushViewController(characteristicsViewController, animated: true)
    }
}

extension ServicesViewController: CBPeripheralDelegate {
    
    /// Tells the delegate that the peripheral has discovered the services it supports.
    /// - Parameters:
    ///   - peripheral: The peripheral providing this information.
    ///   - error: If an error occurred, the cause of the failure.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            self.services = services
            tableView.reloadData()
        }
    }
}

