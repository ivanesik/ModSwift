//
//  ModSwiftTest.swift
//  ModSwiftTest
//
//  Created by Admin on 05.07.2018.
//  Copyright © 2018 Ivan Elyoskin. All rights reserved.
//

import XCTest
@testable import ModSwift

class ModSwiftTcpTest: XCTestCase {
    
    var modbus: ModSwift!
    
//***************************************************************************************************************
//-Setup---------------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    override func setUp() {
        super.setUp()
        modbus = ModSwift()
        modbus.setMode(.tcp)
        modbus.setTransactionId(0x0001)
        modbus.setProtocolId(0x0000)
        modbus.setSlave(slaveAdress: 0x0B)
    }
    
    override func tearDown() {
        modbus = nil
        super.tearDown()
    }
    
//***************************************************************************************************************
//-Tests---------------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    func testReadCoilStatus() {
        let rightData = Data([0, 1, 0, 0, 0, 6, 11, 1, 1, 13, 0, 25] ) // trans 2, prot 2, len 2, slave 1, func 1, addr 2, data 2
        let data = modbus.readCoilStatus(startAddress: 0x010D, numOfCoils: 0x0019)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadDiscreteInputs() {
        let rightData = Data([0, 1, 0, 0, 0, 6, 11, 2, 1, 13, 0, 25] )
        let data = modbus.readDiscreteInputs(startAddress: 0x010D, numOfInputs: 0x0019)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadHoldingRegisters() {
        let rightData = Data([0, 1, 0, 0, 0, 6, 11, 3, 1, 13, 0, 3] )
        let data = modbus.readHoldingRegisters(startAddress: 0x010D, numOfRegs: 0x0003)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadInputRegisters() {
        let rightData = Data([0, 1, 0, 0, 0, 6, 11, 4, 1, 13, 0, 3] )
        let data = modbus.readInputRegisters(startAddress: 0x010D, numOfRegs: 0x0003)
        XCTAssertEqual(data, rightData)
    }
    
    func testForceSingleCoil() {
        var rightData = Data([0, 1, 0, 0, 0, 6, 11, 5, 1, 13, 0xFF, 0x00] )
        var data = modbus.forceSingleCoil(startAddress: 0x010D, value: true)
        XCTAssertEqual(data, rightData)
        rightData = Data([0, 2, 0, 0, 0, 6, 11, 5, 1, 13, 0x00, 0x00] )
        data = modbus.forceSingleCoil(startAddress: 0x010D, value: false)
        XCTAssertEqual(data, rightData)
    }
    
    func testPresetSingleRegister() {
        let rightData = Data([0, 1, 0, 0, 0, 6, 11, 6, 1, 13, 0, 3] )
        let data = modbus.presetSingleRegister(startAddress: 0x010D, value: 0x0003)
        XCTAssertEqual(data, rightData)
    }
    
    func testForceMultipleCoils() {
        // trans 2, prot 2, len 2, slave 1, func 1, addr 2, count 2, data
        let rightData = Data([0, 1, 0, 0, 0, 10, 11, 15, 1, 13, 0, 20, 3, 0x85, 0xA8, 0x05])
        let data = modbus.forceMultipleCoils(startAddress: 0x010D, values: [true, false, true, false, false, false, false, true, false, false, false, true, false, true, false, true, true, false, true, false])
        XCTAssertEqual(data, rightData)
    }
    
    func testPresetMultipleRegisters() {
        //let rightData = Data([0, 1, 0, 0, 0, 6, 11, 16,
    }
    
    
    func testCommandCreate() {
        
    }

    
}
