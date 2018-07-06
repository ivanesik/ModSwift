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
/////////////////////////TODO: crc моды//////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////TODO: написать тесты правильности пакетов//////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




/// Class for generating modbus packages
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
    init(mode: ModbusMode = .tcp, slaveAdress: UInt8 = 0x00) {
        _mode = mode
        _slaveAdress = slaveAdress
    }
    
    /// Set modbus device adress.
    ///
    /// - parameters:
    ///     - device: Modbus device 16-bit adress.
    func setSlave(slaveAdress: UInt8 = 0x00) {
        _slaveAdress = slaveAdress
    }
    
    /// Set modbus device mode. (.tcp/.rtu/.ascii)
    func setMode(_ mode: ModbusMode) {
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
    
    func getSlave() -> UInt8 {
        return _slaveAdress
    }
    
    func getMode() -> ModbusMode {
        return _mode
    }
    
    func getTransactionId() -> UInt16 {
        return _transactId
    }
    
    func getProtocolId() -> UInt16 {
        return _protocolId
    }
    
//***************************************************************************************************************
//-Create-Package------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    /// Universal method generate request package
    ///
    /// Fuctions 15, 16 need have num of elements and num of bytes
    /// - parameters:
    ///     - command: Modbus function.
    ///     - address: Data 16 bit address.
    ///     - data: For 1-4 commands number of readen elements, (5,6,15,16) data to write.
    func createCommand(command: Command, address: UInt16, data: [UInt8]) -> Data {
        var package = [UInt8]()
        
        // mbap in tcp mode
        if _mode == ModbusMode.tcp {
            let lenght = 4 + data.count
            package.append(contentsOf: [UInt8(_transactId >> 8), UInt8(_transactId & 0xFF)])
            package.append(contentsOf: [UInt8(_protocolId >> 8), UInt8(_protocolId & 0xFF)])
            package.append(contentsOf: [UInt8(lenght >> 8), UInt8(lenght & 0xFF)])
            _transactId += 1
        }
        package.append(_slaveAdress)
        package.append(command.rawValue)
        package.append(contentsOf: [UInt8(address >> 8), UInt8(address & 0xFF)])
        package.append(contentsOf: data)
        
        let data = Data(package)
        return data
    }
    
    /// Returns package of readCoilsStatuses function (0x01)
    func readCoilStatus(startAddress: UInt16, numOfCoils: UInt16) -> Data {
        return createCommand(command: .readCoilStatus, address: startAddress, data: [UInt8(numOfCoils >> 8), UInt8(numOfCoils & 0xFF)])
    }
    
    /// Returns package for readDiscreteInputs function (0x02)
    func readDiscreteInputs(startAddress: UInt16, numOfInputs: UInt16) -> Data {
        return createCommand(command: .readDiscreteInputs, address: startAddress, data: [UInt8(numOfInputs >> 8), UInt8(numOfInputs & 0xFF)])
    }
    
    /// Returns package for readHoldingRegisters function (0x03)
    func readHoldingRegisters(startAddress: UInt16, numOfRegs: UInt16) -> Data {
        return createCommand(command: .readHoldingRegisters, address: startAddress, data: [UInt8(numOfRegs >> 8), UInt8(numOfRegs & 0xFF)])
    }
    
    /// Returns package for readInputRegisters function (0x04)
    func readInputRegisters(startAddress: UInt16, numOfRegs: UInt16) -> Data {
        return createCommand(command: .readInputRegisters, address: startAddress, data: [UInt8(numOfRegs >> 8), UInt8(numOfRegs & 0xFF)])
    }
    
    /// Returns package for force (write) single coil function (0x05)
    func forceSingleCoil(startAddress: UInt16, value: Bool) -> Data {
        return createCommand(command: .forceSingleCoil, address: startAddress, data: [(value ? 0xFF : 0x00) , 0x00])
    }
    
    /// Returns package for preset (write) single register function (0x06)
    func presetSingleRegister(startAddress: UInt16, value: UInt16) -> Data {
        return createCommand(command: .presetSingleRegister, address: startAddress, data: [UInt8(value >> 8) , UInt8(value & 0xFF)])
    }
    
    /// Returns package for force (write) multiple coils function (0x0F)
    func forceMultipleCoils(startAddress: UInt16, values: [Bool]) -> Data {
        var data = [UInt8]()
        data.append(contentsOf: [UInt8(values.count >> 8), UInt8(values.count >> 8)])
        data.append(UInt8(values.count / 8))
        let bytesCount = Int(ceil(Double(values.count / 8)))
        for i in 0...bytesCount {
            var byte: UInt8 = 0
            for y in 0...8 {
                byte = byte << 1
                byte += values[(i * 8) + y] ? 1 : 0
            }
            data.append(byte)
        }

        return createCommand(command: .forceMultipleCoils, address: startAddress, data: data)
    }
    
    /// Returns package for preset (write) multiple registers function (0x10)
    func presetMultipleRegisters(startAddress: UInt16, values: [UInt16]) -> Data {
        var data = [UInt8]()
        for value in values {
            data.append(contentsOf: [UInt8(value >> 8), UInt8(value & 0xFF)])
        }
        return createCommand(command: .presetMultipleRegisters, address: startAddress, data: data)
    }
    
    
    
    
//***************************************************************************************************************
//-Help----------------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    private func addCrc(_ arr: inout [UInt8]) {
    }
    
}
