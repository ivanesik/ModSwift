# ModSwift

[![Swift](https://img.shields.io/badge/Swift->5.0-orange.svg)](https://swift.org)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ModSwift.svg?style=flat-square)](https://img.shields.io/cocoapods/v/ModSwift.svg)
[![Xcode](https://img.shields.io/badge/Xcode-14.0-blue.svg)](https://developer.apple.com/xcode)
[![MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)

---

## Summary

Library to easy generate Modbus commands in Swift.

## Installation

### Swift Package Manager

Once you have your Swift package set up, adding ModSwift as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/ivanesik/ModSwift.git", from: "0.0.1")
]
```

### CocoaPods

To integrate CrcSwift into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
pod 'ModSwift', '~> 0.0.1'
```

## Usage

### Master Mode

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

## Features

Type:

- Modbus Client (Master)
- (in progress) Modbus Server (Slave)

Mode:

- RTU
- TCP

Functions:

- Read coil (one bit) register: **readCoilStatus** = 0x01
- Read discrete (one bit) register: **readDiscreteInputs** = 0x02
- Read holding (16 bit) register: **readHoldingRegisters** = 0x03
- Read input (16 bit) register: **readInputRegisters** = 0x04

- Write coil (one bit) register: **forceSingleCoil** = 0x05
- Write holding (16 bit bit) register: **presetSingleRegister** = 0x06

- Write multiply coil (one bit) registers: **forceMultipleCoils** = 0x0F
- Write multiply holding (16 bit bit) registers: **presetMultipleRegisters**= 0x10

## TODO

- TODO in readme
- Modes:
  - ASCII mode
  - Modbus Plus
  - Pemex Modbus
  - Enron Modbus
- Slave mode
- Error Codes
- LRC check (for ASCII mode)
- Tests in CI
- Pod lint in CI

## License

[MIT licensed.](LICENSE)
