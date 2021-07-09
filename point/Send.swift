//
//  Send.swift
//  point
//
//  Created by Harrison Sherwood on 7/3/21.
//

import SwiftUI
import FirebaseDatabase

struct Send: View {
    
    //var wallet = "Harry"
    @AppStorage("wallet") var wallet:String = ""
    
    @AppStorage("showingSender") var showingSender: Bool = false
    
    var ref = Database.database().reference()
    
    @AppStorage("amount") var amount: Int = 0
    
    @AppStorage("sending") var sending: Int = 0
    
    @State var errYa = false
    @State var notEnough = false
    
    @State var digits = [Int]()
    
    func load() {
        ref.child("\(wallet)/points").observe(.value) {
            (snapshot) in
            let pop = snapshot.value as? Int
            self.amount = pop ?? 0
        }
    }
    
    var body: some View {
        VStack {
            Text("\(self.amount) points available")
                .foregroundColor(Color.white)
                .font(.system(size: 40, design: .rounded))
            Spacer()
                .frame(height: 20)
            Text(String(digits.reduce(0, {$0*10 + $1})))
                .foregroundColor(Color.white)
                .padding()
                .font(.system(size: 80, design: .rounded))
            ForEach((0...2), id: \.self) { bruh in
                HStack {
                    ForEach((1...3), id: \.self) { bruh2 in
                        Button(action: {
                            if digits.count < 7 {
                                digits.append((bruh * 3) + bruh2)
                            }
                        }, label: {
                            Text("\((bruh * 3) + bruh2)")
                                .foregroundColor(Color.white)
                                .padding(.leading, 40)
                                .padding(.trailing, 40)
                                .font(.system(size: 50, design: .rounded))
                        })
                    }
                }
                Spacer()
                    .frame(height: 30)
            }
            HStack {
                Button(action: {
                    if digits.count > 0 {
                        if digits.count < 7 {
                            digits.append(0)
                        }
                    }
                }, label: {
                    Text("0")
                        .foregroundColor(Color.white)
                        .padding(.leading, 40)
                        .padding(.trailing, 40)
                        .font(.system(size: 50, design: .rounded))
                })
                Button(action: {digits.popLast()}, label: {
                    Text("<")
                        .foregroundColor(Color.white)
                        .padding(.leading, 40)
                        .padding(.trailing, 40)
                        .font(.system(size: 50, design: .rounded))
                })
            }
            Spacer()
                .frame(height: 50)
            Button (action: {
                if digits.reduce(0, {$0*10 + $1}) != 0{
                    errYa = false
                    if (amount - digits.reduce(0, {$0*10 + $1})) >= 0 {
                        notEnough = false
                        sending = digits.reduce(0, {$0*10 + $1})
                        showingSender = true
                    } else {
                        print("not enough points")
                        notEnough = true
                    }
                } else {
                    print("sending is 0")
                    errYa = true
                }
            }, label: {
                Text("Confirm")
                    .bold()
                    .frame(width: 300 , height: 20, alignment: .center)
            })
            .padding()
            .font(.system(size: 30, design: .rounded))
            .background(Color(red: 255 / 255, green: 220 / 255, blue: 159 / 255))
            .foregroundColor(.white)
            .cornerRadius(30)
        }
        .onAppear{load()}
        .sheet(isPresented: $showingSender) {
            ZStack {
                //Color(red: 255 / 255, green: 220 / 255, blue: 159 / 255)
                Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255)
                SendConfirm()
            }.ignoresSafeArea()
        }
    }
}

struct Send_Previews: PreviewProvider {
    static var previews: some View {
        Send()
    }
}
