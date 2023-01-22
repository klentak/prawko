//
//  Login.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginVM : LoginViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Text("Zaloguj się do serwisu Info-Car")
                .font(.title)
                .padding(.top, 20)
            Text("Zaloguj się za pomocą tego samego loginu oraz hasła z którego korzystasz przy logowaniu na stronę info-car.pl")
                .fontWeight(.light)
                .padding(.top, 5)
            Form {
                Section {
                    TextField(
                        "Email",
                        text: $email
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                }
                Section {
                    SecureField(
                        "Hasło",
                        text: $password
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                }
                
                Button("Zaloguj") {
                    // TODO: make alerts on error
                    loginVM.processLogin(email: email, password: password) { result in
                        print(result)
                    }
                }
            }
            Text("Twoje dane są zapisywane lokalnie, tylko na Twoim urządzeniu i nie są nikomu udostępniane.")
                .fontWeight(.ultraLight)
                .padding(.top, 5)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginVM: LoginViewModel())
    }
}
