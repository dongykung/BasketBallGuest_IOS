//
//  Container.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/3/24.
//

import Factory
import Foundation

extension Container {
    var authService: Factory<AuthService> {
        Factory(self) { AuthServiceImpl() }
    }
    
    var userService: Factory<UserService> {
        Factory(self) { UserServiceImpl() }
    }
    
    var poiService: Factory<POIService> {
        Factory(self) { POIServiceImpl() }
    }
    
    var guestService: Factory<GuestService> {
        Factory(self) { GuestServiceImpl() }
    }
}
