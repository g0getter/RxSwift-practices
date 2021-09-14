//
//  CharactersViewController.swift
//  RxSwiftPractices
//
//  Created by 여나경 on 2021/09/12.
//

import UIKit
import RxSwift
import Kingfisher

// 주의: UIViewController에서 UITableView 구현하려면 UITableViewDelegate, UITableViewDataSource
class CharactersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // TODO: Make tableView with detailed information
    // Tableview - without storyboard!
    /// Main tableView
    var tableView = UITableView()
    let disposeBag = DisposeBag()
    
    let charactersViewModel: CharactersViewModelType = CharactersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(tableView) // TODO: 비슷한 게 필요해보임.
        requestCharacters()
        setUI()
        setTableView()
        bindViewModel()
    }
    
    private func requestCharacters() {
        // 🤔TODO: 맞는지 확인.
        (charactersViewModel as? CharactersViewModel)?.requestMarvelAPI()
    }
    
    private func setUI() {
        self.title = "Marvel Characters"
    }
    
    /// Sets up `tableView`
    private func setTableView() {
        tableView.backgroundColor = .blue
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "keywordCell")
    }
    
    private func bindViewModel() {
        charactersViewModel.outputs.marvelCharactersData.bind { [weak self] characters in
            guard let self = self else { return }
            // TODO: tableView를 response를 이용해 채움
            
        }.disposed(by: disposeBag)
    }
    
    // TODO: tableView 정의하는 함수
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 🤔tableView(내장) vs. tableView(class의)
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as! CharacterCell

//        cell.characterImage?.im = UIImage(named: keywordImage[(indexPath as NSIndexPath).row])
        cell.thumbnail?.kf.setImage(
            with: URL(string: ""),
            placeholder: UIImage(named: "black_widow")
        )
        cell.nameLabel?.text = "test"
            //keywordLabels[(indexPath as NSIndexPath).row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    

}
