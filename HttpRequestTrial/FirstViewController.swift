//
//  FirstViewController.swift
//  HttpRequestTrial
//
//  Created by tayutaedomo on 2019/08/24.
//  Copyright © 2019 tayutaedomo.net. All rights reserved.
//

import UIKit

//
// Refer: http://www.office-matsunaga.biz/ios/description.php?id=54
//
class FirstViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var text_view: UITextView!
    

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://api.github.com/users/tayutaedomo")
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                var text_list: [String] = [];
                
                let content_type: String = response.allHeaderFields["Content-Type"] as! String
                print("Content-Type: \(content_type)")
                text_list.append(content_type)
                
                let status_code: String = String(describing: response.statusCode)
                text_list.append(status_code)
                print("statusCode: \(status_code)")
                
                let data_str = String(data: data, encoding: String.Encoding.utf8) ?? ""
                print(data_str)
                text_list.append(data_str)
                
                DispatchQueue.main.sync {
                    self.text_view.text = text_list.map { text -> String in return text }.joined(separator: "\n")
                }
            }
            else {
                let err_str: String = String(describing: error)
                print("Error: \(err_str)")
                self.text_view.text = err_str
            }
        }.resume()
    }
}
