//
//  NoExamsView.swift
//  prawko
//
//  Created by Jakub Klentak on 18/01/2023.
//

import SwiftUI

struct NoExamsView: View {
    var body: some View {
        HStack {
            Label {
                Text("Brak terminów :(")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
            } icon: {
                // Put the "image" here
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }.labelStyle(VerticalLabelStyle())
        }
    }
}

struct NoExamsView_Previews: PreviewProvider {
    static var previews: some View {
        NoExamsView()
    }
}
