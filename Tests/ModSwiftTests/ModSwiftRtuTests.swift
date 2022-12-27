//
//  ModSwiftSharedTests.swift
//
//
//  Created by Ivan Eleskin on 14.07.2018.
//

import XCTest
@testable import ModSwift

final class ModSwiftTests: XCTestCase {
    var modbus: ModSwift!
    
    override func setUp() {
        super.setUp()
        modbus = ModSwift()
        modbus.setMode(.rtu)
        modbus.setSlave(slaveAddress: 0x0B)
    }
    
    override func tearDown() {
        modbus = nil
        super.tearDown()
    }
    
    func testReadCoilStatus() {
        let rightData = Data([0x0B, 0x01, 0x01, 0x0D, 0x00, 25, 0x55, 0x6D] ) //  slave 1, func 1, addr 2, data 2, crc 2
        let data = modbus.readCoilStatus(startAddress: 0x010D, numOfCoils: 0x0019)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadDiscreteInputs() {
        let rightData = Data([0x0B, 2, 1, 13, 0, 25, 0x55, 0x29] )
        let data = modbus.readDiscreteInputs(startAddress: 0x010D, numOfInputs: 0x0019)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadHoldingRegisters() {
        let rightData = Data([0x0B, 3, 1, 13, 0, 3, 0x5E, 0x95] )
        let data = modbus.readHoldingRegisters(startAddress: 0x010D, numOfRegs: 0x0003)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadInputRegisters() {
        let rightData = Data([0x0B, 4, 1, 13, 0, 3, 0x9E, 0x20] )
        let data = modbus.readInputRegisters(startAddress: 0x010D, numOfRegs: 0x0003)
        XCTAssertEqual(data, rightData)
    }
    
    func testForceSingleCoil() {
        var rightData = Data([0x0B, 0x05, 0x01, 0x0D, 0xFF, 0x00, 0xAF, 0x1C] )
        var data = modbus.forceSingleCoil(startAddress: 0x010D, value: true)
        XCTAssertEqual(data, rightData)
        
        rightData = Data([0x0B, 0x05, 0x01, 0x0D, 0x00, 0x00, 0x5F, 0x5D] )
        data = modbus.forceSingleCoil(startAddress: 0x010D, value: false)
        XCTAssertEqual(data, rightData)
    }
    
    func testPresetSingleRegister() {
        let rightData = Data([0x0B, 0x06, 0x01, 0x0D, 0x00, 0x03, 0x5E, 0x59] )
        let data = modbus.presetSingleRegister(startAddress: 0x010D, value: 0x0003)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadExceptionStatus() {
        let rightData = Data([0x0B, 0x07, 0x42, 0x47])
        let data = modbus.readExceptionStatus()
        XCTAssertEqual(data, rightData)
    }
    
    func testForceMultipleCoils() {
        // trans 2, prot 2, len 2, slave 1, func 1, addr 2, count 2, data
        let rightData = Data([11, 15, 1, 13, 0, 20, 3, 0x85, 0xA8, 0x05, 0x73, 0xC3])
        let data = modbus.forceMultipleCoils(startAddress: 0x010D, values: [true, false, true, false, false, false, false, true, false, false, false, true, false, true, false, true, true, false, true, false])
        XCTAssertEqual(data, rightData)
    }
    
    func testPresetMultipleRegisters() {
        let rightData = Data([11, 16, 1, 13, 0, 3 /*reg nums*/, 6, 0xA3, 0x0D, 0x15, 0x01, 0x11, 0x27, 0x58, 0x47])
        let data = modbus.presetMultipleRegisters(startAddress: 0x010D, values: [0xA30D, 0x1501, 0x1127])
        XCTAssertEqual(data, rightData)
    }
}
