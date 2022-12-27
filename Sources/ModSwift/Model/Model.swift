//
//  Model.swift
//  
//
//  Created by Ivan Eleskin on 02.07.2018.
//

/// Describe the format of sended package
public enum ModbusMode {
    case tcp
    case rtu
    //case ascii
}

/**
 Modbus command codes
 - Coil:        One bit read/write register
 - Discrete:    One bit only read register
 - Holding:     16 bit read/write unsigned register
 - Input:       16 bit only read unsigned register
 */
enum Command: UInt8 {
    /** Read coil (one bit) status */
    case readCoilStatus = 0x01
    /** Read discrete (one bit) inputs */
    case readDiscreteInputs = 0x02
    /** Read holding (16 bit) registers */
    case readHoldingRegisters = 0x03
    /** Read input (16 bit) registers */
    case readInputRegisters = 0x04
    
    /** Write coil (one bit) register */
    case forceSingleCoil = 0x05
    /** Write holding (16 bit bit) register */
    case presetSingleRegister = 0x06
    
    /** Read Exception Status */
    case readExceptionStatus = 0x07
    /** Diagnostic */
    case diagnostic = 0x08
    /** Get Com Event Counter */
    case getCommEventCounter = 0x0B
    /** Get Com Event Log */
    case getComEventLog = 0x0C
    /** Report Server ID */
    case reportServerId = 0x11
    
    /** Write multiply coil (one bit) registers */
    case forceMultipleCoils = 0x0F
    /** Write multiply holding (16 bit bit) registers */
    case presetMultipleRegisters = 0x10
    
    /** Mask Write Register */
    case maskWriteRegister = 0x16
    
    /** Read/Write Multiple registers */
    case readAndWriteMultipleRegisters = 0x17
    
    /** Read FIFO Queue */
    case readFIFOQueue = 0x18
    
    /** Read File Record */
    case readFileRecord = 0x14
    /** Write File Record */
    case writeFileRecord = 0x15
    
    /** Encapsulated Interface Transport */
    case encapsulatedInterfaceTransport = 0x2B
}
