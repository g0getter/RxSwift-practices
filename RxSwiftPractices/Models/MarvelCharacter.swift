//
//  MarvelCharacter.swift
//  RxSwiftPractices
//
//  Created by 여나경 on 2021/07/27.
//

import Foundation

// TODO: Optional 설정
// Codable + init()으로 변조
// json parsing plugin - 찾아보기
struct CharacterDataWrapper: Codable {
    var data: CharacterDataContainer
}

struct CharacterDataContainer: Codable {
    var results: [MarvelCharacter]
}

struct MarvelCharacter: Codable {
    var name: String
    var thumbnail: ImagePath
}

struct ImagePath: Codable {
    var path: String
    var `extension`: String
}

// TODO: 적절한 위치 찾기
enum MainPageError: Error {
    case defaultError
    case error(code: Int)
    
    var msg: String {
        switch  self  {
        case .defaultError:
            return "ERROR"
        case .error(let code):
            return "\(code) Error"
        }
    }
}