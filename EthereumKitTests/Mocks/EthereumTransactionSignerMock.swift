//
//  EthereumTransactionSignerMock.swift
//  EthereumKitTests
//
//  Created by Jack on 14/05/2019.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

import Foundation
import BigInt
import PlatformKit
@testable import EthereumKit

class EthereumTransactionSignerMock: EthereumTransactionSignerAPI {
    var lastTransactionForSignature: EthereumTransactionCandidateCosted?
    var lastNonce: BigUInt?
    var lastKeyPair: EthereumKeyPair?
    var signTransactionResult:  Result<EthereumTransactionCandidateSigned, EthereumTransactionSignerError> = Result.failure(.incorrectChainId)
    func sign(transaction: EthereumTransactionCandidateCosted, nonce: BigUInt, keyPair: EthereumKeyPair) -> Result<EthereumTransactionCandidateSigned, EthereumTransactionSignerError> {
        lastTransactionForSignature = transaction
        lastNonce = nonce
        lastKeyPair = keyPair
        return signTransactionResult
    }
}
