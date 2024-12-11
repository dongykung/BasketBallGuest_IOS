//
//  SocialButton.swift
//  BasketballGuest
//
//  Created by 김동경 on 12/2/24.
//

import SwiftUI



struct SocialButton: View {
    
    let socialType: SocialConfigurable
    let action: () -> Void
    
    init(
        socialType: SocialConfigurable,
        action: @escaping () -> Void
    ) {
        self.socialType = socialType
        self.action = action
    }
    
    var body: some View {
        Button {
           action()
        } label: {
            HStack {
                Image(socialType.logo)
                    .padding(.trailing)
                
                Text(socialType.title)
                    .font(.semibold18)
                    .foregroundStyle(socialType.foregroundColor)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(socialType.backgroundColor)
            .clipShape(.rect(cornerRadius: 12))
        }
        .accessibilityLabel(Text(socialType.title))
        .padding(.horizontal)
    }

}

#Preview {
    SocialButton(socialType: .google) {
        
    }
}
