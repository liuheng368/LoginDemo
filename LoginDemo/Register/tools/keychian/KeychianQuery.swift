//
//  BDKeychianQuery.swift
//  greatwall
//
//  Created by 刘恒 on 2019/4/25.
//  Copyright © 2019 dada. All rights reserved.
//

import Foundation

struct KeychianQuery {
    
    
    /// fetch all accout
    ///
    /// - Returns: <#return value description#>
    /// - Throws: <#throws value description#>
    @discardableResult
    static func fetchAllKeychainData()throws -> [String:String] {
        var query = KeychianQuery.keychainQuery(account: nil)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))}
        
        guard status != errSecItemNotFound else {
            throw KeychainError.infoEmpty}
        guard status == noErr else {
            throw KeychainError.unhandledError(status: status)}
        
        guard let result = queryResult as? [[String : Any]]else{
            throw KeychainError.unexpectedData}
        
        var passwordItems = [String:String]()
        for dicResult in result {
            guard
                let key = dicResult[kSecAttrAccount as String] as? String,
                let data = dicResult[kSecValueData as String] as? Data,
                let strAccoutInfo = String(bytes: data, encoding: String.Encoding.utf8)
                else{throw KeychainError.unexpectedData}
            passwordItems[key] = strAccoutInfo
        }
        return passwordItems
    }
    
    /// fetch an accout
    ///
    /// - Parameters:
    ///   - service: <#service description#>
    ///   - account: <#account description#>
    ///   - accessGroup: <#accessGroup description#>
    ///   - secAttrSynchronizable: whether to open the iCloud
    /// - Returns: accoutInfo
    /// - Throws: <#throws value description#>
    @discardableResult
    static func fetchKeychainData(account: String)throws -> String? {
        guard account.count > 0 else {throw KeychainError.lackAttributes}
        
        var query = KeychianQuery.keychainQuery(account: account)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))}

        guard status != errSecItemNotFound else {
            return nil}
        guard status == noErr else {
            throw KeychainError.unhandledError(status: status)}
        
        guard let result = queryResult as? [String : AnyObject]else{
            throw KeychainError.unexpectedData}
        
        guard let data = result[kSecValueData as String],
            let data_ = data as? Data,
            let strAccoutInfo = String(bytes: data_, encoding: String.Encoding.utf8) else {
            return nil}
        
        return strAccoutInfo
    }
    
    /// set & update an accout
    ///
    /// - Parameters:
    ///   - accoutInfo: <#accoutInfo description#>
    ///   - service: <#service description#>
    ///   - account: <#account description#>
    ///   - accessGroup: <#accessGroup description#>
    ///   - secAttrSynchronizable: <#secAttrSynchronizable description#>
    /// - Throws: <#throws value description#>
    static func saveKeychainData(account: String, accoutInfo: String)throws {
        guard account.count > 0 else {throw KeychainError.lackAttributes}
        
        var query = KeychianQuery.keychainQuery(account: account)
        guard let data = accoutInfo.data(using: String.Encoding.utf8) else {
            print(accoutInfo)
           throw KeychainError.unexpectedData}
        
        let attributes : [String : AnyObject] = [kSecValueData as String : data as AnyObject]
        do {
            try fetchKeychainData(account: account)
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)}
        } catch KeychainError.infoEmpty {
            query[kSecValueData as String] = data as AnyObject?
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)}
        }
    }
    
    
    /// delete accout
    ///
    /// - Parameters:
    ///   - service: <#service description#>
    ///   - account: <#account description#>
    ///   - accessGroup: <#accessGroup description#>
    ///   - secAttrSynchronizable: <#secAttrSynchronizable description#>
    /// - Throws: <#throws value description#>
    static func deleteKeychainData(account: String)throws {
        guard account.count > 0 else {throw KeychainError.lackAttributes}
        
        let query = KeychianQuery.keychainQuery(account: account)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else{
          throw KeychainError.unhandledError(status: status)}
    }
    
    /// delete all accout
    ///
    /// - Parameters:
    ///   - service: <#service description#>
    ///   - account: <#account description#>
    ///   - accessGroup: <#accessGroup description#>
    ///   - secAttrSynchronizable: <#secAttrSynchronizable description#>
    /// - Throws: <#throws value description#>
    static func deleteAllKeychainData()throws {
        let query = KeychianQuery.keychainQuery(account: nil)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else{
            throw KeychainError.unhandledError(status: status)}
    }
}

extension KeychianQuery{
    /// private tools
    ///
    /// - Parameters:
    ///   - service: <#service description#>
    ///   - account: <#account description#>
    ///   - accessGroup: <#accessGroup description#>
    ///   - secAttrSynchronizable: iCloud
    /// - Returns: <#return value description#>
    private static func keychainQuery(account: String?) -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecAttrAccessGroup as String] =
            BDKeychainConfiguration.accessGroup as AnyObject
        query[kSecAttrSynchronizable as String] =
            BDKeychainConfiguration.bSecAttrSynchronizable  as AnyObject
        query[kSecAttrService as String] =
            BDKeychainConfiguration.serviceName as AnyObject
        query[kSecClass as String] = kSecClassGenericPassword
        if let accout = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        return query
    }
}
