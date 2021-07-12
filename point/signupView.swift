//
//  Signup.swift
//  point
//
//  Created by Harrison Sherwood on 7/5/21.
//
import SwiftUI
import FirebaseDatabase

struct signupView: View {
    var ref = Database.database().reference()
    @AppStorage("wallet") var wallet:String = ""
    
    @State var fullName = ""
    @State var email = ""
    @State var username = ""
    @State var password = ""
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    public func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func isValidInput(_ input:String) -> Bool {
        let RegEx = "\\w{1,18}"
        return NSPredicate(format:"SELF MATCHES %@", RegEx).evaluate(with: input)
    }
    
    var body: some View {
        VStack {
            Text("Sign up")
                .padding()
                .font(.system(size: 50, design: .rounded))
            TextField("Full Name", text: $fullName)
                .padding()
                .font(.system(size: 20, design: .rounded))
            TextField("Email", text: $email)
                .padding()
                .font(.system(size: 20, design: .rounded))
            TextField("Username", text: $username)
                .padding()
                .font(.system(size: 20, design: .rounded))
            SecureField("Password", text: $password)
                .padding()
                .font(.system(size: 20, design: .rounded))
            Button(action: {
                if fullName != "" && email != "" && username != "" && password != "" {
                    if isValidEmail(email) == true && isValidPassword(password) == true && isValidInput(username){
                        ref.child("\(username)/points").getData {
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
                                print("account already exists")
                            }
                            else {
                                ref.child("\(username)/points").setValue(0)
                                ref.child("\(username)/fullName").setValue(fullName)
                                ref.child("\(username)/email").setValue(email)
                                ref.child("\(username)/password").setValue(password)
                                wallet = username
                                UserDefaults.standard.set(self.wallet, forKey: "Wallet")
                                fullName = ""
                                email = ""
                                username = ""
                                password = ""
                            }
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
