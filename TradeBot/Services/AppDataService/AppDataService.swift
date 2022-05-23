//
//  AppDataService.swift
//  TradeBot
//
//  Created by Денис Калугин on 21.05.2022.
//

import Foundation

enum TokenType: String {
    case test = "Тест"
    case prod = "Бой"
}

final class AppDataService {
    // MARK: - Properties

    static let shared: AppDataService = AppDataService()

    var token: String {
        switch tokenType {
        case .test:
            return testToken
        case .prod:
            return prodToken
        }
    }

    var testToken: String {
        set {
            userDefaults.set(newValue, forKey: Constants.Keys.testToken)
        }
        get {
            return userDefaults.string(forKey: Constants.Keys.testToken) ?? .empty
        }
    }

    var prodToken: String {
        set {
            userDefaults.set(newValue, forKey: Constants.Keys.token)
        }
        get {
            return userDefaults.string(forKey: Constants.Keys.token) ?? .empty
        }
    }

    var tokenType: TokenType {
        set {
            userDefaults.set(newValue.rawValue, forKey: Constants.Keys.tokenType)
        }
        get {
            let string: String = userDefaults.string(forKey: Constants.Keys.tokenType) ?? .empty
            let result: TokenType = TokenType(rawValue: string) ?? .test
            return result
        }
    }

    // MARK: - Private properties

    private let userDefaults: UserDefaults = UserDefaults.standard

    // MARK: - Constants

    private enum Constants {
        enum Keys {
            static let testToken: String = "testToken"
            static let token: String = "token"
            static let tokenType: String = "tokenType"
        }
    }

    // MARK: - Func

    // MARK: - Private func

    private init() {

    }
}
