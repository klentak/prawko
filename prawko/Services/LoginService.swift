//
//  LoginService.swift
//  prawko
//
//  Created by Jakub Klentak on 14/12/2022.
//

import Foundation
import Alamofire
import CryptoKit
import KeychainSwift
import SwiftUI

class LoginService: LoginServiceProtocol {
    @StateObject var appState: AppState

    private var keychain: KeychainSwift = KeychainSwift()

    init (appState: AppState) {
        appState.loggedIn = !(self.keychain.get("bearer") == nil)
        self._appState = StateObject(wrappedValue: appState)
     }

    func logout() {
        keychain.clear()
        appState.loggedIn = false
    }

    func actualBearerCode(completion: @escaping (Result<Bool, LoginError>) -> Void) {
        self.processLogin(
            email: keychain.get("email")!,
            password: keychain.get("password")!,
            completion: completion
        )
    }

    func processLogin(email: String, password: String, completion: @escaping (Result<Bool, LoginError>) -> Void) {
        self.getCsrfCode() { result in
            switch result {
            case .success(let csrf):
                self.login(email: email, password: password, csrf: csrf) { result in
                    switch result {
                    case true:
                        self.authorize() { result in
                            switch result {
                            case .success(let bearer):
                                self.addAuthDataToKeyChain(email: email, password: password, bearer: bearer)
                                self.appState.loggedIn = true

                                completion(.success(true))
                            default:
                                completion(.failure(LoginError.bearer))
                            }
                        }
                    default:
                        completion(.failure(LoginError.wrongLoginData))
                    }
                }
            case .failure(let encodingError):
                completion(.failure(encodingError))
            }
        }
    }

    private func authorize(completion: @escaping (Result<String, LoginError>) -> Void) {
        guard let url = self.generateAuthUrl() else { return }

        AF.request(url)
            .redirect(using: Redirector(behavior: .doNotFollow))
            .validate(statusCode: 302 ..< 303)
            .response { resp in
                guard let response = resp.response,
                    let location = response.allHeaderFields["Location"] as? String  else {
                    completion(.failure(LoginError.bearer))
                    return
                }

                guard let bearer = self.getBearerFromUrl(location: location) else {
                    completion(.failure(LoginError.bearer))
                    return
                }

                let regex: NSRegularExpression

                do {
                    regex = try NSRegularExpression(
                        pattern: ".*(&token_type)"
                    )
                } catch {
                    completion(.failure(LoginError.bearer))
                    return
                }

                let results = regex.matches(
                    in: bearer,
                    range: NSRange(bearer.startIndex..., in: bearer)
                )

                let result = results.map {
                    String(bearer[Range($0.range, in: bearer)!])
                }.first?.components(separatedBy: "&")[0]

                guard let result = result else {
                    completion(.failure(LoginError.bearer))
                    return
                }

                completion(.success(result))
            }
    }

    private func login(email: String, password: String, csrf: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: UrlConst.mainUrl + UrlConst.Auth.login) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = self.getPostString(email: email, password: password, csrf: csrf).data(using: .utf8)

        AF.request(request)
            .response { response in
                let url = response.response?.url
                let query = url?.query
                if query != nil && query!.contains("error") {
                    completion(false)
                    return
                }

                completion(true)
            }
    }

    private func getCsrfCode(completion: @escaping (Result<String, LoginError>) -> Void) {
        AF.request(UrlConst.mainUrl + UrlConst.Auth.login).responseString { response in
            let htmlString = response.value!

            do {
                let regex = try NSRegularExpression(
                    pattern: "(<input type=\"hidden\" name=\"_csrf\" value=\").{36}(\")"
                )

                let results = regex.matches(
                    in: htmlString,
                    range: NSRange(htmlString.startIndex..., in: htmlString)
                )

                let result = results.map {
                    String(htmlString[Range($0.range, in: htmlString)!])
                }.first?.components(separatedBy: "\"")[5]

                completion(.success(result!))
            } catch {
                completion(.failure(LoginError.csrf))
            }
        }
    }

    private func getPostString(email: String, password: String, csrf: String) -> String {
        var data = [String]()
        data.append("username=\(email)")
        data.append("_csrf=\(csrf)")
        data.append("password=\(password)")
        data.append("_csrf=\(csrf)")

        return data.map { String($0) }.joined(separator: "&")
    }

    private func generateAuthUrl() -> String? {
        var components = URLComponents()
        components.scheme = UrlConst.scheme
        components.host = UrlConst.host
        components.path = UrlConst.Auth.auth
        components.queryItems = self.generateAuthData()

        return components.url?.absoluteURL.absoluteString
    }

    private func generateAuthData() -> [URLQueryItem] {
        let hash = self.generateHash()

        return [
            URLQueryItem(name: "response_type", value: "id_token token"),
            URLQueryItem(name: "client_id", value: "client"),
            URLQueryItem(name: "state", value: hash),
            URLQueryItem(name: "redirect_uri", value: "https://info-car.pl/new/assets/refresh.html"),
            URLQueryItem(name: "scope", value: "openid profile email resource.read"),
            URLQueryItem(name: "nonce", value: hash),
            URLQueryItem(name: "prompt", value: "none")
        ]
    }

    private func getBearerFromUrl(location: String) -> String? {
        let regex: NSRegularExpression

        do {
            regex = try NSRegularExpression(
                pattern: "(https://info-car.pl/new/assets/refresh.html#.*)"
            )
        } catch {
            return nil
        }

        let nsrange = NSRange(location.startIndex ..< location.endIndex, in: location)
        if regex.firstMatch(in: location, options: [], range: nsrange) == nil {
            return nil
        }
        let index = location.index(location.endIndex, offsetBy: -(location.count - 57))

        return String(location[index...])
    }

    private func generateHash() -> String {
        let string = "test"
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }

    private func addAuthDataToKeyChain(
        email: String,
        password: String,
        bearer: String
    ) {
        keychain.set(bearer, forKey: "bearer")
        keychain.set(email, forKey: "email")
        keychain.set(password, forKey: "password")
    }
}
