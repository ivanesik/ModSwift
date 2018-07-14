# ModSwift
[![Swift](https://img.shields.io/badge/Swift-4.1-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-9.4-blue.svg)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)
____

## Summary
This library create for easy generate modbus commands on swift

## Features
- **Modbus Master** mode
- .tcp mode
- .rtu mode

## Functions
- Read coil (one bit) register: **readCoilStatus** = 0x01
- Read discrete (one bit) register: **readDiscreteInputs** = 0x02
- Read holding (16 bit) register: **readHoldingRegisters** = 0x03
- Read input (16 bit) register: **readInputRegisters** = 0x04

- Write coil (one bit) register: **forceSingleCoil** = 0x05
- Write holding (16 bit bit) register: **presetSingleRegister** = 0x06

- Write multiply coil (one bit) registers: **forceMultipleCoils** = 0x0F
- Write multiply holding (16 bit bit) registers: **presetMultipleRegisters**= 0x10


## Installation
Download repository and add ModSwift folder in your project 

## Usage
Setup
```swift
    var modbus = ModSwift()             // Default .tcp, slave address = 0x00
    modbus.setSlave(slaveAdress: 10)    // Set modbus slave address to 0x0A
    modbus.setMode(.rtu)                // Set package generate to ModbusRTU mode
    modbus.setTransactionId(15)         // Set modbus transaction id to 0x000E (just in .tcp mode)
    modbus.setProtocolId(3)             // Set modbus protocol id to 0x0003 (just in .tcp mode)
```

Package create
```swift
var modbus = ModSwift()
let dataRCS = modbus.readCoilStatus(startAddress: 0x010D, numOfCoils: 0x0019)
print(dataRCS as NSData) //<00010000 00060B01 010D0019>

let dataPMR = modbus.presetMultipleRegisters(startAddress: 0x010D, values: [0xA30D, 0x1501, 0x1127])
print(dataPMR as NSData) //<00010000 000d0b10 010d0003 06a30d15 011127>
```

## TODO
- Read reseaved packages in structure
- Slave package generate
- Modbus ASCII mode
- LRC check
- CocoaPods

## License

[MIT licensed.](LICENSE)
