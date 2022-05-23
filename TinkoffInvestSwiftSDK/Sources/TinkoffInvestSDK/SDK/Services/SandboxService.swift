//
//  SandboxService.swift
//  TradeBot
//
//  Created by Денис Калугин on 15.05.2022.
//

import Combine
import GRPC
import CombineGRPC

public protocol SandboxService {
    func openSandboxAccount() -> AnyPublisher<OpenSandboxAccountResponse, RPCError>
    func getSandboxAccounts() -> AnyPublisher<GetAccountsResponse, RPCError>
    func closeSandboxAccount(accountID: String) -> AnyPublisher<CloseSandboxAccountResponse, RPCError>
    func postSandboxOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError>
    func getSandboxOrders(accountID: String) -> AnyPublisher<GetOrdersResponse, RPCError>
    func cancelSandboxOrder(accountID: String, orderID: String) -> AnyPublisher<CancelOrderResponse, RPCError>
    func getSandboxOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError>
    func getSandboxPositions(accountID: String) -> AnyPublisher<PositionsResponse, RPCError>
    func getSandboxOperations(request: OperationsRequest) -> AnyPublisher<OperationsResponse, RPCError>
    func getSandboxPortfolio(accountID: String) -> AnyPublisher<PortfolioResponse, RPCError>
    func sandboxPayIn(accountID: String, amount: MoneyValue) -> AnyPublisher<SandboxPayInResponse, RPCError>
}

final class GRPCSandboxService: BaseCombineGRPCService, SandboxService {

    private lazy var client = SandboxServiceClient(channel: channel)

    // MARK: - SandboxService

    func openSandboxAccount() -> AnyPublisher<OpenSandboxAccountResponse, RPCError> {
        return executor.call(client.openSandboxAccount)(OpenSandboxAccountRequest())
    }

    func getSandboxAccounts() -> AnyPublisher<GetAccountsResponse, RPCError> {
        return executor.call(client.getSandboxAccounts)(GetAccountsRequest())
    }

    func closeSandboxAccount(accountID: String) -> AnyPublisher<CloseSandboxAccountResponse, RPCError> {
        var request = CloseSandboxAccountRequest()
        request.accountID = accountID
        return executor.call(client.closeSandboxAccount)(request)
    }

    func postSandboxOrder(request: PostOrderRequest) -> AnyPublisher<PostOrderResponse, RPCError> {
        return executor.call(client.postSandboxOrder)(request)
    }

    func getSandboxOrders(accountID: String) -> AnyPublisher<GetOrdersResponse, RPCError> {
        var request = GetOrdersRequest()
        request.accountID = accountID
        return executor.call(client.getSandboxOrders)(request)
    }

    func cancelSandboxOrder(accountID: String, orderID: String) -> AnyPublisher<CancelOrderResponse, RPCError> {
        var request = CancelOrderRequest()
        request.accountID = accountID
        request.orderID = orderID
        return executor.call(client.cancelSandboxOrder)(request)
    }

    func getSandboxOrderState(accountID: String, orderID: String) -> AnyPublisher<OrderState, RPCError> {
        var request = GetOrderStateRequest()
        request.accountID = accountID
        request.orderID = orderID
        return executor.call(client.getSandboxOrderState)(request)
    }

    func getSandboxPositions(accountID: String) -> AnyPublisher<PositionsResponse, RPCError> {
        var request = PositionsRequest()
        request.accountID = accountID
        return executor.call(client.getSandboxPositions)(request)
    }

    func getSandboxOperations(request: OperationsRequest) -> AnyPublisher<OperationsResponse, RPCError> {
        return executor.call(client.getSandboxOperations)(request)
    }

    func getSandboxPortfolio(accountID: String) -> AnyPublisher<PortfolioResponse, RPCError> {
        var request = PortfolioRequest()
        request.accountID = accountID
        return executor.call(client.getSandboxPortfolio)(request)
    }

    func sandboxPayIn(accountID: String, amount: MoneyValue) -> AnyPublisher<SandboxPayInResponse, RPCError> {
        var request = SandboxPayInRequest()
        request.accountID = accountID
        request.amount = amount
        return executor.call(client.sandboxPayIn)(request)
    }
}
