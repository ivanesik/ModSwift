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
    }
    
    override func tearDown() {
        modbus = nil
        super.tearDown()
    }
    
//***************************************************************************************************************
//-Tests---------------------------------------------------------------------------------------------------------
//***************************************************************************************************************
    func readCoilStatus() {
    }
    
    func readDiscreteInputs() {
    }
    
    func readHoldingRegisters() {
    }
    
    func readInputRegisters() {
    }
    
    func forceSingleCoil() {
    }
    
    func presetSingleRegister() {
    }
    
    func forceMultipleCoils() {
    }
    
    /// Returns package for preset (write) multiple registers function (0x10)
    func presetMultipleRegisters() {
    }
    

    
}
