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
        apiButton.addTarget(self, action: #selector(sendAPIRequest), for: .touchUpInside)
        // TODO: add - remove 처리( || clear)
//        apiButton.removeTarget(<#T##target: Any?##Any?#>, action: <#T##Selector?#>, for: <#T##UIControl.Event#>)
    }
    
    // TODO: 추가 작업
    func bindViewModel() {
//        // TODO: observable 정리 - 필수적인지, 위치 확정, 타입 등
//        let observable: Observable<Bool> = Observable.just(true)
//        observable.bind(to: apiButton.rx.isEnabled).disposed(by: disposeBag)
        
        // Q. DisposeBag() 함수 내 로컬 변수로? or class?
        // TODO: .drive()의 쓰임
        self.apiButton.rx.tap.asDriver().drive(onNext: {
            print("qwertyuio")
        }).disposed(by: disposeBag)
        // TODO: bind vs. drive vs. subscribe
        // TODO: [weak self] 의미
        
        mainViewModel.outputs.mainViewOutput.bind { [weak self] character in
            guard let self = self else { return }
            // TODO: placeholder 두고 image url만 새로 설정하는 법
            let url = character.thumbnail.path + "."+character.thumbnail.extension
            self.marvelImage.kf.setImage(with: URL(string: url))
        }.disposed(by: disposeBag)
        
        mainViewModel.outputs.mainViewOutput.asObservable()
    }
    
    @objc func sendAPIRequest() {
        responseTextView.text = "Sending"
        
        // Set ImageView with Kingfisher
        // TODO: Replace url_mockup with real image url
        let url_mockup = "https://lumiere-a.akamaihd.net/v1/images/image_b97b56f3.jpeg?region=0%2C0%2C540%2C810"
        
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
