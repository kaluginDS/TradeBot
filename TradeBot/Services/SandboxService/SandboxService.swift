//
//  SandboxService.swift
//  TradeBot
//
//  Created by Денис Калугин on 15.05.2022.
//

import Combine
import GRPC
import CombineGRPC
import TinkoffInvestSDK

public protocol SandboxService {
    func openSandboxAccount() -> AnyPublisher<OpenSandboxAccountResponse, RPCError>
}

final class GRPCSandboxService: BaseCombineGRPCService, SandboxService {

    private lazy var client = UsersServiceClient(channel: channel)

    // MARK: - SandboxService


}
