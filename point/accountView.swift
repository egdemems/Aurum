//
//  accountView.swift
//  point
//
//  Created by Harrison Sherwood on 7/5/21.
//

import SwiftUI
import FirebaseDatabase

struct accountView: View {
    var ref = Database.database().reference()
    @AppStorage("wallet") var wallet:String = ""
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Username")
                    .font(.system(size: 20, design: .rounded))
                    .opacity(75)
                    .foregroundColor(Color.gray)
                Spacer()
            }
                Text(wallet)
                    .font(.system(size: 40, design: .rounded))
            Button(action: {
                wallet = ""
            }, label: {
                Text("Logout")
                    .frame(width: 300 , height: 20, alignment: .center)
            })
            .padding()
            .font(.system(size: 20, design: .rounded))
            .background(Color(red: 255 / 255, green: 158 / 255, blue: 0 / 255))
            .foregroundColor(.white)
            .cornerRadius(30)
        }
        .padding()
    }
}

struct accountView_Previews: PreviewProvider {
    static var previews: some View {
        accountView()
    }
}
