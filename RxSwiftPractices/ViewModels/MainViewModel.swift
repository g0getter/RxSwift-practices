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

protocol MainViewModelOutput {
    // TODO: naming - output for what?
    var mainViewOutput: PublishSubject<MarvelCharacter> { get }
}

// TODO: 왜 final class?
// TODO: I/O protocol 만들고 구현
final class MainViewModel: MainViewModelOutput {
    // TODO: 상수별 let/var 결정
    // TODO: 무슨 역할?
    var mainViewOutput: PublishSubject<MarvelCharacter> = .init()
    
    
//    var marvelProvider = MoyaProvider<MarvelTargetType>()
    var disposeBag = DisposeBag()
    
    
    /// Button이 클릭된 시점을 전달하기 위함 (View -> ViewModel)
    var buttonTouched = PublishRelay<Void>()
    
    // TODO: Optional(result를 받는 데 실패했을 수 있으므로) 맞는지
    /// ViewModel에서(ViewModel이 View와 통신 후) 받은 결과값을 View에 전달하기 위함 (ViewModel --> View)
    var result: Signal<Result<MarvelCharacter, MainPageError>>?
    
//    init(model: SendingRequestModel = SendingRequestModel()) {
//        result = buttonTouched
//            .withLatestFrom(Observable.combineLatest(""))
//            .flatMapLatest { model.requestCharacter(id: "")}
//            .asSignal(onErrorJustReturn: .failure(.defaultError))
//    }
    // TODO: 구현
    init() {
//        self.buttonTouched.asObservable().bind{ [weak self] data in
//            guard let self = self else { return }
////            self.mainViewOutput.onNext(data)
//        }.disposed(by: disposeBag)
        self.buttonTouched.asObservable().bind(onNext: {}).disposed(by: disposeBag)
//        self.result = nil
    }
    
    func requestMarvelAPI() {
        let marvelProvider = MoyaProvider<MarvelTargetType>()
        
        marvelProvider.rx.request(.character).subscribe { (event) in
            switch event {
            case .success(let response):
                self.parse(json: response.data)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
    
    // TODO: try - catch(Json decode 실패 시 처리) + 발생하는 익셉션 종류별 처리(parsing 안되는 경우)
    // 알아보기: Moya - objectMap으로 .error 처럼 처리 가능
    func parse(json: Data) {
        // TODO: 하나 뽑는 걸 어디서 뽑을 지. 받을 때 or 배열로 받고 .first
        // TODO: Optional 처리
        var characters: [MarvelCharacter]?
        if let jsonCharacter = try? JSONDecoder().decode(CharacterDataWrapper.self, from: json) {
            characters = jsonCharacter.data.results
            print("Title: \(characters?.last?.name ?? "")")
            print("Thumbnail path: \(characters?.last?.thumbnail.path ?? "")")
        }
    }

}
