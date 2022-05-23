//
//  MainInteractor.swift
//  TradeBot
//
//  Created by Денис Калугин on 09.05.2022.
//

import TinkoffInvestSDK
import Combine
import SwiftProtobuf
import Foundation

final class MainInteractor {
    // MARK: - Properties

    weak var output: MainInteractorOutput!

    // MARK: - Private properties

    private var cancellables = Set<AnyCancellable>()
    private var tinkoffSDK: TinkoffInvestSDK?

    // MARK: - Constants

    private enum Constants {

    }

    // MARK: - Func

    // MARK: - Private func
}

// MARK: - MainInteractorInput

extension MainInteractor: MainInteractorInput {

//    func setToken() {
//        let tokenProvider = DefaultTokenProvider(token: AppDataService.shared.token)
//        tinkoffSDK = TinkoffInvestSDK(tokenProvider: tokenProvider)
//    }

    func getShares() {
        weak var weakSelf = self

        tinkoffSDK?.instrumentsService.getShares(with: .base).sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("getShares finished")
                case .failure(let error):
                    weakSelf?.output.getSharesFail(error: error)
                }
            },
            receiveValue: { response in
                weakSelf?.output.getSharesSuccess(response: response)
            }
        ).store(in: &cancellables)
    }

    func getSandboxAccounts() {
        let tokenProvider = DefaultTokenProvider(token: AppDataService.shared.token)
        tinkoffSDK = TinkoffInvestSDK(tokenProvider: tokenProvider)
        
        weak var weakSelf = self

        tinkoffSDK?.sandboxService.getSandboxAccounts().sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("getSandboxAccounts finished")
                case .failure(let error):
                    DispatchQueue.main.async(execute: {
                        weakSelf?.output.getSandboxAccountsFail(error: error)
                    })
                }
            },
            receiveValue: { response in
                DispatchQueue.main.async(execute: {
                    weakSelf?.output.getSandboxAccountsSuccess(response: response)
                })
            }
        ).store(in: &cancellables)
    }
}
