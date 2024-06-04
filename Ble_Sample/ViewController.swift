//
//  ViewController.swift
//  Ble_Sample
//
//  Created by Rishop Babu on 02/06/24.
//

import UIKit
import CoreBluetooth

/// Main View Controller - ViewController
class ViewController: UIViewController {
    
    // MARK: - Properties

    private var centralManager: CBCentralManager!
    private var tableView: UITableView!
    private var bluetoothDevices: [CBPeripheral] = []
    private var selectedPeripheral: CBPeripheral?
    
    // MARK: - View Did Load
    /// Called after the controller's view is loaded into memory. Initializes the central manager and sets up the table view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "BLE Devices"
        navigationItem.backButtonTitle = "back"
        
        /// Initialize the central manager
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        /// Create the table view
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        /// Set up constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
/// Extension ViewController - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Returns the number of rows (Bluetooth devices) in the specified section.
    /// - Parameters:
    ///   - tableView: The table view requesting the information.
    ///   - section: The index number of the section.
    /// - Returns: The number of rows in the section.v
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothDevices.count
    }
    
    /// Provides a cell object for the specified row in the table view.
    /// - Parameters:
    ///   - tableView: The table view requesting the cell.
    ///   - indexPath: The index path locating the row in the table view.
    /// - Returns: An object representing a cell of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "BluetoothCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "BluetoothCell")
        }
        
        let peripheral = bluetoothDevices[indexPath.row]
        
        if let name = peripheral.name {
            cell?.textLabel?.text = name
        } else {
            cell?.textLabel?.text = "Unknown Device"
        }
        
        cell?.detailTextLabel?.text = peripheral.identifier.uuidString
        
        return cell!
    }
    
    /// Tells the delegate that the specified row is now selected and connects to the selected peripheral.
    /// - Parameters:
    ///   - tableView: The table view informing the delegate about the new row selection.
    ///   - indexPath: The index path locating the selected row in the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        centralManager.stopScan()
        selectedPeripheral = bluetoothDevices[indexPath.row]
        centralManager.connect(selectedPeripheral!, options: nil)
    }
}

// MARK: - CBCentralManagerDelegate, CBPeripheralDelegate
/// Extension ViewController - CBCentralManagerDelegate, CBPeripheralDelegate
extension ViewController: CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // MARK: - CBCentralManagerDelegate
    
    /// Called whenever the central manager's state is updated. Starts scanning for peripherals if Bluetooth is powered on.
    /// - Parameter central: The central manager whose state has changed.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            // Handle Bluetooth not available or powered off
            print("Bluetooth is not available or powered off.")
        }
    }
    
    /// Called when a peripheral is discovered during scanning.
    /// - Parameters:
    ///   - central: The central manager providing this information.
    ///   - peripheral: The peripheral that was discovered.
    ///   - advertisementData: A dictionary containing any advertisement data.
    ///   - RSSI: The signal strength of the discovered peripheral, in decibels.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !bluetoothDevices.contains(peripheral) {
            bluetoothDevices.append(peripheral)
            tableView.reloadData()
        }
    }
    
    /// Called when a connection is successfully made to a peripheral. Sets the peripheral's delegate and discovers its services.
    /// - Parameters:
    ///   - central: The central manager providing this information.
    ///   - peripheral: The peripheral that was connected.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        let servicesViewController = ServicesViewController()
        servicesViewController.peripheral = peripheral
        navigationController?.pushViewController(servicesViewController, animated: true)
    }
    
    /// Tells the delegate that the peripheral has discovered the services it supports.
    /// - Parameters:
    ///   - peripheral: The peripheral providing this information.
    ///   - error: If an error occurred, the cause of the failure.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                print("Service UUID: \(service.uuid.uuidString)")
            }
        }
    }
}
