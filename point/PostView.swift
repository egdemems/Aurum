//
//  PostView.swift
//  point
//
//  Created by Harrison Sherwood on 7/9/21.
//

import SwiftUI
import FirebaseStorage
import FirebaseDatabase

struct Post: Hashable {
    var id = UUID()
    var image: UIImage
    var postNum: String
}

struct PostView: View {
    
    var ref = Database.database().reference()
    
    @AppStorage("showingPhoto") var showingPhoto = false
    
    @AppStorage("wallet") var wallet:String = ""
    
    @State var thumbnail = [Post]()
    
    @State var adder = [String]()
    
    @State var postsLen = 0
    
    @State var firstLoad = true
    
    //@State var firstLoad = true
    
    var twoColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    func loader() {
        ref.child("\(wallet)/posts").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                if adder.contains("\(wallet)/posts/\(key)") {
                    print("already loaded")
                }
                else {
                    ref.child("\(wallet)/posts/\(key)/image_1").getData {
                        (err, snapshot) in
                        let pop = snapshot.value as? String
                        if pop != nil {
                            Storage.storage().reference().child("\(pop!)").getData(maxSize: 1 * 1024 * 1024) {
                            (imageData, err) in
                            if err != nil {
                                  print("error downloading image")
                              } else {
                                  if let imageData = imageData {
                                    self.thumbnail.insert(Post(image: UIImage(data: imageData)!, postNum: "\(wallet)/posts/\(key)"), at: 0)
                                    self.adder.append("\(wallet)/posts/\(key)")
                                  } else {
                                        print("couldn't unwrap")
                                  }
                              }
                            }
                        }
                    }
                }
            }
        })
    }
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 30)
            Button(action: {self.showingPhoto = true}, label: {
                Text("List an item")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 20)
            })
            .padding()
            .background(Color(red: 255 / 255, green: 211 / 255, blue: 138 / 255))
            ScrollView {
                Spacer()
                    .frame(height: 30)
                Text("Your Listings")
                    .font(.system(size: 25))
                    .frame(width: 350 , height: 20, alignment: .leading)
                    .foregroundColor(.black)
                Spacer()
                    .frame(height: 10)
                if thumbnail == [Post]() {
                    Text("")
                }
                else {
                    LazyVGrid(columns: twoColumnGrid) {
                        ForEach(thumbnail, id: \.self) { thing in
                            NavigationLink(destination: PostSubView(username: wallet,firstPhoto: thing.image, name: thing.postNum)) {
                                Image(uiImage: thing.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 190, height: 190, alignment: .topLeading)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .padding(.top, 1)
            .sheet(isPresented: $showingPhoto, onDismiss: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        loader()
                    }
            }) {
                Photo()
            }
        }
        .onAppear{
            if firstLoad == true {
                loader()
                firstLoad = false
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
