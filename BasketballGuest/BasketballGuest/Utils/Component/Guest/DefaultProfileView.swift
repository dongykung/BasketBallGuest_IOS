//
//  DefaultProfileView.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/24/24.
//

import SwiftUI

struct DefaultProfileView: View {
    let profileUrl: String?
    let frame: CGFloat
    
    init(profileUrl: String?, frame: CGFloat = 40) {
        self.profileUrl = profileUrl
        self.frame = frame
    }
    
    var body: some View {
        if let profile = profileUrl {
            AsyncImage(url: URL(string: profile)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: frame, height: frame)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(.circle)
                        .frame(width: frame, height: frame)
                case .failure:
                    Image(.user)
                        .resizable()
                        .frame(width: frame, height: frame)
                @unknown default:
                    ProgressView()
                        .frame(width: frame, height: frame)
                }
            }
           
        } else {
            Image(.user)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: frame, height: frame)
        }
    }
}

#Preview {
    DefaultProfileView(profileUrl: nil)
}
