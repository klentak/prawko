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
        }
        .navigationBarTitle(Text("Zaloguj się do serisu InfoShare"))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginVM: LoginViewModel())
    }
}
