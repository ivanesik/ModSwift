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
    
    func testDiagnostic() {
        var rightData = Data([0x0B, 0x08, 0x00, 0x01, 0xFF, 0x00, 0x91, 0xf0])
        var data = modbus.diagnostic(subFunction: 0x0001, data: 0xFF00)
        XCTAssertEqual(data, rightData)

        rightData = Data([0x0B, 0x08, 0x00, 0x11, 0x00, 0x00, 0xa4, 0xb0])
        data = modbus.diagnostic(subFunction: 0x0011, data: 0x0000)
        XCTAssertEqual(data, rightData)
    }
    
    func testGetCommEventCounter() {
        let rightData = Data([0x0B, 0x0B, 0x47, 0x47])
        let data = modbus.getCommEventCounter()
        XCTAssertEqual(data, rightData)
    }
    
    func testGetCommEventLog() {
        let rightData = Data([0x0B, 0x0C, 0x85, 0x06])
        let data = modbus.getCommEventLog()
        XCTAssertEqual(data, rightData)
    }
    
    func testForceMultipleCoils() {
        // trans 2, prot 2, len 2, slave 1, func 1, addr 2, count 2, data
        let rightData = Data([11, 15, 1, 13, 0, 20, 3, 0x85, 0xA8, 0x05, 0x73, 0xC3])
        let data = modbus.forceMultipleCoils(startAddress: 0x010D, values: [true, false, true, false, false, false, false, true, false, false, false, true, false, true, false, true, true, false, true, false])
        XCTAssertEqual(data, rightData)
    }
    
    func testPresetMultipleRegisters() {
        let rightData = Data([0x0B, 0x10, 0x01, 0x0D, 0x00, 0x03, 0x06, 0xA3, 0x0D, 0x15, 0x01, 0x11, 0x27, 0x58, 0x47])
        let data = modbus.presetMultipleRegisters(startAddress: 0x010D, values: [0xA30D, 0x1501, 0x1127])
        XCTAssertEqual(data, rightData)
    }
    
    func testReportServerId() {
        let rightData = Data([0x0B, 0x11, 0x8c, 0xc6])
        let data = modbus.reportServerId()
        XCTAssertEqual(data, rightData)
    }
    
    func testReadFileRecord() {
        let rightData = Data([0x0B, 0x14, 0x0E, 0x06, 0x00, 0x04, 0x00, 0x01, 0x00, 0x02, 0x06, 0x00, 0x03, 0x00, 0x09, 0x00, 0x02, 0x5f, 0xd2])
        let readFileSubRequests = [
            ModSwiftReadFileSubRequest(fileNumber: 0x0004, recordNumber: 0x0001, recordLength: 0x0002),
            ModSwiftReadFileSubRequest(fileNumber: 0x0003, recordNumber: 0x0009, recordLength: 0x0002)
        ]
        let data = modbus.readFileRecord(subRequests: readFileSubRequests)
        XCTAssertEqual(data, rightData)
    }
    
    func testWriteFileRecord() {
        let rightData = Data([0x0B, 0x15, 0x18, 0x06, 0x00, 0x04, 0x00, 0x07, 0x00, 0x03, 0x06, 0xAF, 0x04, 0xBE, 0x10, 0x0D, 0x06, 0x00, 0x09, 0x00, 0x02, 0x00, 0x02, 0xF1, 0x02, 0x00, 0x5D, 0xe8, 0xEE])
        let readFileSubRequests = [
            ModSwiftWriteFileSubRequest(
                fileNumber: 0x0004,
                recordNumber: 0x0007,
                recordData: [0x06AF, 0x04BE, 0x100D]
            ),
            ModSwiftWriteFileSubRequest(
                fileNumber: 0x0009,
                recordNumber: 0x0002,
                recordData: [0xF102, 0x005D]
            )
        ]
        let data = modbus.writeFileRecord(subRequests: readFileSubRequests)

        XCTAssertEqual(data, rightData)
    }
    
    func testMaskWriteRegister() {
        let rightData = Data([0x0B, 0x16, 0x00, 0x04, 0x00, 0xF2, 0x00, 0x025, 0x91, 0xe7])
        let data = modbus.maskWriteRegister(referenceAddress: 0x04, andMask: 0xF2, orMask: 0x25)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadAndWriteMultipleRegisters() {
        let rightData = Data([0x0B, 0x17, 0x00, 0x03, 0x00, 0x06, 0x00, 0x0E, 0x00, 0x03, 0x06, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0x33, 0x60])
        let data = modbus.readAndWriteMultipleRegisters(
            readStartingAddress: 0x03,
            quantityToRead: 0x06,
            writeStartingAddress: 0x0E,
            writeRegistersValues: [0xFF, 0xFF, 0xFF]
        )
        XCTAssertEqual(data, rightData)
    }
}
