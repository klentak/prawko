//
//  UserInformations.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI
import KeychainSwift

struct UserInformationsView: View {
    private var keyChain: KeychainSwift = KeychainSwift()

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "person")
                .font(.system(size: 150, weight: .regular))
            Spacer()
            Label("\(keyChain.get("email") ?? "mail@test.com")", systemImage: "envelope")
                    .font(.title)
                    .labelStyle(.titleAndIcon)
            Spacer()
            Button("Wyloguj") {
                
            }
            Spacer()
        }
    }
}

struct UserInformationsView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationsView()
    }
}
