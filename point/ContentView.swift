//
//  ContentView.swift
//  point
//
//  Created by Harrison Sherwood on 7/3/21.
//

import SwiftUI
import FirebaseDatabase

struct ContentView: View {
    
    var ref = Database.database().reference()
    
    @AppStorage("wallet") var wallet = UserDefaults.standard.string(forKey: "Wallet") ?? ""
    
    @AppStorage("showingSender") var showingSender = false
    
    @AppStorage("sending") var sending = 0
    
    @AppStorage("amount") var amount = 0
    
    @State var tabSelection: Tabs = .tab1
    
    @State var currentColor = Color.black
    
    var body: some View {
        if wallet != "" {
            NavigationView {
                TabView(selection: $tabSelection) {
                    Text("Images")
                    .tabItem {
                       Image(systemName: "safari")
                     }
                    .tag(Tabs.tab1)
                    Photo()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .tabItem {
                       Image(systemName: "camera")
                     }
                    .tag(Tabs.tab2)
                    ZStack {
                        Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255)
                        Send()
                            .accentColor(.black)
                    }
                    .ignoresSafeArea()
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                    .tabItem {
                       Image(systemName: "arrow.left.arrow.right")
                     }
                    .tag(Tabs.tab3)
                    Text("List of messages and message creator")
                    .tabItem {
                       Image(systemName: "message")
                     }
                    .tag(Tabs.tab4)
                    accountView()
                    .tabItem {
                       Image(systemName: "gearshape")
                     }
                    .tag(Tabs.tab5)
                }
                .onAppear() {
                    let appearance = UITabBarAppearance()

                    appearance.configureWithTransparentBackground()

                    UITabBar.appearance().standardAppearance = appearance
                }
                .onChange(of: tabSelection) { newValue in
                    if tabSelection == .tab3 {
                        currentColor = Color.white
                    }
                    else {
                        currentColor = Color.black
                    }
                }
                .accentColor(currentColor)
                //.navigationBarTitle(returnNaviBarTitle(tabSelection: self.tabSelection))
            }
        }
        else {
            NavigationView {
                ZStack {
                    Image("clothes")
                        .resizable()
                         .scaledToFill()
                         .edgesIgnoringSafeArea(.all)
                    VStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width:160, height:150)
                        NavigationLink(destination: signupView(), label: {
                            Text("Sign up")
                                .frame(width: 300 , height: 20, alignment: .center)
                        })
                        .padding()
                        .font(.system(size: 20, design: .rounded))
                        .background(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        NavigationLink(destination: loginView(), label: {
                            Text("Log in")
                                .frame(width: 300 , height: 20, alignment: .center)
                        })
                        .padding()
                        .font(.system(size: 20, design: .rounded))
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        Spacer()
                    }
                    .padding(30)
                }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            }
        }
    }
    
    enum Tabs{
        case tab1, tab2, tab3, tab4, tab5
    }
    
    func returnNaviBarTitle(tabSelection: Tabs) -> String{//this function will return the correct NavigationBarTitle when different tab is selected.
        switch tabSelection{
            case .tab1: return "Explore"
            case .tab2: return "Post"
            case .tab3: return ""
            case .tab4: return "Message"
            case .tab5: return "Account"
        }
    }
}

struct ColorPreferenceKey: PreferenceKey {
      static var defaultValue: Color = Color.clear

      static func reduce(value: inout Color, nextValue: () -> Color) {
            value = nextValue()
      }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
