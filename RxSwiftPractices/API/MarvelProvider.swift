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

// ✅TODO: limit 1

enum MarvelTargetType {
    case character // dictionary 받아서 task에는 덩어리째로 넣기
    
    static private let publicKey = "3c4dcb91653adab861890dee461e955f"
    static private let privateKey = "f0e43ec4a198e99634388c129739ca605ac217b9"
    
}
extension MarvelTargetType: TargetType {
    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com/v1/public")!
    }
    
    var path: String {
        switch self {
        case .character: return "/characters" // ✅여기에 limit=1 넣으면 response code 404 뜸.
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
        // ✅TODO: 의미? Convert Digest type to hex String
        // hash의 값들을 하나씩 클로저 안에 넣어서 string을 만드는데, string의 형태는 unsigned 32-bit integer를 hex로 표현하되 숫자 2자리로 표현.
        let hashHex = hash.hexEncodedString()
        
        // .requestParameters에 넣어야 함. 말 그대로 request할 때 넣는 parameter.
        return .requestParameters(parameters: ["ts":ts, "apikey": MarvelTargetType.publicKey, "hash": hashHex, "limit": "1"], encoding: URLEncoding.queryString) // TODO
        // method가 POST이면 encoding 다르게
        // TASK 들어가서 보기
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    // 7
    public var validationType: ValidationType {
        return .successCodes
    }
}

// ✅TODO: 위치 맞는지 확인(Provider or ViewModel)
let marvelProvider = MoyaProvider<MarvelTargetType>()

