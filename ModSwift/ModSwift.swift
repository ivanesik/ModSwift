//
//  ModSwift.swift
//  ModSwift
//
//  Created by Admin on 02.07.2018.
//  Copyright © 2018 Ivan Elyoskin. All rights reserved.
//

import Foundation

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////TODO: в документации не забыть описать автоинкремент//////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////TODO: в документации написать что это мастер//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////TODO: в документации описать что есть MBAP картинкой (http://cleverhouse.club/software/dispatch/chto-takoe-modbus-rtu-i-modbus-tcp.html)//////////////
/////////////////////////TODO: написать тесты//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





class  ModSwift {
    
    private var _mode: ModbusMode
    private var _slaveAdress: UInt8
    
    /// Just for .tcp mode
    private var _transactId: UInt16 = 0x00
    /// Just for .tcp mode
    private var _protocolId: UInt16 = 0x00
    
//***************************************************************************************************************
//-Setup---------------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    
    /// Set modbus device adress.
    /// - parameters:
    ///     - mode: Modbus mode (default tcp)
    ///     - device: Modbus device 16-bit adress (default 0x00)
    init(mode: ModbusMode = .tcp, device: UInt8 = 0x00) {
        _mode = mode
        _slaveAdress = device
    }
    
    /// Set modbus device adress.
    ///
    /// - parameters:
    ///     - device: Modbus device 16-bit adress.
    func setDevice(device: UInt8 = 0x00) {
        _slaveAdress = device
    }
    
    /// Set modbus device mode.
    /// - parameters:
    ///     - mode: Modbus mode (.tcp/.rtu/.ascii).
    func setMode(mode: ModbusMode) {
        _mode = mode
    }
    
    /// Set transactint id of package.
    func setTransactionId(_ transactId: UInt16) {
        _transactId = transactId
    }
    
    /// Set protocol Id (default 0x00)
    func setProtocolId(_ protocolId: UInt16) {
        _protocolId = protocolId
    }
    
//***************************************************************************************************************
//-Read-Package--------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    func readRequest(data: Data) -> [UInt8] {
        let arr = [UInt8](data)
        return arr
    }
    
//***************************************************************************************************************
//-Create-Package------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    func createCommand(command: Command, address: UInt16, data: [UInt16]) -> Data {
        var package = [UInt8]()
        
        if _mode == ModbusMode.tcp {
            addMBAP(package)
            _transactId += 1
        }
        
        package.append(_slaveAdress)
        package.append(command.rawValue)
        
        switch command {
            case .readCoilStatus:
                break
            case .readDiscreteInputs:
                break
            case .readHoldingRegisters:
                package.append(contentsOf: [UInt8(address >> 8), UInt8(address & 0xFF)])
                break
            case .readInputRegisters:
                break
            case .forceSingleCoil:
                break
            case .forceMultipleCoils:
                break
            case .presetSingleRegister:
                break
            case .presetMultipleRegisters:
                break
        }
        
        let data = Data(package)
        return data
    }
    
    
    func readCoidStatus(address: UInt32) -> Data {
        let data = Data()
        
        _transactId += 1
        return data
    }
    
    func readDiscreteInputs(/*parameters*/) -> Data {
        let data = Data()
        
        _transactId += 1
        return data
    }
    
    func readHoldingRegisters(/*parameters*/) -> Data {
        let data = Data()
        
        _transactId += 1
        return data
    }
    
    func readInputRegisters(/*parameters*/) -> Data {
        let data = Data()
        
        _transactId += 1
        return data
    }
    
    func forceSingleCoil(/*parameters*/) -> Data {
        let data = Data()
        
        _transactId += 1
        return data
    }
    
    func presetSingleRegister(/*parameters*/) -> Data {
        let data = Data()
        
        _transactId += 1
        return data
    }
    
    func forceMultipleCoils(/*parameters*/) -> Data {
        let data = Data()
        
        _transactId += 1
        return data
    }
    
    func presetMultipleRegisters(/*parameters*/) -> Data {
        let data = Data()
        
        _transactId += 1
        return data
    }
    
    
    
    
//***************************************************************************************************************
//-Help----------------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    private func addMBAP(_ arr: [UInt8]) {
        var temp = arr
        temp.append(UInt8(_transactId >> 8))
        temp.append(UInt8(_transactId & 0xFF))
        temp.append(UInt8(_protocolId >> 8))
        temp.append(UInt8(_protocolId & 0xFF))
    }
    
    
}
