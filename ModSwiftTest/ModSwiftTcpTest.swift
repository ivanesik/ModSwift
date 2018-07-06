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
        // transactionId = 0x0001, protocolId = 0x0000, len = 0x0006,
        // slave = 0x0B, function = 0x01, address = 0x010D, data = 0x0019
        let rightData = Data([0, 1, 0, 0,0, 6, 11, 1, 1, 13, 0, 25] )
        let data = modbus.readCoilStatus(startAddress: 0x010D, numOfCoils: 0x0019)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadDiscreteInputs() {
    }
    
    func testReadHoldingRegisters() {
    }
    
    func testReadInputRegisters() {
    }
    
    func testForceSingleCoil() {
    }
    
    func testPresetSingleRegister() {
    }
    
    func testForceMultipleCoils() {
    }
    
    func testPresetMultipleRegisters() {
    }
    
    
    func testCommandCreate() {
        
    }

    
}
