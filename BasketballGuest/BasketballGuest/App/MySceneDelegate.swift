//
//  MySceneDelegate.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/25/24.
//

import Foundation
import KakaoSDKAuth
import UIKit

class MySceneDelegate: UIResponder, UIWindowSceneDelegate {
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
         if let url = URLContexts.first?.url {
             if (AuthApi.isKakaoTalkLoginUrl(url)) {
                 _ = AuthController.handleOpenUrl(url: url)
             }
         }
     }
}
