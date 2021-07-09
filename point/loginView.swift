//
//  Login.swift
//  point
//
//  Created by Harrison Sherwood on 7/5/21.
//
import SwiftUI
import FirebaseDatabase

struct loginView: View {
    var ref = Database.database().reference()
    @AppStorage("wallet") var wallet:String = ""
    
    @State var logUsername = ""
    @State var logPassword = ""
    
    var body: some View {
        VStack {
            Text("Log in")
                .padding()
                .font(.system(size: 50, design: .rounded))
            TextField("Username", text: $logUsername)
                .padding()
                .font(.system(size: 20, design: .rounded))
            SecureField("Password", text: $logPassword)
                .padding()
                .font(.system(size: 20, design: .rounded))
            Button(action: {
                if logUsername != "" && logPassword != "" {
                    ref.child("\(logUsername)/password").getData {
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
                        let pop = snapshot.value as? String
                        if pop == logPassword {
                            wallet = logUsername
                            UserDefaults.standard.set(self.wallet, forKey: "Wallet")
                            logUsername = ""
                            logPassword = ""
                        }
                        else {
                            print("\(logPassword) doesn't equal \(pop ?? "")")
                        }
                    }
                }
            }, label: {
                Text("Continue")
                    .padding()
                    .font(.system(size: 20, design: .rounded))
                    .background(Color(red: 255 / 255, green: 158 / 255, blue: 0 / 255))
                    .foregroundColor(.white)
                    .cornerRadius(30)
            })
            Spacer()
        }
    }
}
