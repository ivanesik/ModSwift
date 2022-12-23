//
//  ModSwiftSharedTests.swift
//  
//
//  Created by Ivan Eleskin on 05.07.2018.
//

import XCTest
@testable import ModSwift

class ModSwiftSharedTests: XCTestCase {
    
    var modbus: ModSwift!
    
    override func setUp() {
        super.setUp()
        modbus = ModSwift()
    }
    
    override func tearDown() {
        modbus = nil
        super.tearDown()
    }
    
    func testInitialState() {
        
    }
    
    func testSetSlave() {
        var address: UInt8 = 0xA3
        modbus.setSlave(slaveAddress: address)
        XCTAssertEqual(modbus.getSlave(), address)
        
        address = 0x00
        modbus.setSlave(slaveAddress: address)
        XCTAssertEqual(modbus.getSlave(), address)
        
        address = 0xFF
        modbus.setSlave(slaveAddress: address)
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

}
