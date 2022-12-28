//
//  ModSwiftAsciiTests.swift
//
//
//  Created by Ivan Eleskin on 28.12.2022.
//

@testable import ModSwift
import XCTest

final class ModSwiftAsciiTests: XCTestCase {
    var modbus: ModSwift!

    override func setUp() {
        super.setUp()
        modbus = ModSwift()
        modbus.setMode(.ascii)
        modbus.setSlave(slaveAddress: 0x15)
    }

    override func tearDown() {
        modbus = nil
        super.tearDown()
    }

    func testReadCoilStatus() {
        let rightData = Data([0x3A, 0x15, 0x01, 0x01, 0x0D, 0x00, 0x19, 0xC3, 0x0D, 0x0A])
        let data = modbus.readCoilStatus(startAddress: 0x010D, numOfCoils: 0x0019)
        XCTAssertEqual(data, rightData)
    }

    func testReadDiscreteInputs() {
        let rightData = Data([0x3A, 0x15, 0x02, 0x01, 0x0D, 0x00, 0x19, 0xC2, 0x0D, 0x0A])
        let data = modbus.readDiscreteInputs(startAddress: 0x010D, numOfInputs: 0x0019)
        XCTAssertEqual(data, rightData)
    }

    func testReadHoldingRegisters() {
        // Example from: https://ozeki.hu/p_5855-modbus-ascii.html
        var rightData = Data([0x3A, 0x15, 0x03, 0x00, 0x6B, 0x00, 0x03, 0x7A, 0x0D, 0x0A])
        var data = modbus.readHoldingRegisters(startAddress: 0x006B, numOfRegs: 0x0003)
        XCTAssertEqual(data, rightData)

        // Example from: https://en.wikipedia.org/wiki/Modbus#Modbus_ASCII_frame_format
        modbus.setSlave(slaveAddress: 0xF7)
        rightData = Data([0x3A, 0xF7, 0x03, 0x13, 0x89, 0x00, 0x0A, 0x60, 0x0D, 0x0A])
        data = modbus.readHoldingRegisters(startAddress: 0x1389, numOfRegs: 0x000A)
        XCTAssertEqual(data, rightData)
    }

    func testReadInputRegisters() {
        let rightData = Data([0x3A, 0x15, 0x04, 0x01, 0x0D, 0x00, 0x03, 0xD6, 0x0D, 0x0A])
        let data = modbus.readInputRegisters(startAddress: 0x010D, numOfRegs: 0x0003)
        XCTAssertEqual(data, rightData)
    }

    func testForceSingleCoil() {
        var rightData = Data([0x3A, 0x15, 0x05, 0x01, 0x0D, 0xFF, 0x00, 0xD9, 0x0D, 0x0A])
        var data = modbus.forceSingleCoil(startAddress: 0x010D, value: true)
        XCTAssertEqual(data, rightData)

        rightData = Data([0x3A, 0x15, 0x05, 0x01, 0x0D, 0x00, 0x00, 0xD8, 0x0D, 0x0A])
        data = modbus.forceSingleCoil(startAddress: 0x010D, value: false)
        XCTAssertEqual(data, rightData)
    }

    func testPresetSingleRegister() {
        let rightData = Data([0x3A, 0x15, 0x06, 0x01, 0x0D, 0x00, 0x03, 0xD4, 0x0D, 0x0A])
        let data = modbus.presetSingleRegister(startAddress: 0x010D, value: 0x0003)
        XCTAssertEqual(data, rightData)
    }

    func testReadExceptionStatus() {
        let rightData = Data([0x3A, 0x15, 0x07, 0xE4, 0x0D, 0x0A])
        let data = modbus.readExceptionStatus()
        XCTAssertEqual(data, rightData)
    }

    func testDiagnostic() {
        var rightData = Data([0x3A, 0x15, 0x08, 0x00, 0x01, 0xFF, 0x00, 0xE3, 0x0D, 0x0A])
        var data = modbus.diagnostic(subFunction: 0x0001, data: 0xFF00)
        XCTAssertEqual(data, rightData)

        rightData = Data([0x3A, 0x15, 0x08, 0x00, 0x11, 0x00, 0x00, 0xD2, 0x0D, 0x0A])
        data = modbus.diagnostic(subFunction: 0x0011, data: 0x0000)
        XCTAssertEqual(data, rightData)
    }

    func testGetCommEventCounter() {
        let rightData = Data([0x3A, 0x15, 0x0B, 0xE0, 0x0D, 0x0A])
        let data = modbus.getCommEventCounter()
        XCTAssertEqual(data, rightData)
    }

    func testGetCommEventLog() {
        let rightData = Data([0x3A, 0x15, 0x0C, 0xDF, 0x0D, 0x0A])
        let data = modbus.getCommEventLog()
        XCTAssertEqual(data, rightData)
    }

    func testForceMultipleCoils() {
        let rightData = Data([0x3A, 0x15, 0x0F, 0x01, 0x0D, 0x00, 0x14, 0x03, 0x85, 0xA8, 0x05, 0x85, 0x0D, 0x0A])
        let data = modbus.forceMultipleCoils(
            startAddress: 0x010D,
            values: [
                true,
                false,
                true,
                false,
                false,
                false,
                false,
                true,
                false,
                false,
                false,
                true,
                false,
                true,
                false,
                true,
                true,
                false,
                true,
                false,
            ]
        )
        XCTAssertEqual(data, rightData)
    }

    func testPresetMultipleRegisters() {
        let rightData =
            Data([0x3A, 0x15, 0x10, 0x01, 0x0D, 0x00, 0x03, 0x06, 0xA3, 0x0D, 0x15, 0x01, 0x11, 0x27, 0xC6, 0x0D, 0x0A])
        let data = modbus.presetMultipleRegisters(startAddress: 0x010D, values: [0xA30D, 0x1501, 0x1127])
        XCTAssertEqual(data, rightData)
    }

    func testReportServerId() {
        let rightData = Data([0x3A, 0x15, 0x11, 0xDA, 0x0D, 0x0A])
        let data = modbus.reportServerId()
        XCTAssertEqual(data, rightData)
    }

    func testReadFileRecord() {
        let rightData =
            Data([
                0x3A, 0x15,
                0x14,
                0x0E,
                0x06,
                0x00,
                0x04,
                0x00,
                0x01,
                0x00,
                0x02,
                0x06,
                0x00,
                0x03,
                0x00,
                0x09,
                0x00,
                0x02,
                0xA8,
                0x0D, 0x0A,
            ])
        let readFileSubRequests = [
            ModSwiftReadFileSubRequest(fileNumber: 0x0004, recordNumber: 0x0001, recordLength: 0x0002),
            ModSwiftReadFileSubRequest(fileNumber: 0x0003, recordNumber: 0x0009, recordLength: 0x0002),
        ]
        let data = modbus.readFileRecord(subRequests: readFileSubRequests)
        XCTAssertEqual(data, rightData)
    }

    func testWriteFileRecord() {
        let rightData = Data([
            0x3A, 0x15,
            0x15,
            0x18,
            0x06,
            0x00,
            0x04,
            0x00,
            0x07,
            0x00,
            0x03,
            0x06,
            0xAF,
            0x04,
            0xBE,
            0x10,
            0x0D,
            0x06,
            0x00,
            0x09,
            0x00,
            0x02,
            0x00,
            0x02,
            0xF1,
            0x02,
            0x00,
            0x5D,
            0xB3,
            0x0D, 0x0A,
        ])
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
            ),
        ]
        let data = modbus.writeFileRecord(subRequests: readFileSubRequests)

        XCTAssertEqual(data, rightData)
    }

    func testMaskWriteRegister() {
        let rightData = Data([0x3A, 0x15, 0x16, 0x00, 0x04, 0x00, 0xF2, 0x00, 0x025, 0xBA, 0x0D, 0x0A])
        let data = modbus.maskWriteRegister(referenceAddress: 0x04, andMask: 0xF2, orMask: 0x25)
        XCTAssertEqual(data, rightData)
    }

    func testReadAndWriteMultipleRegisters() {
        let rightData =
            Data([
                0x3A, 0x15,
                0x17,
                0x00,
                0x03,
                0x00,
                0x06,
                0x00,
                0x0E,
                0x00,
                0x03,
                0x06,
                0x00,
                0xFF,
                0x00,
                0xFF,
                0x00,
                0xFF,
                0xB7,
                0x0D, 0x0A,
            ])
        let data = modbus.readAndWriteMultipleRegisters(
            readStartingAddress: 0x03,
            quantityToRead: 0x06,
            writeStartingAddress: 0x0E,
            writeRegistersValues: [0xFF, 0xFF, 0xFF]
        )
        XCTAssertEqual(data, rightData)
    }

    func testReadFIFOQueue() {
        let rightData = Data([0x3A, 0x15, 0x18, 0x13, 0xDA, 0xE6, 0x0D, 0x0A])
        let data = modbus.readFIFOQueue(FIFOPointerAddress: 0x13DA)
        XCTAssertEqual(data, rightData)
    }

    func testEncapsulatedInterfaceTransport() {
        let rightData = Data([0x3A, 0x15, 0x2B, 0x0D, 0xAA, 0xFF, 0x01, 0x00, 0x14, 0xF5, 0x0D, 0x0A])
        let data = modbus.encapsulatedInterfaceTransport(meiType: 0x0D, meiData: [0xAA, 0xFF, 0x01, 0x00, 0x14])
        XCTAssertEqual(data, rightData)
    }
}
