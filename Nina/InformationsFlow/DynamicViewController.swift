//
//  DynamicViewController.swift
//  Nina
//
//  Created by Emannuel Carvalho on 21/05/20.
//  Copyright © 2020 Emannuel Carvalho. All rights reserved.
//

import UIKit
import Bifrost
import os.log

class DynamicViewController: UIViewController {
    
    let urlString: String
    let log = Nina.log(for: DynamicViewController.self)
    
    init(urlString: String = "http://localhost:8080/screen") {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fetchView)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchView()
    }
    
    @objc fileprivate func fetchView() {
        let session = URLSession.shared
        guard var urlComponents = URLComponents(string: urlString) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "darkMode", value: isDarkModeOn ? "1" : "0")]
        guard let url = urlComponents.url else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    os_log(.error, log: self.log, "Failed to retrieve dynamic screen: %{PUBLIC}@", "\(error)")
                }
                return
            }
            let jsonResult = try? JSONSerialization.jsonObject(with: data, options:.mutableLeaves)
            if let jResult = jsonResult as? [String: Any] {
                DispatchQueue.main.async {
                    do {
                        let comp = try DynamicComponent.parse(dictionary: jResult) as DynamicComponent
                        let view = try DynamicView.createView(dynamicsComponent: comp, actionDelegate: self)
                        for subview in self.view.subviews {
                            subview.removeFromSuperview()
                        }
                        view.fill(view: self.view)
                    } catch {
                        os_log(.error, log: self.log, "Failed to create dynamic screen: %{PUBLIC}@", "\(error)")
                    }
                }
            }
        }
        task.resume()
        
    }
    
}

extension DynamicViewController: DynamicActionDelegate {
    func callAction(sender: String) {
        handle(action: sender)
    }
}

extension DynamicActionDelegate where Self: UIViewController {
    
    func handle(action: String) {
        if action == "dismiss" {
            dismiss(animated: true, completion: nil)
        } else if action.hasPrefix("showScreen") {
            if let url = action.components(separatedBy: "Screen:").last {
                let vc = DynamicViewController(urlString: url)
                navigationController?.show(vc, sender: nil)
            }
        } else if action.hasPrefix("presentScreen") {
            if let url = action.components(separatedBy: "Screen:").last {
                let vc = DynamicViewController(urlString: url)
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
}
