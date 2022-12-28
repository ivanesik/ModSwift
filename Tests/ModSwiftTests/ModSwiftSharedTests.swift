//
//  ModSwiftSharedTests.swift
//
//
//  Created by Ivan Eleskin on 05.07.2018.
//

import Foundation
@testable import ModSwift
import XCTest

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

    func testInitialState() {}

    // TODO: add check in result package
    func testSetMode() {
        modbus.setMode(.tcp)
        XCTAssertEqual(modbus.getMode(), ModbusMode.tcp)

        modbus.setMode(.rtu)
        XCTAssertEqual(modbus.getMode(), ModbusMode.rtu)

        // modbus.setMode(.ascii)
        // XCTAssertEqual(modbus.getMode(), ModbusMode.ascii)
    }

    // TODO: add check in result package
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

    // TODO: add check in result package
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

    // TODO: add check in result package
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

    func testTransactionIncrement() {
        // AutoIncrement: OFF
        modbus.setTransctionAutoIncrement(false)

        var rightData = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x05, 0x01, 0x0D, 0xFF, 0x00])
        var data = modbus.forceSingleCoil(startAddress: 0x010D, value: true)
        XCTAssertEqual(data, rightData)

        rightData = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x05, 0x01, 0x0D, 0x00, 0x00])
        data = modbus.forceSingleCoil(startAddress: 0x010D, value: false)
        XCTAssertEqual(data, rightData)

        // AutoIncrement: ON
        modbus.setTransctionAutoIncrement(true)

        rightData = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x05, 0x01, 0x0D, 0xFF, 0x00])
        data = modbus.forceSingleCoil(startAddress: 0x010D, value: true)
        XCTAssertEqual(data, rightData)

        rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x06, 0x00, 0x05, 0x01, 0x0D, 0x00, 0x00])
        data = modbus.forceSingleCoil(startAddress: 0x010D, value: false)
        XCTAssertEqual(data, rightData)

        // AutoIncrement: OFF
        modbus.setTransctionAutoIncrement(false)

        rightData = Data([0x00, 0x02, 0x00, 0x00, 0x00, 0x06, 0x00, 0x05, 0x01, 0x0D, 0x00, 0x00])
        data = modbus.forceSingleCoil(startAddress: 0x010D, value: false)
        XCTAssertEqual(data, rightData)

        rightData = Data([0x00, 0x02, 0x00, 0x00, 0x00, 0x06, 0x00, 0x05, 0x01, 0x0D, 0x00, 0x00])
        data = modbus.forceSingleCoil(startAddress: 0x010D, value: false)
        XCTAssertEqual(data, rightData)
    }

    func testLrcChecksum() {
        let data: [UInt8] = [0xF7, 0x03, 0x13, 0x89, 0x00, 0x0A]
        let result = DataHelper.computeLRC(data)
        XCTAssertEqual(0x60, result)
    }
}
