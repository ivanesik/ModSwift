//
//  DataHelper.swift
//
//
//  Created by Ivan Eleskin on 25.12.2022.
//

class DataHelper {
    static func splitIntIntoTwoBytes(_ value: UInt16) -> [UInt8] {
        return  [UInt8(value >> 8), UInt8(value & 0xFF)]
    }
    
    static func splitIntIntoTwoBytes(_ value: Int) -> [UInt8] {
        return  [UInt8(value >> 8), UInt8(value & 0xFF)]
    }
}
