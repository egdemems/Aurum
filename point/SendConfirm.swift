//
//  SendConfirm.swift
//  point
//
//  Created by Harrison Sherwood on 7/7/21.
//

import SwiftUI
import FirebaseDatabase

struct SendConfirm: View {
    
    @AppStorage("wallet") var wallet:String = ""
    
    @AppStorage("showingSender") var showingSender: Bool = false
    
    var ref = Database.database().reference()
    
    @AppStorage("amount") var amount: Int = 0
    
    @AppStorage("sending") var sending: Int = 0
    
    @State var address = ""
    
    @State var badAddress = false
    
    var body: some View {
        VStack {
            if sending == 1 {
                Text("Sending 1 point")
                    .foregroundColor(Color.white)
                    .font(.system(size: 40, design: .rounded))
            }
            else {
                Text("Sending \(sending) points")
                    .foregroundColor(Color.white)
                    .font(.system(size: 40, design: .rounded))
            }
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 450, height: 50)
                HStack{
                    Text("To")
                        .padding(.leading, 50)
                        .padding(.trailing, 10)
                        .font(.system(size: 20, design: .rounded))
                    TextField("username...", text: $address)
                        .padding()
                        .font(.system(size: 20, design: .rounded))
                }
            }
            Button(action: {
                if address != "" {
                    ref.child("\(address)/points").getData {
                        (error, snapshot) in
                        if let error = error {
                                print("Error getting data \(error)")
                            }
                        else if snapshot.exists() {
                                print("Got data \(snapshot.value!)")
                            }
                        else {
                                print("No data available")
                            }
                        let pop = snapshot.value as? Int
                        if pop != nil {
                            badAddress = false
                            ref.child("\(address)/points").setValue(pop! + self.sending)
                            ref.child("\(wallet)/points").setValue(self.amount - self.sending)
                            self.address = ""
                            showingSender = false
                        }
                        else {
                            print("address does not exist")
                            badAddress = true
                        }
                    }
                } else {
                    print("address is nil")
                    //errYa = true
                }
            }, label: {
                //Image(systemName: "paperplane")
                Text("Send")
                    .bold()
                    .frame(width: 300 , height: 20, alignment: .center)
            })
            .padding()
            .font(.system(size: 30, design: .rounded))
            .background(Color(red: 255 / 255, green: 220 / 255, blue: 159 / 255))
            .foregroundColor(.white)
            .cornerRadius(30)
            Spacer()
                .frame(height: 450)
        }
    }
}

struct SendConfirm_Previews: PreviewProvider {
    static var previews: some View {
        SendConfirm()
    }
}
