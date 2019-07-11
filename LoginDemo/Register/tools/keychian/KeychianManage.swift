//
//  BDKeychianManage.swift
//  greatwall
//
//  Created by 刘恒 on 2019/4/25.
//  Copyright © 2019 dada. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case lackAttributes
    case infoEmpty
    case unexpectedData
    case unhandledError(status: OSStatus)
}

class KeychianManage {
    
    /// Get Token Of Current Account
    ///
    /// - Parameter account: <#account description#>
    /// - Returns: Token
    /// - Throws: KeychainError
    public class func fetchAllToken()throws -> [String:String]  {
        do {
            return try KeychianQuery.fetchAllKeychainData()
        } catch {
            throw error}
    }
    
    /// Get Token Of Current Account
    ///
    /// - Parameter account: <#account description#>
    /// - Returns: Token
    /// - Throws: KeychainError
    public class func fetchCurrentToken(_ account:String)throws -> String?  {
        do {
            return try KeychianQuery.fetchKeychainData(account: account)
        } catch {
            throw error}
    }

    
    /// Update Token Of Existed Account
    ///
    /// - Parameters:
    ///   - Token_: <#Token_ description#>
    ///   - account_: <#account_ description#>
    /// - Throws: KeychainError
    public class func saveAccoutToken(_ account_:String, token_:String)throws {
        do {
            try KeychianQuery.saveKeychainData(account: account_, accoutInfo: token_)
        } catch {
            throw error}
    }
    

    /// Delete Token Of Existed Account
    ///
    /// - Parameter account_: <#account_ description#>
    /// - Throws: KeychainError
    public class func deleteAccoutInfo(_ account_:String)throws {
        do {
            try KeychianQuery.deleteKeychainData(account: account_)
        } catch {
            throw error}
    }
    
    /// Delete All Token
    ///
    /// - Throws: KeychainError
    public class func deleteAllAccoutInfo()throws {
        do {
            try KeychianQuery.deleteAllKeychainData()
        } catch {
            throw error}
    }
}

