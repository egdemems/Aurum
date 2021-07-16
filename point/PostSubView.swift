//
//  PostSubView.swift
//  point
//
//  Created by Harrison Sherwood on 7/9/21.
//

import SwiftUI
import FirebaseDatabase
import FirebaseStorage

struct PostSubView: View {
    
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
                            Text("\(self.price)")
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
                                    .foregroundColor(.white)
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
                                    .foregroundColor(.white)
                            }
                            .padding(.top, 20)
                        })
                        Button(action: {}, label: {
                            Text("Buy")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                                .frame(width: 100, height: 50)
                                .background(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
                                .cornerRadius(30)
                        })
                        .padding(.trailing, 20)
                        .padding(.top, 20)
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
            }
        }
        
    }
}
