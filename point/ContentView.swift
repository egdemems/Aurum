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
    
    @AppStorage("zipcode") var zipcode = UserDefaults.standard.string(forKey: "Zipcode") ?? ""
    
    @AppStorage("wallet") var wallet = UserDefaults.standard.string(forKey: "Wallet") ?? ""
    
    @AppStorage("showingSender") var showingSender = false
    
    @AppStorage("sending") var sending = 0
    
    @AppStorage("amount") var amount = 0
    
    @State var tabSelection: Tabs = .tab1
    
    @State var currentColor = Color.black
    
    @State var currentTabBarColor = Color.black
    
    var body: some View {
        if wallet != "" {
            NavigationView {
                TabView(selection: $tabSelection) {
                    ZStack {
                        Color(#colorLiteral(red: 0.992025435, green: 0.9831623435, blue: 0.8817279935, alpha: 1))
                        ExploreView()
                    }
                    .ignoresSafeArea()
                    .tabItem {
                       Image(systemName: "safari")
                     }
                    .tag(Tabs.tab1)
                    ZStack {
                        Color(#colorLiteral(red: 0.992025435, green: 0.9831623435, blue: 0.8817279935, alpha: 1))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.all)
                        PostView()
                    }
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
                    ZStack {
                        Color(#colorLiteral(red: 0.992025435, green: 0.9831623435, blue: 0.8817279935, alpha: 1))
                        Text("messages")
                    }
                    .ignoresSafeArea()
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
                    UITabBar.appearance().barTintColor = UIColor(Color(red: 255 / 255, green: 220 / 255, blue: 159 / 255))
                    //let appearance = UITabBarAppearance()
                    UITabBar.appearance().layer.borderWidth = 0.0
                    UITabBar.appearance().clipsToBounds = true

                    //appearance.configureWithTransparentBackground()

                    //UITabBar.appearance().standardAppearance = appearance
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
