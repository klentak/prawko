//
//  UserInformations.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI
import KeychainSwift

struct UserInformationsView: View {
    @StateObject var loginVM : LoginViewModel
    var keychain: KeychainSwift = KeychainSwift()

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "person")
                .font(.system(size: 150, weight: .regular))
            Spacer()
            Label("\(keychain.get("email") ?? "mail@test.com")", systemImage: "envelope")
                    .font(.title)
                    .labelStyle(.titleAndIcon)
            Spacer()
            Button("Wyloguj") {
                loginVM.logout()
            }
            Spacer()
        }
    }
}

struct UserInformationsView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationsView(
            loginVM: LoginViewModel()
        )
    }
}
