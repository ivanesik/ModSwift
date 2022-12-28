//
//  DataHelper.swift
//
//
//  Created by Ivan Eleskin on 25.12.2022.
//

enum DataHelper {
    static func splitIntIntoTwoBytes(_ value: UInt16) -> [UInt8] {
        return [UInt8(value >> 8), UInt8(value & 0xFF)]
    }

    static func splitIntIntoTwoBytes(_ value: Int) -> [UInt8] {
        return [UInt8(value >> 8), UInt8(value & 0xFF)]
    }

    static func computeLRC(_ data: [UInt8]) -> UInt8 {
        let sum = data.reduce(0) { partialResult, byte in
            return partialResult + Int(byte)
        }

        return UInt8(sum * -1 & 0xFF)
    }
}
