//
//  MainViewModel.swift
//  RxSwiftPractices
//
//  Created by 여나경 on 2021/07/27.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

import UIKit
import Kingfisher

// ✅TODO: private --> 필요하면 private 빼기
// 접근제어자 - 빌드 시간에도 영향.
// private 하면 안됨.
protocol MainViewModelOutput {
    // ✅TODO: naming - output for Character
    var mainViewCharacterOutput: PublishSubject<MarvelCharacter> { get }
    var mainTextOutput: PublishSubject<String> { get }
}

protocol MainNetworkViewModelType {
    var outputs: MainViewModelOutput {get}
}

// TODO: 왜 final class?
// TODO: I/O protocol 만들고 구현
final class MainViewModel: MainViewModelOutput, MainNetworkViewModelType {
    // ✅TODO: 상수별 let/var 결정
    let mainViewCharacterOutput: PublishSubject<MarvelCharacter> = PublishSubject<MarvelCharacter>()
    let mainTextOutput: PublishSubject<String> = PublishSubject<String>()
    
    var outputs: MainViewModelOutput { return self }
    
    let disposeBag = DisposeBag()
    
    /// Button이 클릭된 시점을 전달하기 위함 (View -> ViewModel)
    let buttonTouched = PublishRelay<Void>()
    
    // ✅TODO: 구현 -> 필요 없음. 왜냐면 onNext 인자로 넘겨줄 것이 없으므로.
    init() {
        self.buttonTouched.asObservable().bind{}.disposed(by: disposeBag) // 후행클로저인데 리턴값이 void
        // 동일한 구문: self.buttonTouched.asObservable().bind(onNext: {}).disposed(by: disposeBag)
    }
    
    func requestMarvelAPI() {        
        marvelProvider.rx.request(.character).subscribe { (event) in
            switch event {
            case .success(let response):
                // response가 character 한 개일 경우
                if let marvelChar = self.parseACharacter(json: response.data) {
                    self.outputs.mainViewCharacterOutput.on(.next(marvelChar))
                    self.outputs.mainTextOutput.on(.next(String(decoding: response.data, as: UTF8.self)))
                } else {
                    // Parsing 실패
                    print("Response는 정상이나 parsing 실패")
                }
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
    
    // (🤔보완할 catch 처리?)(✅)TODO: try - catch(Json decode 실패 시 처리) + 발생하는 익셉션 종류별 처리(parsing 안되는 경우)
    // 알아보기: Moya - objectMap으로 .error 처럼 처리 가능
    /// `json`이 character 여러 개일 경우 사용하는 parser
    func parse(json: Data) -> [MarvelCharacter]? {
        // ✅TODO: Optional 처리
        var characters: [MarvelCharacter]?
        do {
            let jsonCharacter = try JSONDecoder().decode(CharacterDataWrapper.self, from: json)
            characters = jsonCharacter.data.results
            print("Title: \(characters?.last?.name ?? "")")
            print("Thumbnail path: \(characters?.last?.thumbnail.path ?? "")")
            print("Thumbnail extension: \(characters?.last?.thumbnail.extension ?? "")")
        } catch {
            print("\(error)")
        }
        
        return characters
    }
    
    /// `json`이 character 하나일 경우 사용하는 parser
    func parseACharacter(json: Data) -> MarvelCharacter? {
        // ✅TODO: 하나 뽑는 걸 어디서 뽑을 지. 받을 때 .first 해서 parser에서 하나인 것 반환
        // --> limit=1로 수정하기
        // ✅TODO: Optional 처리
        var oneCharacter: MarvelCharacter?
        do {
            let jsonCharacter = try JSONDecoder().decode(CharacterDataWrapper.self, from: json)
            oneCharacter = jsonCharacter.data.results.first
            if jsonCharacter.data.results.count != 1 {
                print("Received characters are plural")
                return nil
            }
            print("Title: \(oneCharacter?.name ?? "")")
            print("Thumbnail path: \(oneCharacter?.thumbnail.path ?? "")")
            print("Thumbnail extension: \(oneCharacter?.thumbnail.extension ?? "")")
        } catch {
            print("\(error)")
        }
        
        return oneCharacter
    }
}
