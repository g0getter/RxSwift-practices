//
//  MainViewController.swift
//  RxSwiftPractices
//
//  Created by 여나경 on 2021/09/12.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {

    let disposeBag = DisposeBag()
    @IBOutlet weak var goToOneCharacter: UIButton!
    @IBOutlet weak var goToCharacterColecciones: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        goToOneCharacter.rx.tap.asDriver().drive(onNext: {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "oneCharacter") as? OneCharacterViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        goToCharacterColecciones.rx.tap.asDriver().drive(onNext: {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "characters") as? CharactersViewController else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
    }
}
