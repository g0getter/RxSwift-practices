//
//  CharactersViewModel.swift
//  RxSwiftPractices
//
//  Created by 여나경 on 2021/09/12.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

import UIKit
import Kingfisher

protocol CharactersViewModelInput {
}

protocol CharactersViewModelOutput {
    var marvelCharactersData: PublishSubject<[MarvelCharacter]> { get }
}

protocol CharactersViewModelType {
    var inputs: CharactersViewModelInput { get }
    var outputs: CharactersViewModelOutput { get }
}

// TODO: 왜 final class?
final class CharactersViewModel: CharactersViewModelType, CharactersViewModelInput, CharactersViewModelOutput {
    // 불필요. 상속 위해 추가한 껍데기(?🤔)
    var inputs: CharactersViewModelInput { self }
    var outputs: CharactersViewModelOutput { self }
    
    var marvelCharactersData = PublishSubject<[MarvelCharacter]>()
     
    let disposeBag = DisposeBag()
    
    /// Button이 클릭된 시점을 전달하기 위함 (View -> ViewModel)
    let buttonTouched = PublishRelay<Void>()
    
    init() {
        self.buttonTouched.asObservable().bind{}.disposed(by: disposeBag) // 후행클로저인데 리턴값이 void
        // 동일한 구문: self.buttonTouched.asObservable().bind(onNext: {}).disposed(by: disposeBag)
    }
    
    func requestMarvelAPI() {
        marvelProvider.rx.request(.characters).subscribe { (event) in
            switch event {
            case .success(let response):
                if let marvelChars = self.parse(json: response.data) {
                    self.outputs.marvelCharactersData.on(.next(marvelChars))
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
    
}
