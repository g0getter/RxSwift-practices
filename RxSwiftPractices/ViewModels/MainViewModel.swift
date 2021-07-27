//
//  MainViewModel.swift
//  RxSwiftPractices
//
//  Created by 여나경 on 2021/07/27.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel {
    /// Button이 클릭된 시점을 전달하기 위함 (View -> ViewModel)
    let buttonTouched = PublishRelay<Void>()
    
    /// ViewModel에서(ViewModel이 View와 통신 후) 받은 결과값을 View에 전달하기 위함 (ViewModel --> View)
    let result: Signal<Result<MarvelCharacter, MainPageError>>
    
//    init(model: SendingRequestModel = SendingRequestModel()) {
//        result = buttonTouched
//            .withLatestFrom(Observable.combineLatest(""))
//            .flatMapLatest { model.requestCharacter(id: "")}
//            .asSignal(onErrorJustReturn: .failure(.defaultError))
//    }
}
