//
//  GlobalConstants.swift
//  TradeBot
//
//  Created by Денис Калугин on 09.05.2022.
//

import TinkoffInvestSDK

enum GlobalConstants {
    static let sandboxToken = "t.Ik1oUtsu2JWrWBrbrxpHI6ieZMmqMAPH3aoiGh9aM3giz9h0PcIrLy6tn_zpCBcwL4LB44XvND9uHwR2gS7USg"
    static let figi: String = "BBG000HLJ7M4"
    static let exchange: String = "SPB"
    static let interval: CandleInterval = .candleInterval1Min
    static let quantity: Int = 1
}
