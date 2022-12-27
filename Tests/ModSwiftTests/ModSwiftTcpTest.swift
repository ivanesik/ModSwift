//
//  ModSwiftTcpTest.swift
//  
//
//  Created by Ivan Eleskin on 05.07.2018.
//

import XCTest
@testable import ModSwift

class ModSwiftTcpTest: XCTestCase {
    
    var modbus: ModSwift!
    
    override func setUp() {
        super.setUp()
        modbus = ModSwift(mode: .tcp, slaveAddress: 0x0B)
        modbus.setTransactionId(0x0001)
        modbus.setProtocolId(0x0000)
    }
    
    override func tearDown() {
        modbus = nil
        super.tearDown()
    }
    
    func testReadCoilStatus() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x0B, 0x01, 0x01, 0x0D, 0x00, 0x19])
        let data = modbus.readCoilStatus(startAddress: 0x010D, numOfCoils: 0x0019)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadDiscreteInputs() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x0B, 0x02, 0x01, 0x0D, 0x00, 0x19])
        let data = modbus.readDiscreteInputs(startAddress: 0x010D, numOfInputs: 0x0019)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadHoldingRegisters() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x0B, 0x03, 0x01, 0x0D, 0x00, 0x03])
        let data = modbus.readHoldingRegisters(startAddress: 0x010D, numOfRegs: 0x0003)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadInputRegisters() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x0B, 0x04, 0x01, 0x0D, 0x00, 0x03])
        let data = modbus.readInputRegisters(startAddress: 0x010D, numOfRegs: 0x0003)
        XCTAssertEqual(data, rightData)
    }
    
    func testForceSingleCoil() {
        var rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x0B, 0x05, 0x01, 0x0D, 0xFF, 0x00])
        var data = modbus.forceSingleCoil(startAddress: 0x010D, value: true)
        XCTAssertEqual(data, rightData)
        
        rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x0B, 0x05, 0x01, 0x0D, 0x00, 0x00])
        data = modbus.forceSingleCoil(startAddress: 0x010D, value: false)
        XCTAssertEqual(data, rightData)
    }
    
    func testPresetSingleRegister() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x0B, 0x06, 0x01, 0x0D, 0x00, 0x03])
        let data = modbus.presetSingleRegister(startAddress: 0x010D, value: 0x0003)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadExceptionStatus() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x0B, 0x07])
        let data = modbus.readExceptionStatus()        
        XCTAssertEqual(data, rightData)
    }
    
    func testDiagnostic() {
        var rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x0B, 0x08, 0x00, 0x01, 0xFF, 0x00])
        var data = modbus.diagnostic(subFunction: 0x0001, data: 0xFF00)        
        XCTAssertEqual(data, rightData)

        rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x0B, 0x08, 0x00, 0x11, 0x00, 0x00])
        data = modbus.diagnostic(subFunction: 0x0011, data: 0x0000)
        XCTAssertEqual(data, rightData)
    }
    
    func testForceMultipleCoils() {
        // trans 2, prot 2, len 2, slave 1, func 1, addr 2, count 2, data
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x0A, 0x0B, 0x0F, 0x01, 0x0D, 0x00, 0x14, 0x03, 0x85, 0xA8, 0x05])
        let data = modbus.forceMultipleCoils(startAddress: 0x010D, values: [true, false, true, false, false, false, false, true, false, false, false, true, false, true, false, true, true, false, true, false])
        XCTAssertEqual(data, rightData)
    }
    
    func testPresetMultipleRegisters() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x0D, 0x0B, 0x10, 0x01, 0x0D, 0x00, 0x03, 0x06, 0xA3, 0x0D, 0x15, 0x01, 0x11, 0x27])
        let data = modbus.presetMultipleRegisters(startAddress: 0x010D, values: [0xA30D, 0x1501, 0x1127])
        XCTAssertEqual(data, rightData)
    }
    
}
