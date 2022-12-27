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
    
    func testGetCommEventCounter() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x0B, 0x0B])
        let data = modbus.getCommEventCounter()
        XCTAssertEqual(data, rightData)
    }
    
    func testGetCommEventLog() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x0B, 0x0C])
        let data = modbus.getCommEventLog()
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
    
    func testReportServerId() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x02, 0x0B, 0x11])
        let data = modbus.reportServerId()
        XCTAssertEqual(data, rightData)
    }
    
    func testReadFileRecord() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x11, 0x0B, 0x14, 0x0E, 0x06, 0x00, 0x04, 0x00, 0x01, 0x00, 0x02, 0x06, 0x00, 0x03, 0x00, 0x09, 0x00, 0x02])
        let readFileSubRequests = [
            ModSwiftReadFileSubRequest(fileNumber: 0x0004, recordNumber: 0x0001, recordLength: 0x0002),
            ModSwiftReadFileSubRequest(fileNumber: 0x0003, recordNumber: 0x0009, recordLength: 0x0002)
        ]
        let data = modbus.readFileRecord(subRequests: readFileSubRequests)
        XCTAssertEqual(data, rightData)
    }
    
    func testWriteFileRecord() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x1b, 0x0B, 0x15, 0x18, 0x06, 0x00, 0x04, 0x00, 0x07, 0x00, 0x03, 0x06, 0xAF, 0x04, 0xBE, 0x10, 0x0D, 0x06, 0x00, 0x09, 0x00, 0x02, 0x00, 0x02, 0xF1, 0x02, 0x00, 0x5D])
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
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x0B, 0x16, 0x00, 0x04, 0x00, 0xF2, 0x00, 0x025])
        let data = modbus.maskWriteRegister(referenceAddress: 0x04, andMask: 0xF2, orMask: 0x25)
        XCTAssertEqual(data, rightData)
    }
    
    func testReadAndWriteMultipleRegisters() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x11, 0x0B, 0x17, 0x00, 0x03, 0x00, 0x06, 0x00, 0x0E, 0x00, 0x03, 0x06, 0x00, 0xFF, 0x00, 0xFF, 0x00, 0xFF])
        let data = modbus.readAndWriteMultipleRegisters(
            readStartingAddress: 0x03,
            quantityToRead: 0x06,
            writeStartingAddress: 0x0E,
            writeRegistersValues: [0xFF, 0xFF, 0xFF]
        )
        XCTAssertEqual(data, rightData)
    }
    
    func testReadFIFOQueue() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x04, 0x0B, 0x18, 0x13, 0xDA])
        let data = modbus.readFIFOQueue(FIFOPointerAddress: 0x13DA)
        XCTAssertEqual(data, rightData)
    }
    
    func testEncapsulatedInterfaceTransport() {
        let rightData = Data([0x00, 0x01, 0x00, 0x00, 0x00, 0x08, 0x0B, 0x2B, 0x0D, 0xAA, 0xFF, 0x01, 0x00, 0x14])
        let data = modbus.encapsulatedInterfaceTransport(meiType: 0x0D, meiData: [0xAA, 0xFF, 0x01, 0x00, 0x14])
        XCTAssertEqual(data, rightData)
    }
    
}
