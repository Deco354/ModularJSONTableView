//
//  SceneDelegate.swift
//  ModularJSONTableView
//
//  Created by Declan McKenna on 22/06/2020.
//  Copyright © 2020 Declan McKenna. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    /// Endpoint defining what the TableView will display
    typealias Endpoint = RickAndMortyEndpoint
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = storyboard.instantiateViewController(identifier: "TableViewController") { (coder) -> TableViewController<Endpoint>? in
            return TableViewController(coder: coder, apiRequest: APIRequest(endpoint: Endpoint()))
        }
        window?.makeKeyAndVisible()
    }
}

