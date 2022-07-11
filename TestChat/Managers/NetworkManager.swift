//
//  NetworkManager.swift
//  TestChat
//
//  Created by Владимир Ли on 08.07.2022.
//

import Foundation
import UIKit

enum URLs: String {
    case testURL = "https://numero-logy-app.org.in/getMessages?offset=0"
    case imageURL = "https://cn.bing.com/az/hprichbg/rb/VenetianRowing_ZH-CN6668445308_1920x1080.jpg"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData(with url: String, completion: @escaping(String?, Error?) -> Void) {
        guard let url = URL(string: url) else {
            print ("Ошибка при получении url-адреса")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                print("Ошибка при проверке данных")
                return
            }
            
            do {
                let results = try JSONSerialization.jsonObject(with: data,
                                                              options: .fragmentsAllowed) as! NSDictionary
                
                if results.count > 0 {
                    let messages = results["result"] as! [String]

                    for message in messages {
                        DispatchQueue.main.async {
                            completion(message, nil)
                        }
                    }
                }
            } catch let error {
                print(print("Catch error: \(error.localizedDescription)"))
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
    
    func fetchImage(with url: String, completion: @escaping(Data) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}
