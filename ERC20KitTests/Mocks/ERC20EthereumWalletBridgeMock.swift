//
//  EthereumWalletBridgeMock.swift
//  ERC20KitTests
//
//  Created by Jack on 23/04/2019.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

import RxSwift
import RxRelay
import BigInt
import PlatformKit
import EthereumKit
@testable import ERC20Kit

class ERC20EthereumWalletBridgeMock: EthereumWalletBridgeAPI {
    var fetchHistoryValue = Single.just(())
    var fetchHistory: Single<Void> {
        return fetchHistoryValue
    }
    
    var fetchHistoryIfNeededValue = Single.just(())
    var fetchHistoryIfNeeded: Single<Void> {
        return fetchHistoryIfNeededValue
    }
    
    var balanceValue = Single.just(CryptoValue.paxFromMajor(string: "2.0")!)
    var balance: Single<CryptoValue> {
        return balanceValue
    }
    
    var balanceObservable: Observable<CryptoValue> {
        return balance.asObservable()
    }
    let balanceFetchTriggerRelay = PublishRelay<Void>()
        
    var nameValue: Single<String> = Single.just("")
    var name: Single<String> {
        return nameValue
    }
    
    var addressValue: Single<String> = Single.just("")
    var address: Single<String> {
        return addressValue
    }
    
    var transactionsValue: Single<[EthereumHistoricalTransaction]> = Single.just([])
    var transactions: Single<[EthereumHistoricalTransaction]> {
        return transactionsValue
    }
    
    static let assetAccount = EthereumAssetAccount(walletIndex: 0, accountAddress: "", name: "")
    var accountValue: Single<EthereumAssetAccount> = Single.just(assetAccount)
    var account: Single<EthereumAssetAccount> {
        return accountValue
    }
    
    var nonceValue = Single.just(BigUInt(1))
    var nonce: Single<BigUInt> {
        return nonceValue
    }
    
    var isWaitingOnEtherTransactionValue = Single.just(true)
    var isWaitingOnEtherTransaction: Single<Bool> {
        return isWaitingOnEtherTransactionValue
    }
    
    var recordLastTransactionValue = Single<EthereumTransactionPublished>.error(EthereumKitError.unknown)
    func recordLast(transaction: EthereumTransactionPublished) -> Single<EthereumTransactionPublished> {
        return recordLastTransactionValue
    }
}
