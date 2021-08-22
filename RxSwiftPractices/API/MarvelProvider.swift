//
//  MarvelProvider.swift
//  RxSwiftPractices
//
//  Created by 여나경 on 2021/08/01.
//

import Foundation
import CryptoKit
import CommonCrypto
import Moya

// TODO: limit 1

enum MarvelTargetType {
    case character
    
    static private let publicKey = "3c4dcb91653adab861890dee461e955f"
    static private let privateKey = "f0e43ec4a198e99634388c129739ca605ac217b9"
    
}
extension MarvelTargetType: TargetType {
    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com/v1/public")!
    }
    
    var path: String {
        switch self {
        case .character: return "/characters"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .character: return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        let ts = Date()
        let stringToHash: String = "\(ts)" + MarvelTargetType.privateKey + MarvelTargetType.publicKey
        let hash = Insecure.MD5.hash(data: stringToHash.data(using: .utf8)!)
        // TODO: 의미 알기
        let hashHex =  hash.map { String(format: "%02hhx", $0) }.joined()
        
        return .requestParameters(parameters: ["ts":ts, "apikey": MarvelTargetType.publicKey, "hash": hashHex], encoding: URLEncoding.queryString) // TODO
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    // 7
    public var validationType: ValidationType {
        return .successCodes
    }
}

// (✅)🤔TODO: 위치 맞는지 확인(Provider or ViewModel)
let marvelProvider = MoyaProvider<MarvelTargetType>()
