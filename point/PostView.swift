//
//  PostView.swift
//  point
//
//  Created by Harrison Sherwood on 7/9/21.
//

import SwiftUI

struct PostView: View {
    
    @AppStorage("showingPhoto") var showingPhoto = false
    
    @AppStorage("wallet") var wallet:String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading){
                Spacer()
                    .frame(height: 30)
                Button(action: {self.showingPhoto = true}, label: {
                    Text("List and item")
                        .font(.system(size: 30, design: .rounded))
                        .frame(width: 350 , height: 20, alignment: .center)
                        .foregroundColor(.black)
                })
                .padding()
                .font(.system(size: 20, design: .rounded))
                .background(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                .foregroundColor(.white)
                .cornerRadius(30)
                Text("Listed")
                    .padding()
                    .font(.system(size: 25, design: .rounded))
            }
            .sheet(isPresented: $showingPhoto) {
                Photo()
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
