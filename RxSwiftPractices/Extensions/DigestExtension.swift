//
//  DigestExtension.swift
//  RxSwiftPractices
//
//  Created by 여나경 on 2021/08/24.
//

import Foundation
import CryptoKit

extension Digest {
    /// 두 자리의 hexadecimal로 표현되는 unsigned integer를 이어붙임
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

