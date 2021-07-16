//
//  Neumorphic.swift
//  point
//
//  Created by Harrison Sherwood on 7/15/21.
//

import SwiftUI

struct Neumorphic: View {
    var name: String
    var width: CGFloat
    var col = Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255)
    //Color(#colorLiteral(red: 0.7915348411, green: 0.8569207191, blue: 0.9852443337, alpha: 1))
    var body: some View {
        Text(self.name)
            .foregroundColor(.black)
            .font(.system(size:20, weight: .semibold, design: .rounded))
            .frame(width: self.width, height: 60)
            .background(
                ZStack {
                    self.col
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .foregroundColor(.white)
                        .blur(radius: 4)
                        .offset(x:-8, y:-8)
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [self.col, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .padding(2)
                        .blur(radius: 2)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: self.col, radius: 20, x: 20, y: 20)
            .shadow(color: Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), radius: 20, x: -20, y: -20)
    }
}
