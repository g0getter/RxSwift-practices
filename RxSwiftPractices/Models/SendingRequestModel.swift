//
//  SendingRequestModel.swift
//  RxSwiftPractices
//
//  Created by 여나경 on 2021/07/27.
//

import Foundation
import RxSwift

/// 비즈니스 로직 담당 모델 - 뷰모델에서 값 전달 받고 MarvelCharacter 혹은 MainPageError 리턴 
struct SendingRequestModel {
    
    func requestCharacter(id: String) -> Observable<Result<MarvelCharacter, MainPageError>> {
        
        return Observable.create { (observer) -> Disposable in
            
            if id != "" {
                observer.onNext(.success(MarvelCharacter(name: id, thumbnail: ImagePath(path: ""))))
            } else {
                observer.onNext(.failure(.defaultError))
            }
            
            observer.onCompleted()
            
            return Disposables.create()
        }
        
    }
}
