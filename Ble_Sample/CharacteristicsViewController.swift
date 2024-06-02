//
//  CharacteristicsViewController.swift
//  Ble_Sample
//
//  Created by Rishop Babu on 02/06/24.
//

import UIKit
import CoreBluetooth

class CharacteristicsViewController: UIViewController {
    
    var service: CBService!
    var peripheral: CBPeripheral!
    var characteristics: [CBCharacteristic] = []
    var tableView: UITableView!
    let bleManager = BLEManager()
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "BLE Characteristics"
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
        peripheral.discoverCharacteristics(nil, for: service)
    }
    
    /// Sends a predefined login successful message to the peripheral.
    func sendLoginSuccessful() {
        let byteArray: [UInt8] = [
            77, 84, 54, 48, 65, 69, 53, 52, 66, 48, 51, 55, 67, 81, 48, 48, 49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 13, 0, 23, 12, 29, 14, 52, 23, 1, 1, 0, 76, 79, 71, 73, 41
        ]
        let data = Data(byteArray)
        bleManager.sendData(data)
        print("Login successful message sent.")
    }
    
    /// Sends a predefined heartbeat message to the peripheral.
    func sendHeartbeat() {
        let byteArray: [UInt8] = [
            77, 84, 54, 48, 65, 69, 53, 52, 66, 48, 51, 55, 67, 81, 48, 48, 49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 13, 0, 23, 12, 29, 14, 52, 23, 1, 1, 0, 76, 79, 71, 73, 41
        ]
        let data = Data(byteArray)
        bleManager.sendData(data)
        print("Heartbeat message sent.")
    }
    
    /// Sends a predefined charger restart message to the peripheral.
    func sendChargerRestart() {
        let byteArray: [UInt8] = [
            77, 84, 54, 48, 65, 69, 53, 52, 66, 48, 51, 55, 67, 81, 48, 48, 49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 22, 2, 0, 82, 83, 23
        ]
        let data = Data(byteArray)
        bleManager.sendData(data)
        print("Charger restart message sent.")
    }
    
    /// Handles the state based on the provided characteristic UUID.
    /// - Parameter state: The UUID of the characteristic that represents the state.
    func handleState(state: CBUUID) {
        let uuidString = state.uuidString
        switch uuidString {
            case "00000001-0000-1000-8000-00805F9B34FB":
                sendLoginSuccessful()
            case "00000005-0000-1000-8000-00805F9B34FB":
                sendHeartbeat()
            case "00000010-0000-1000-8000-00805F9B34FB":
                sendChargerRestart()
            default:
                print("Unknown state: \(uuidString)")
        }
    }
}

extension CharacteristicsViewController: UITableViewDelegate, UITableViewDataSource {
    /// Returns the number of rows (characteristics) in the specified section.
    /// - Parameters:
    ///   - tableView: The table view requesting the information.
    ///   - section: The index number of the section.
    /// - Returns: The number of rows in the section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    /// Provides a cell object for the specified row in the table view.
    /// - Parameters:
    ///   - tableView: The table view requesting the cell.
    ///   - indexPath: The index path locating the row in the table view.
    /// - Returns: An object representing a cell of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicCell") ?? UITableViewCell(style: .default, reuseIdentifier: "CharacteristicCell")
        let characteristic = characteristics[indexPath.row]
        cell.textLabel?.text = characteristic.uuid.uuidString
        return cell
    }
    
    /// Tells the delegate that the specified row is now selected.
    /// - Parameters:
    ///   - tableView: The table view informing the delegate about the new row selection.
    ///   - indexPath: The index path locating the selected row in the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characteristic = characteristics[indexPath.row]
        // Handle characteristic interaction here
        
        // Example of sending data to characteristic
        let dataToSend = Data([0x01, 0x02, 0x03])
        peripheral.writeValue(dataToSend, for: characteristic, type: .withResponse)
    }
}

extension CharacteristicsViewController: CBPeripheralDelegate {
    
    /// Tells the delegate that the peripheral has discovered characteristics of a specified service.
    /// - Parameters:
    ///   - peripheral: The peripheral providing this information.
    ///   - service: The service whose characteristics have been discovered.
    ///   - error: If an error occurred, the cause of the failure.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            self.characteristics = characteristics
            tableView.reloadData()
        }
    }
    
    /// Tells the delegate that a specified characteristic's value has been written.
    /// - Parameters:
    ///   - peripheral: The peripheral providing this information.
    ///   - characteristic: The characteristic whose value has been written.
    ///   - error: If an error occurred, the cause of the failure.
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        handleState(state: characteristic.uuid)
        if let error = error {
            print("Error writing value for characteristic \(characteristic.uuid): \(error.localizedDescription)")
            let alert = UIAlertController(title: "Write Error",
                                          message: "Error writing value for characteristic \(characteristic.uuid): \(error.localizedDescription)",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            print("Successfully wrote value for characteristic \(characteristic.uuid)")
            let alert = UIAlertController(title: "Success",
                                          message: "Successfully wrote value for characteristic \(characteristic.uuid)",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
