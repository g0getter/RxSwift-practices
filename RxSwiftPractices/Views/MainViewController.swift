//
//  MainViewController.swift
//  RxSwift
//
//  Created by 여나경 on 2021/07/24.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa

// TODO: 버튼 눌렀을 때 placeholder --> url 받으면 설정하도록
// (문제1) .setImage를 두 번 하고 싶지 않음
// (문제2) 하나의 변수로 설정하면, 해당 변수를 구독하지 않으면 값이 바뀌었을 때 자동으로 로드되지 않음
// --> class 안에 String type의 url 변수를 하나 설정하고 구독하는 게 가장 좋은 방법인가?

class MainViewController: UIViewController {

    @IBOutlet weak var marvelImage: UIImageView!
    @IBOutlet weak var apiButton: UIButton!
    @IBOutlet weak var responseTextView: UITextView!
    
    let mainViewModel: MainViewModel = MainViewModel()
//    // 일반적으로 사용하는 방식:
//    let mainViewModel: MainNetworkViewModelType = MainViewModel()
    
    // TODO: 위치. 함수별 로컬로?
    // View가 사라질 때 연결된 것들은 사라짐
    // view 따로 만들어서 API 호출 -> disposeBag 이후 호출 중단되는지.
    // TODO: DisposeBag 공부 + ViewModel에만 DisposeBag 넣기
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.bindViewModel()
    }
    
    func setUI() {
        apiButton.setTitle("Send a request", for: .normal)
        apiButton.setTitle("Wanna send", for: .highlighted)
        apiButton.setTitleColor(.gray, for: .highlighted)
        // TODO: rx.tap.asDriver().drive() { ///(처리) }
//        apiButton.addTarget(self, action: #selector(sendAPIRequest), for: .touchUpInside)
        // TODO: add - remove 처리( || clear)
//        apiButton.removeTarget(<#T##target: Any?##Any?#>, action: <#T##Selector?#>, for: <#T##UIControl.Event#>)
    }
    
    // TODO: 추가 작업
    func bindViewModel() {
//        // TODO: observable 정리 - 필수적인지, 위치 확정, 타입 등
//        let observable: Observable<Bool> = Observable.just(true)
//        observable.bind(to: apiButton.rx.isEnabled).disposed(by: disposeBag)
        
        // Q. DisposeBag() 함수 내 로컬 변수로? or class? >> DisposeBag 역할 공부하기
        // TODO: .drive()의 쓰임
        self.apiButton.rx.tap.asDriver().drive(onNext: {
            print("qwertyuio")
            self.sendAPIRequest()
        }).disposed(by: disposeBag)
        // TODO: bind vs. drive vs. subscribe
        // TODO: [weak self] 의미
        
        mainViewModel.outputs.mainViewOutput.bind { [weak self] character in
            guard let self = self else { return }
            // TODO: placeholder 두고 image url만 새로 설정하는 법
            let url = character.thumbnail.path + "." + character.thumbnail.extension
            self.marvelImage.kf.setImage(with: URL(string: url))
            // 여기서 placeholder를 지정하는 건 의미가 없어보임(육안으로는 교체되는 게 보이지 않음)
//            self.marvelImage.kf.setImage(
//                with: URL(string: self.url_mockup),
//                placeholder: UIImage(named: "black_widow")
//            )
        }.disposed(by: disposeBag)
        
        // !. response 사용하는데 왜 'Result of call to 'bind(onNext:)' is unused' warning 뜨는지? >> dispose 하지 않아서.
        mainViewModel.outputs.mainTextOutput.bind { [weak self] response in
            guard let self = self else { return }
            self.responseTextView.text = response
        }.disposed(by: disposeBag)
    }
    
    func sendAPIRequest() {
        responseTextView.text = "Sending.."
        
        let url_mockup = "https://lumiere-a.akamaihd.net/v1/images/image_b97b56f3.jpeg?region=0%2C0%2C540%2C810"
        
        // Set ImageView with Kingfisher
        // Image view
        marvelImage.kf.setImage(
            with: URL(string: url_mockup),
            placeholder: UIImage(named: "black_widow")
        )
        
        mainViewModel.requestMarvelAPI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
