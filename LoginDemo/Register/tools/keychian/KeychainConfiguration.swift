//
//  BDKeychainConfiguration.swift
//  greatwall
//
//  Created by 刘恒 on 2019/4/25.
//  Copyright © 2019 dada. All rights reserved.
//

import Foundation

struct BDKeychainConfiguration {
    static let serviceName = "com.dada.bd"
    
    static let accessGroup = "4K46345F2F." + serviceName
    
    //iCloud
    static let bSecAttrSynchronizable : CFBoolean = kCFBooleanFalse
}
