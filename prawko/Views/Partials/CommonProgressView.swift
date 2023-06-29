//
//  CommonProgressView.swift
//  prawko
//
//  Created by Jakub Klentak on 16/01/2023.
//

import SwiftUI

struct CommonProgressView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
            .scaleEffect(3)
    }
}

struct CommonProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CommonProgressView()
    }
}
