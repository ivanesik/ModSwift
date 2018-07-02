//
//  ModSwift.swift
//  Enums
//
//  Created by Admin on 02.07.2018.
//  Copyright © 2018 Ivan Elyoskin. All rights reserved.
//

/**
 Describe the format of sended package
*/
enum ModbusMode {
    case rtu
    case tcp
}

/**
 Modbus command codes
 - Coil:        One bit read/write register
 - Discrete:    One bit only read register
 - Holding:     16 bit read/write unsigned register
 - Input:       16 bit only read unsigned register
 */
enum Command: UInt16 {
    /** Read coil (one bit) register */
    case readCoilStatus = 0x01
    /** Read discrete (one bit) register */
    case readDiscreteInputs = 0x02
    /** Read holding (16 bit) register */
    case readHoldingRegisters = 0x03
    /** Read input (16 bit) register */
    case readInputRegisters = 0x04

    /** Write coil (one bit) register */
    case forceSingleCoil = 0x05
    /** Write holding (16 bit bit) register */
    case presetSingleRegister = 0x06

    /** Write multiply coil (one bit) registers */
    case forceMultipleCoils = 0x15
    /** Write multiply holding (16 bit bit) registers */
    case presetMultipleRegisters = 0x16
}

/**
 Modbus error codes
 */
enum Error: UInt16 {
    case errorReadCoilStatus = 0x01 // read-write
    case errorReadDiscreteInputs = 0x02 // read only
    case errorReadHoldingRegisters = 0x03 // read-write
    case errorReadInputRegisters = 0x04 // read only
    
    case errorRorceSingleCoil = 0x05
    case errorPresetSingleRegister = 0x06
    
    case errorForceMultipleCoils = 0x15
    case errorPresetMultipleRegisters = 0x16
}
