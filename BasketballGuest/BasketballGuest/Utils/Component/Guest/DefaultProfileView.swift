//
//  DefaultProfileView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/24/24.
//

import SwiftUI

struct DefaultProfileView: View {
    let profileUrl: String?
    var body: some View {
        if let profile = profileUrl {
            AsyncImage(url: URL(string: profile)) { phase in
                switch phase {
                case .empty:
                    Image(.user)
                        .resizable()
                        .frame(width: 40, height: 40)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.circle)
                        .frame(width: 40, height: 40)
                case .failure:
                    Image(.user)
                        .resizable()
                        .frame(width: 40, height: 40)
                @unknown default:
                    Image(.user)
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
           
        } else {
            Image(.user)
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    DefaultProfileView(profileUrl: nil)
}
