//
//  VerticalLabelStyle.swift
//  prawko
//
//  Created by Jakub Klentak on 06/01/2023.
//

import SwiftUI

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center, spacing: 20) {
            configuration.icon
            configuration.title
        }
    }
}

