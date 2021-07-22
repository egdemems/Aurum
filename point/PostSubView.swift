//
//  PostSubView.swift
//  point
//
//  Created by Harrison Sherwood on 7/9/21.
//

import SwiftUI
import FirebaseDatabase
import FirebaseStorage
import WKView

struct Onboard: Codable {
    
    struct subHref: Codable {
        var href: String
        var rel: String
        var method: String
        var description: String
    }
    
    var links: [subHref]
}

struct Buyer: Codable {
    struct subHref2: Codable {
        var href: String
        var rel: String
        var method: String
    }
    var id: String
    var status: String
    var links: [subHref2]
}

struct accToke: Codable{
    var access_token: String
}

struct PostSubView: View {
    
    @State var showUrl = false
    
    @State var OnboardSave = ""
    
    @State var OnboardId = ""
    
    @State var toke = ""
    
    @State var address = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @AppStorage("wallet") var wallet:String = ""
    
    var ref = Database.database().reference()
    
    var username: String
    
    var firstPhoto: UIImage
    
    var name: String
    
    @State var postCount1 = true
    
    @State var thumbnail1 = [UIImage]()
    
    @State var title = ""
    
    @State var description = ""
    
    @State var category = ""
    
    @State var price = 0
    
    @State var zipcode = 0
    
    @State private var image = UIImage(imageLiteralResourceName: "tab")
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func accessToken(){
        guard let url = URL(string: "https://api-m.sandbox.paypal.com/v1/oauth2/token"),
              let payload = "grant_type=client_credentials".data(using: .utf8) else
        {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Basic QWFHUy1FMU1Nb0pBS0FaWXBETWI5aWxONGRlQktBcjFKRW8tMVdORElNeFVwbnFUd3BlSjFUb19nREozem54UVZVSDJFX3lBXzk0RDBsdDU6RUQzODV3Sm9adUNTcWoxMUhUX1Vac0Nvd0hmU0R1MG9TV2RrQVVRQU9vNUhFbFgzTktTb2lOZFRMRXhfeXF4Tmg4ZG1pVnM1NjdJVGVqU3k=", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload
        

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data"); return }
            
            let decoder = JSONDecoder()
            let token1 = try? decoder.decode(accToke.self, from: data)
            self.toke = token1!.access_token
        }.resume()
    }
    
    func loader() {
        ref.child("\(name)/image_count").getData {
            (error, snapshot) in
            let pop = snapshot.value as? Int
            if pop! != 0 {
                if pop == 1 {
                    postCount1 = true
                }
                else {
                    postCount1 = false
                    for x in 2...pop! {
                        ref.child("\(name)/image_\(x)").observe(.value) {
                            (snapshot) in
                            let pop1 = snapshot.value as? String
                            if pop1 != nil {
                                Storage.storage().reference().child("\(pop1!)").getData(maxSize: 1 * 1024 * 1024) {
                                (imageData, err) in
                                if err != nil {
                                      print("error downloading image")
                                  } else {
                                      if let imageData = imageData {
                                        self.thumbnail1.append(UIImage(data: imageData)!)
                                      } else {
                                            print("couldn't unwrap")
                                      }
                                  }
                                }
                            }
                        }
                    }
                }
            }
        }
        ref.child("\(name)/title").getData {
            (error, snapshot) in
            let pop = snapshot.value as? String
            self.title = pop ?? "No title"
        }
        ref.child("\(name)/description").getData {
            (error, snapshot) in
            let pop = snapshot.value as? String
            self.description = pop ?? "No Description"
        }
        ref.child("\(name)/category").getData {
            (error, snapshot) in
            let pop = snapshot.value as? String
            self.category = pop ?? ""
        }
        ref.child("\(name)/price").getData {
            (error, snapshot) in
            let pop = snapshot.value as? Int
            self.price = pop ?? 0
        }
        ref.child("\(name)/zipcode").getData {
            (error, snapshot) in
            let pop = snapshot.value as? Int
            self.zipcode = pop ?? 0
        }
        ref.child("\(username)/email").getData {
            (error, snapshot) in
            let pop = snapshot.value as? String
            self.address = pop ?? ""
        }
        Storage.storage().reference().child("\(wallet)/pfp").getData(maxSize: 1 * 1024 * 1024) {
        (imageData, err) in
        if err != nil {
              print("error downloading image")
          } else {
              if let imageData = imageData {
                self.image = UIImage(data: imageData)!
              } else {
                    print("couldn't unwrap")
              }
          }
        }
    }
    
    var body: some View {
        ZStack {
            Text(OnboardSave)
                .opacity(0)
            Color(#colorLiteral(red: 0.992025435, green: 0.9831623435, blue: 0.8817279935, alpha: 1))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            ZStack(alignment: .topLeading){
                ScrollView {
                    if postCount1 == true {
                        Image(uiImage: firstPhoto)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 390, height: 390, alignment: .center)
                            .clipped()
                    }
                    else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                Image(uiImage: firstPhoto)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 390, height: 390, alignment: .center)
                                    .clipped()
                                if thumbnail1 != [UIImage]() {
                                    ForEach(thumbnail1, id: \.self) { thing in
                                        Image(uiImage: thing)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 390, height: 390, alignment: .center)
                                            .clipped()
                                    }
                                }
                            }
                        }
                    }
                    VStack{
                        HStack {
                            Text(title)
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                            Spacer()
                            Text("$\(self.price)")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                                .bold()
                        }
                        .frame(width: 350, alignment: .leading)
                        .padding()
                        Text("Description")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(width: 350, alignment: .leading)
                        Text(self.description)
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(width: 350, alignment: .leading)
                        Spacer()
                            .frame(height:40)
                        Text("Category")
                            .bold()
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(width: 350, alignment: .leading)
                        Text(self.category)
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .frame(width: 350, alignment: .leading)
                        Spacer()
                            .frame(height:40)
                        HStack {
                            Text("Zipcode:")
                                .bold()
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                            Text(String(self.zipcode))
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        Spacer()
                    }
                    .padding(.top, 1)
                    VStack {
                        HStack {
                            Image(uiImage: self.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                            Text(username)
                                .bold()
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                        }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                    .padding(.top, 10)
                }
                Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                        }) {
                            ZStack {
                                Ellipse()
                                    .fill(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                                .frame(width: 50, height: 50)
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                            }
                            .padding(.leading, 20)
                            .padding(.top, 20)
                }
                HStack(alignment: .center) {
                    if username == wallet {
                        Button(action: {}, label: {
                            ZStack {
                                Ellipse()
                                    .fill(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                                .frame(width: 50, height: 50)
                                Image(systemName: "message")
                                    .foregroundColor(.black)
                            }
                            .padding(.top, 20)
                            .padding(.trailing, 20)
                        })
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            //.navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            //.navigationBarItems(leading: btnBack)
            //.navigationBarTitle("", displayMode: .inline)
            .onAppear{
                loader()
                accessToken()
            }
            VStack{
                Spacer()
                Button(action: {
                accessToken()
                if address == "" {
                    print("address = ''")
                    return
                }
                if price == 0 {
                    print("price = 0")
                    return
                }
                let fee = Double(price) / 20
                guard let url = URL(string: "https://api-m.sandbox.paypal.com/v2/checkout/orders"),
                      let payload = """
                {"intent": "CAPTURE",
                "purchase_units": [{
                  "amount": {
                    "currency_code": "USD",
                    "value": "\(price)"
                  },
                  "payee": {
                    "email_address": "\(address)"
                  },
                  "payment_instruction": {
                    "disbursement_mode": "INSTANT",
                    "platform_fees": [{
                      "amount": {
                        "currency_code": "USD",
                        "value": "\(fee)"
                      },
                         "payee": {
                             "email_address": "sb-zn7ds6845962@business.example.com"
                           }
                    }]
                  }
                }],
                 "application_context": {
                   "return_url": "https://google.com/",
                   "cancel_url": "https://github.com/"
                 }
                }
                """.data(using: .utf8) else
                {
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("Bearer \(toke)", forHTTPHeaderField: "Authorization")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = payload

                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    guard error == nil else { print(error!.localizedDescription); return }
                    guard let data = data else { print("Empty data"); return }
                    if let str = String(data: data, encoding: .utf8) {
                            print(str)
                        }
                    let decoder = JSONDecoder()
                    let OnboardData = try? decoder.decode(Buyer.self, from: data)
                    OnboardId = OnboardData!.id
                    print(OnboardId)
                    OnboardSave = OnboardData!.links[1].href
                    print(OnboardSave)
                    DispatchQueue.main.async {
                        self.showUrl = true
                    }
                }.resume()}, label: {
                    Text("Buy")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                        .frame(width: 300, height: 50)
                        .background(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                        .cornerRadius(30)
                })
            }
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity)
        }
        .sheet(isPresented: $showUrl, onDismiss: {
            guard let url = URL(string: "https://api-m.sandbox.paypal.com/v2/checkout/orders/\(self.OnboardId)/capture") else
            {
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("Bearer \(toke)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { print("Empty data"); return }
                
                if let str = String(data: data, encoding: .utf8) {
                        print(str)
                    }
            }
            .resume()
        }) {
            VStack {
                NavigationView {
                    //WebView(url: OnboardSave)
                    WebView(url: OnboardSave//,
                    //                                allowedHosts: ["github", ".com"],
                    //                                forbiddenHosts: [".org", "google"],
                    //                                credential: URLCredential(user: "user", password: "password", persistence: .none)
                    ){ (onNavigationAction) in
                        switch onNavigationAction {
                        case .decidePolicy(let webView, let navigationAction, let policy):
                            print("WebView -> \(String(describing: webView.url)) -> decidePolicy navigationAction: \(navigationAction)")
                            switch policy {
                            case .cancel:
                                print("WebView -> \(String(describing: webView.url)) -> decidePolicy: .cancel")
                                showUrl = false
                            case .allow:
                                print("WebView -> \(String(describing: webView.url)) -> decidePolicy: .allow")
                            @unknown default:
                                print("WebView -> \(String(describing: webView.url)) -> decidePolicy: @unknown default")
                            }
                            
                        case .didRecieveAuthChallenge(let webView, let challenge, let disposition, let credential):
                            print("WebView -> \(String(describing: webView.url)) -> didRecieveAuthChallange challenge: \(challenge.protectionSpace.host)")
                            print("WebView -> \(String(describing: webView.url)) -> didRecieveAuthChallange disposition: \(disposition.rawValue)")
                            if let credential = credential {
                                print("WebView -> \(String(describing: webView.url)) -> didRecieveAuthChallange credential: \(credential)")
                            }
                            
                        case .didStartProvisionalNavigation(let webView, let navigation):
                            if String(describing: webView.url!.absoluteString).contains("github"){
                                print("WebView -> \(String(describing: webView.url!.absoluteString)) -> didReceiveServerRedirectForProvisionalNavigation: \(navigation)")
                                showUrl = false
                            }
                        case .didReceiveServerRedirectForProvisionalNavigation(let webView, let navigation):
                            if String(describing: webView.url!.absoluteString).contains("google"){
                                print("WebView -> \(String(describing: webView.url!.absoluteString)) -> didReceiveServerRedirectForProvisionalNavigation: \(navigation)")
                                showUrl = false
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        case .didCommit(let webView, let navigation):
                            print("WebView -> \(String(describing: webView.url)) -> didCommit: \(navigation)")
                        case .didFinish(let webView, let navigation):
                            print("WebView -> \(String(describing: webView.url)) -> didFinish: \(navigation)")
                        case .didFailProvisionalNavigation(let webView, let navigation, let error):
                            print("WebView -> \(String(describing: webView.url)) -> didFailProvisionalNavigation: \(navigation)")
                            print("WebView -> \(String(describing: webView.url)) -> didFailProvisionalNavigation: \(error)")
                        case .didFail(let webView, let navigation, let error):
                            print("WebView -> \(String(describing: webView.url)) -> didFail: \(navigation)")
                            print("WebView -> \(String(describing: webView.url)) -> didFail: \(error)")
                        }
                    }
                }
            }
        }
        
    }
}
