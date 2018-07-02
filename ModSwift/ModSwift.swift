//
//  ModSwift.swift
//  ModSwift
//
//  Created by Admin on 02.07.2018.
//  Copyright © 2018 Ivan Elyoskin. All rights reserved.
//

import Foundation


class  ModSwift {
    
    private var _mode: ModbusMode
    private var _devAdress: UInt16
    
//***************************************************************************************************************
//-Setup---------------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    
    init(mode: ModbusMode = .tcp, device: UInt16 = 0x00) {
        _mode = mode
        _devAdress = device
    }
    
    /// Set modbus device adress.
    ///
    /// - parameters:
    ///     - device: Modbus device 16-bit adress.
    func setDevice(device: UInt16 = 0x00) {
        _devAdress = device
    }
    
    func setMode(mode: ModbusMode) {
        _mode = mode
    }
    
    /// Set modbus device adress.
    ///
    /// - parameters:
    ///     - device: Modbus device 16-bit adress.
    func createCommand(command: Command, data: [UInt16]) -> Data {
        let data = Data()
        return data
    }
    
    
//***************************************************************************************************************
//-Read-Package--------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    func readRequest() {
    }
    
//***************************************************************************************************************
//-Create-Package------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    func readCoidStatus(adress: UInt32) -> Data {
        let data = Data()
        return data
    }
    
    func readDiscreteInputs(/*parameters*/) -> Data {
        let data = Data()
        return data
    }
    
    func readHoldingRegisters(/*parameters*/) -> Data {
        let data = Data()
        return data
    }
    
    func readInputRegisters(/*parameters*/) -> Data {
        let data = Data()
        return data
    }
    
    func forceSingleCoil(/*parameters*/) -> Data {
        let data = Data()
        return data
    }
    
    func presetSingleRegister(/*parameters*/) -> Data {
        let data = Data()
        return data
    }
    
    func forceMultipleCoils(/*parameters*/) -> Data {
        let data = Data()
        return data
    }
    
    func presetMultipleRegisters(/*parameters*/) -> Data {
        let data = Data()
        return data
    }
    
}
