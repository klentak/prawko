//
//  LoginViewModel.swift
//  prawko
//
//  Created by Jakub Klentak on 14/12/2022.
//

import Foundation
import Alamofire
import CryptoKit
import KeychainSwift


enum LoginError: Error {
    case csrf
    case login
    case bearer
}

class LoginViewModel : ObservableObject {
    private var keyChain: KeychainSwift = KeychainSwift()
    @Published var isAuthenticated: Bool = false

    init () {
        self.isAuthenticated = !(self.keyChain.get("bearer") == nil)
    }
    
    public func actualBearerCode(completion: @escaping (Result<String, LoginError>) -> Void) {
        self.processLogin(
            email: keyChain.get("email")!,
            password: keyChain.get("password")!,
            completion: completion
        )
    }
    
    func processLogin(email: String, password: String, completion: @escaping (Result<String, LoginError>) -> Void) {
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
                                self.isAuthenticated = true
                            default:
                                completion(result)
                            }
                        }
                    default:
                        completion(.failure(LoginError.login))
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
            .validate(statusCode: 302..<303)
            .response { resp in
                
                // Make sure "Location" header is present and its url is parsed correctly
                guard let response = resp.response,
                    let location = response.allHeaderFields["Location"] as? String  else {
                    completion(.failure(LoginError.bearer))
                    return
                }
                
                guard let bearer = self.getBearerFromUrl(location: location) else {
                    completion(.failure(LoginError.bearer))
                    return
                }

                let regex = try! NSRegularExpression(
                    pattern: ".*(&token_type)"
                )

                let results = regex.matches(
                    in: bearer,
                    range: NSRange(bearer.startIndex..., in: bearer)
                )

                let result = results.map {
                    String(bearer[Range($0.range, in: bearer)!])
                }.first?.components(separatedBy: "&")[0]

                completion(.success(result!))
            }
    }
    
    // TODO: chenge validation to one that make more sense
    private func login(email: String, password: String, csrf: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string:  UrlConst.mainUrl + UrlConst.Auth.login) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = self.getPostString(email: email, password: password, csrf: csrf).data(using: .utf8)

        AF.request(request)
            .response { response in
                print(response)
                switch response.response!.statusCode {
                case 200:
                    completion(true)
                default:
                    completion(false)
                }
            }
    }
        
    private func getCsrfCode(completion: @escaping (Result<String, LoginError>) -> Void) {
        AF.request(UrlConst.mainUrl + UrlConst.Auth.login).responseString { response in
            let htmlString = response.value!

            let regex = try! NSRegularExpression(
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
    
    private func generateAuthData() -> Array<URLQueryItem> {
        let hash = self.generateHash()
        
        return [
            URLQueryItem(name: "response_type", value: "id_token token"),
            URLQueryItem(name: "client_id", value: "client"),
            URLQueryItem(name: "state", value: hash),
            URLQueryItem(name: "redirect_uri", value: "https://info-car.pl/new/assets/refresh.html"),
            URLQueryItem(name: "scope", value: "openid profile email resource.read"),
            URLQueryItem(name: "nonce", value: hash),
            URLQueryItem(name: "prompt", value: "none"),
        ]
    }
    
    private func getBearerFromUrl(location: String) -> String? {
        let regex = try! NSRegularExpression(
            pattern: "(https://info-car.pl/new/assets/refresh.html#.*)"
        );

        let nsrange = NSRange(location.startIndex ..< location.endIndex, in: location);
        if (regex.firstMatch(in: location, options: [], range: nsrange) == nil) {
            return nil;
        }
        let index = location.index(location.endIndex, offsetBy: -(location.count - 57))

        return String(location[index...]);
    }
    
    private func generateHash()-> String {
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
        keyChain.set(bearer, forKey: "bearer")
        keyChain.set(email, forKey: "email")
        keyChain.set(password, forKey: "password")
    }
}
