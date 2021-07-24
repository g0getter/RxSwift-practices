//
//  MainViewController.swift
//  RxSwift
//
//  Created by 여나경 on 2021/07/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var marvelImage: UIImageView!
    @IBOutlet weak var apiButton: UIButton!
    @IBOutlet weak var responseTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        apiButton.setTitle("Send a request", for: .normal)
        apiButton.setTitle("Wanna send", for: .highlighted)
        apiButton.setTitleColor(.gray, for: .highlighted)
        apiButton.addTarget(self, action: #selector(sendAPIRequest), for: .touchUpInside)
    }
    
    @objc func sendAPIRequest() {
        responseTextView.text = "Sending"
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
