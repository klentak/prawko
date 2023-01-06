//
//  DrivingLicencesCategories.swift
//  prawko
//
//  Created by Jakub Klentak on 23/12/2022.
//

import Foundation

public struct DrivingLicenceCategory : Decodable, Hashable, Identifiable {
    public let id : String
    public let name : String
    public let icon : String
}
