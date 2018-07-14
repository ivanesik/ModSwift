//
//  ModSwiftSharedTests.swift
//  ModSwiftTest
//
//  Created by Admin on 05.07.2018.
//  Copyright © 2018 Ivan Elyoskin. All rights reserved.
//

import XCTest
@testable import ModSwift

class ModSwiftSharedTests: XCTestCase {
    
    var modbus: ModSwift!
    
//***************************************************************************************************************
//-Setup---------------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    override func setUp() {
        super.setUp()
        modbus = ModSwift()
    }
    
    override func tearDown() {
        modbus = nil
        super.tearDown()
    }
    
//***************************************************************************************************************
//-Tests---------------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    func testSetDevice() {
        var address: UInt8 = 0xA3
        modbus.setSlave(slaveAdress: address)
        XCTAssertEqual(modbus.getSlave(), address)
        address = 0x00
        modbus.setSlave(slaveAdress: address)
        XCTAssertEqual(modbus.getSlave(), address)
        address = 0xFF
        modbus.setSlave(slaveAdress: address)
        XCTAssertEqual(modbus.getSlave(), address)
    }
    
    func testSetMode() {
        modbus.setMode(.tcp)
        XCTAssertEqual(modbus.getMode(), ModbusMode.tcp)
        modbus.setMode(.rtu)
        XCTAssertEqual(modbus.getMode(), ModbusMode.rtu)
        //modbus.setMode(.ascii)
        //XCTAssertEqual(modbus.getMode(), ModbusMode.ascii)
    }
    
    func testSetTransactionId() {
        var transactionId: UInt16 = 0x1254
        modbus.setTransactionId(transactionId)
        XCTAssertEqual(modbus.getTransactionId(), transactionId)
        transactionId = 0x0
        modbus.setTransactionId(transactionId)
        XCTAssertEqual(modbus.getTransactionId(), transactionId)
        transactionId = 0xFFFF
        modbus.setTransactionId(transactionId)
        XCTAssertEqual(modbus.getTransactionId(), transactionId)
    }
    
    func testSetProtocolId() {
        var protocolId: UInt16 = 0x1254
        modbus.setProtocolId(protocolId)
        XCTAssertEqual(modbus.getProtocolId(), protocolId)
        protocolId = 0x0
        modbus.setProtocolId(protocolId)
        XCTAssertEqual(modbus.getProtocolId(), protocolId)
        protocolId = 0xFFFF
        modbus.setProtocolId(protocolId)
        XCTAssertEqual(modbus.getProtocolId(), protocolId)
    }
    
    func testCrc8() {
        let modbusCrc16 = Crc16().modbusCrc16([0x12, 0x5F, 0x84, 0x05])
        XCTAssertEqual(0x4D96, modbusCrc16)
    }

}
