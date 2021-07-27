//
//  MainViewController.swift
//  RxSwift
//
//  Created by 여나경 on 2021/07/24.
//

import UIKit
import Kingfisher
import RxSwift

class MainViewController: UIViewController {

    @IBOutlet weak var marvelImage: UIImageView!
    @IBOutlet weak var apiButton: UIButton!
    @IBOutlet weak var responseTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        apiButton.setTitle("Send a request", for: .normal)
        apiButton.setTitle("Wanna send", for: .highlighted)
        apiButton.setTitleColor(.gray, for: .highlighted)
        apiButton.addTarget(self, action: #selector(sendAPIRequest), for: .touchUpInside)
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
