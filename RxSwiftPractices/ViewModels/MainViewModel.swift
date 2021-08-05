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

// TODO: private --> 필요하면 private 빼기
// 접근제어자 - 빌드 시간에도 영향.
protocol MainViewModelOutput {
    // TODO: naming - output for what?
    var mainViewOutput: PublishSubject<MarvelCharacter> { get }
}

protocol MainNetworkViewModelType {
//    var inputs: Account1WonNetworkViewModelInput {get}
    var outputs: MainViewModelOutput {get}
}

// TODO: 왜 final class?
// TODO: I/O protocol 만들고 구현
final class MainViewModel: MainViewModelOutput, MainNetworkViewModelType {
    // TODO: 상수별 let/var 결정
    var mainViewOutput: PublishSubject<MarvelCharacter> = PublishSubject<MarvelCharacter>()
    
    var outputs: MainViewModelOutput { return self }
    
    var disposeBag = DisposeBag()
    
    /// Button이 클릭된 시점을 전달하기 위함 (View -> ViewModel)
    var buttonTouched = PublishRelay<Void>()
    
    // TODO: Optional(result를 받는 데 실패했을 수 있으므로) 맞는지
    /// ViewModel에서(ViewModel이 View와 통신 후) 받은 결과값을 View에 전달하기 위함 (ViewModel --> View)
    var result: Signal<Result<MarvelCharacter, MainPageError>>?
    
    // TODO: 구현
    init() {
//        self.buttonTouched.asObservable().bind{ [weak self] data in
//            guard let self = self else { return }
////            self.mainViewOutput.onNext(data)
//        }.disposed(by: disposeBag)
        self.buttonTouched.asObservable().bind(onNext: {}).disposed(by: disposeBag)
        
    }
    
    func requestMarvelAPI() {        
        marvelProvider.rx.request(.character).subscribe { (event) in
            switch event {
            case .success(let response):
                if let marvelChar = self.parse(json: response.data) {
                    // TODO: 예외 처리(길이 0일 떄?)
                    // if let, guard let
                    // 가독성(길이)
                    self.outputs.mainViewOutput.on(.next(marvelChar.first ?? MarvelCharacter(name: "ERROR", thumbnail: ImagePath(path: "", extension: "")))) // 하나만 넘김!
                }
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
    
    // TODO: try - catch(Json decode 실패 시 처리) + 발생하는 익셉션 종류별 처리(parsing 안되는 경우)
    // 알아보기: Moya - objectMap으로 .error 처럼 처리 가능
    func parse(json: Data) -> [MarvelCharacter]? {
        // TODO: 하나 뽑는 걸 어디서 뽑을 지. 받을 때 or 배열로 받고 .first
        // TODO: Optional 처리
        var characters: [MarvelCharacter]?
        if let jsonCharacter = try? JSONDecoder().decode(CharacterDataWrapper.self, from: json) {
            characters = jsonCharacter.data.results
            print("Title: \(characters?.last?.name ?? "")")
            print("Thumbnail path: \(characters?.last?.thumbnail.path ?? "")")
            print("Thumbnail extension: \(characters?.last?.thumbnail.extension ?? "")")
        }
        return characters
    }
}
