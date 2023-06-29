//
//  Login.swift
//  prawko
//
//  Created by Jakub Klentak on 13/12/2022.
//

import SwiftUI

struct LoginView<LoginViewModelAlias>: View
where LoginViewModelAlias: LoginVMProtocol{
    @ObservedObject var viewModel: LoginViewModelAlias
    
    init(viewModel: LoginViewModelAlias) {
        self.viewModel = viewModel
    }
    
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
                        text: $viewModel.email
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                }
                Section {
                    SecureField(
                        "Hasło",
                        text: $viewModel.password
                    )
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                }

                if !viewModel.loading {
                    Button("Zaloguj") {
                        viewModel.login()
                    }
                    .foregroundColor(viewModel.email.isEmpty || viewModel.password.isEmpty ? .red : .blue)
                    .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
                    .alert(isPresented: $viewModel.wrongLoginData) {
                        Alert(
                            title: Text("Podano błędne dane."),
                            message: Text("Nieprawidłowy e-mail bądź hasło! Popraw dane."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                } else {
                    ProgressView()
                }
            }
            Text("Twoje dane są zapisywane lokalnie, tylko na Twoim urządzeniu i nie są nikomu udostępniane.")
                .fontWeight(.ultraLight)
                .padding(.top, 5)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .alert(isPresented: $viewModel.unexpectedError) {
            Alert(
                title: Text("Błąd systemu info-share"),
                message: Text("Spróbuj ponownie później"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            viewModel: LoginVMMock(
                loginService: LoginServiceMock(
                    appState: AppState(loggedIn: false)
                )
            )
        )
    }
}
