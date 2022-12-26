//
//  UrlConst.swift
//  prawko
//
//  Created by Jakub Klentak on 15/09/2022.
//

struct UrlConst {
    static let scheme = "https"
    static let host = "info-car.pl"
    static let mainUrl = "https://info-car.pl"
    struct Auth {
        static let auth = "/oauth2/authorize"
        static let login = "/oauth2/login"
    }
    struct Dict {
        static let provinces = "/api/word/word-centers"
    }
    static let examSchedule = "/api/word/word-centers/exam-schedule"
}
