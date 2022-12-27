//
//  ModSwift.swift
//
//
//  Created by Ivan Eleskin on 02.07.2018.
//

///--------------------------------------------------------------------------------------------------
/// TODO: в документации не забыть описать автоинкремент
/// TODO: в документации описать что есть MBAP картинкой (http://cleverhouse.club/software/dispatch/chto-takoe-modbus-rtu-i-modbus-tcp.html)//////////////
/// TODO: написать тесты правильности пакетов
///--------------------------------------------------------------------------------------------------

import Foundation
import CrcSwift

/// Class for generating modbus packages
public class ModSwift {
    
    private var mode: ModbusMode
    
    private var slaveAddress: UInt8
    /// Transaction identifier. TCP mode only
    private var transactionId: UInt16 = 0x00
    /// Protocol identifier. TCP mode only
    private var protocolId: UInt16 = 0x00
    /// Type of CRC calculation. RTU mode only
    private var crcMode: CRC16_TYPE = .modbus
    
    private var enableTransctionAutoIncrement: Bool
    
    //--------------------------------------------------------------------------------------------------
    // Setup
    //--------------------------------------------------------------------------------------------------
    
    /// Class for generating modbus packages
    /// - parameters:
    ///   - mode: Modbus mode (default tcp)
    ///   - slaveAddress: Modbus device 16-bit address (default 0x00)
    public init(
        mode: ModbusMode = .tcp,
        slaveAddress: UInt8 = 0x00,
        enableTransctionAutoIncrement: Bool = false
    ) {
        self.mode = mode
        self.slaveAddress = slaveAddress
        self.enableTransctionAutoIncrement = enableTransctionAutoIncrement
    }

    /// Set modbus device address.
    ///
    /// - parameters:
    ///   - slaveAddress: Modbus device's 16-bit address.
    public func setSlave(slaveAddress: UInt8 = 0x00) {
        self.slaveAddress = slaveAddress
    }
    
    /// Set modbus device mode. (.tcp/.rtu/.ascii)
    public func setMode(_ mode: ModbusMode) {
        self.mode = mode
    }
    
    /// Set transactint id of package.
    public func setTransactionId(_ transactId: UInt16) {
        self.transactionId = transactId
    }
    
    /// Set protocol Id (default 0x00)
    public func setProtocolId(_ protocolId: UInt16) {
        self.protocolId = protocolId
    }
    
    public func setTransctionAutoIncrement(_ transctionAutoIncrement: Bool) {
        self.enableTransctionAutoIncrement = transctionAutoIncrement
    }
    
    //--------------------------------------------------------------------------------------------------
    // Read Package
    //--------------------------------------------------------------------------------------------------
    
    public func getSlave() -> UInt8 {
        return slaveAddress
    }
    
    public func getMode() -> ModbusMode {
        return mode
    }
    
    public func getTransactionId() -> UInt16 {
        return transactionId
    }
    
    public func getProtocolId() -> UInt16 {
        return protocolId
    }

    //--------------------------------------------------------------------------------------------------
    // Create Package
    //--------------------------------------------------------------------------------------------------
    
    static private func buildPDU(
        command: Command,
        address: UInt16,
        data: [UInt8] = []
    ) -> [UInt8] {
        return [command.rawValue] +
            DataHelper.splitIntIntoTwoBytes(address) +
            data
    }
    
    static private func buildPDU(command: Command) -> [UInt8] {
        return [command.rawValue]
    }
    
    private func buildTcpADU(pdu: [UInt8]) -> [UInt8] {
        let slaveAddressWithPdu: [UInt8] = [slaveAddress] + pdu
        let result: [UInt8] = DataHelper.splitIntIntoTwoBytes(transactionId)
            + DataHelper.splitIntIntoTwoBytes(protocolId)
            + DataHelper.splitIntIntoTwoBytes(slaveAddressWithPdu.count)
            + slaveAddressWithPdu
            
        if enableTransctionAutoIncrement == true {
            transactionId += 1
        }
        
        return result
    }
    
    private func buildRtuADU(pdu: [UInt8]) -> [UInt8] {
        let slaveAddressWithPdu: [UInt8] = [slaveAddress] + pdu
        let crc = CrcSwift.computeCrc16(slaveAddressWithPdu, mode: crcMode)

        return slaveAddressWithPdu + DataHelper.splitIntIntoTwoBytes(crc)
    }
    

    /// Universal method generate request package
    ///
    /// Fuctions 15, 16 need have num of elements and num of bytes
    /// - parameters:
    ///     - command: Modbus function.
    ///     - address: Data 16 bit address.
    ///     - data: For 1-4 commands number of readen elements, (5,6,15,16) data to write.
    private func createCommand(
        command: Command,
        address: UInt16,
        data: [UInt8] = []
    ) -> Data {
        var package = [UInt8]()
        let pdu: [UInt8] = ModSwift.buildPDU(
            command: command,
            address: address,
            data: data
        )
        
        switch mode {
            case .tcp:
                package = buildTcpADU(pdu: pdu)
            case .rtu:
                package = buildRtuADU(pdu: pdu)
        }
        
        return Data(package)
    }
    
    /// Returns package of readCoilsStatuses function (0x01)
    func readCoilStatus(startAddress: UInt16, numOfCoils: UInt16) -> Data {
        return createCommand(
            command: .readCoilStatus,
            address: startAddress,
            data: DataHelper.splitIntIntoTwoBytes(numOfCoils)
        )
    }
    
    /// Returns package for readDiscreteInputs function (0x02)
    func readDiscreteInputs(startAddress: UInt16, numOfInputs: UInt16) -> Data {
        return createCommand(
            command: .readDiscreteInputs,
            address: startAddress,
            data: DataHelper.splitIntIntoTwoBytes(numOfInputs)
        )
    }
    
    /// Returns package for readHoldingRegisters function (0x03)
    func readHoldingRegisters(startAddress: UInt16, numOfRegs: UInt16) -> Data {
        return createCommand(
            command: .readHoldingRegisters,
            address: startAddress,
            data: DataHelper.splitIntIntoTwoBytes(numOfRegs)
        )
    }
    
    /// Returns package for readInputRegisters function (0x04)
    func readInputRegisters(startAddress: UInt16, numOfRegs: UInt16) -> Data {
        return createCommand(
            command: .readInputRegisters,
            address: startAddress,
            data: DataHelper.splitIntIntoTwoBytes(numOfRegs)
        )
    }
    
    /// Returns package for force (write) single coil function (0x05)
    func forceSingleCoil(startAddress: UInt16, value: Bool) -> Data {
        return createCommand(
            command: .forceSingleCoil,
            address: startAddress,
            data: [(value ? 0xFF : 0x00) , 0x00]
        )
    }
    
    /// Returns package for preset (write) single register function (0x06)
    func presetSingleRegister(startAddress: UInt16, value: UInt16) -> Data {
        return createCommand(
            command: .presetSingleRegister,
            address: startAddress,
            data: DataHelper.splitIntIntoTwoBytes(value)
        )
    }
    
    /// Returns package for "Read Exception Status" function (0x07)
//    func readExceptionStatus() -> Data {
//        return createCommand(command: .presetSingleRegister)
//    }
    
    /// Returns package for force (write) multiple coils function (0x0F)
    func forceMultipleCoils(startAddress: UInt16, values: [Bool]) -> Data {
        var data: [UInt8] = DataHelper.splitIntIntoTwoBytes(values.count)
        
        // Compute values mask size in bytes. Values.count = 20, then we need 3 bytes for mask
        let bytesCount = Int(ceil(Double(values.count) / 8))
        data.append(UInt8(bytesCount))
        
        for i in 0...(bytesCount - 1) {
            var byte: UInt8 = 0
            for y in 0...7 {
                let index = i * 8 + y
                if index < values.count {
                    byte += values[index] ? 128 : 0
                }
                if y != 7 {
                    byte = byte >> 1
                }
            }
            data.append(byte)
        }
        
        return createCommand(
            command: .forceMultipleCoils,
            address: startAddress,
            data: data
        )
    }
    
    /// Returns package for preset (write) multiple registers function (0x10)
    func presetMultipleRegisters(startAddress: UInt16, values: [UInt16]) -> Data {
        var data: [UInt8] = DataHelper.splitIntIntoTwoBytes(values.count) + [
            UInt8(values.count * 2)
        ]

        for value in values {
            data.append(contentsOf: DataHelper.splitIntIntoTwoBytes(value))
        }

        return createCommand(
            command: .presetMultipleRegisters,
            address: startAddress,
            data: data
        )
    }
    
}
