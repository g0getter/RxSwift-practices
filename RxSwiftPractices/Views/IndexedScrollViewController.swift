//
//  IndexedScrollViewController.swift
//  RxSwiftPractices
//
//  Created by Aiden on 2021/09/24.
//

import UIKit

class IndexedScrollViewController: UIViewController {
    
    var myCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view: UIView = {
           let view = UIView()
            view.backgroundColor = .white
            return view
        }()
        
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            
            layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            layout.itemSize = CGSize(width: 60, height: 60)
            layout.scrollDirection = .horizontal // 수평 scroll
            
            return layout
        }()
        
        // 수평 Scroll
        self.myCollectionView?.collectionViewLayout = layout
        self.myCollectionView?.isPagingEnabled = true;

        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
 
        guard var newFrame = myCollectionView?.frame else { return }
        newFrame.size.height = 70
        myCollectionView?.frame = newFrame
        view.addSubview(myCollectionView ?? UICollectionView())
        
        self.view = view
        
        // TODO: CollectionView 위 일정 간격 띄우기
//        myCollectionView?.snp.makeConstraints {
//            $0.top.equalTo(view).offset(10) // view가 아직 로드되지 않아서 사용할 수 없음.
//        }
    }
}
extension IndexedScrollViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 19 // How many cells to display
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        // TODO: UIButton 가진 Custom cell 만들기
//        guard let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? ButtonCell else {
//            return UICollectionViewCell()
//        }
        myCell.backgroundColor = UIColor.blue
        return myCell
    }
}
extension IndexedScrollViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}
    


