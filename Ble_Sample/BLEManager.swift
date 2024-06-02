//
//  BLEManager.swift
//  Ble_Sample
//
//  Created by Rishop Babu on 02/06/24.
//

import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var connectedPeripheral: CBPeripheral?
    var writeCharacteristic: CBCharacteristic?
    
    /// Initializes a new instance of the BLEManager class.
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /// Called whenever the central manager's state is updated.
    /// - Parameter central: The central manager whose state has changed.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOn:
                // Start scanning for devices
                centralManager.scanForPeripherals(withServices: nil, options: nil)
            default:
                print("Bluetooth is not available.")
        }
    }
    
    /// Called when a peripheral is discovered during scanning.
    /// - Parameters:
    ///   - central: The central manager providing this information.
    ///   - peripheral: The peripheral that was discovered.
    ///   - advertisementData: A dictionary containing any advertisement data.
    ///   - RSSI: The signal strength of the discovered peripheral, in decibels.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        // Stop scanning once we find a peripheral
        centralManager.stopScan()
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    /// Called when a connection is successfully made to a peripheral.
    /// - Parameters:
    ///   - central: The central manager providing this information.
    ///   - peripheral: The peripheral that was connected.
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown Device")")
        peripheral.discoverServices(nil)
    }
    
    /// Called when the peripheral discovers the services it supports.
    /// - Parameters:
    ///   - peripheral: The peripheral providing this information.
    ///   - error: If an error occurred, the cause of the failure.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    /// Called when the peripheral discovers the characteristics of a specified service.
    /// - Parameters:
    ///   - peripheral: The peripheral providing this information.
    ///   - service: The service whose characteristics have been discovered.
    ///   - error: If an error occurred, the cause of the failure.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                // Assuming we write to the first writable characteristic found
                if characteristic.properties.contains(.write) {
                    writeCharacteristic = characteristic
                    break
                }
            }
        }
    }
    
    /// Sends data to the connected peripheral using the writable characteristic.
    /// - Parameter data: The data to be sent to the peripheral.
    func sendData(_ data: Data) {
        if let peripheral = connectedPeripheral, let characteristic = writeCharacteristic {
            peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
    
}
