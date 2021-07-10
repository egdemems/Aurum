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
    
    var ref = Database.database().reference()
    
    var username: String
    
    var name: String
    
    @State var postCount1 = 0
    
    @State var thumbnail1 = [UIImage]()
    
    @State var description = ""
    
    @State var price = 0
    
    func loader() {
        ref.child("\(name)/image_count").getData {
            (error, snapshot) in
            let pop = snapshot.value as? Int
            self.postCount1 = pop!
            if pop! != 0 {
                for x in 1...pop! {
                    ref.child("\(name)/image_\(x)").observe(.value) {
                        (snapshot) in
                        let pop1 = snapshot.value as? String
                        Storage.storage().reference().child("\(pop1!)").getData(maxSize: 1 * 10000 * 10000) {
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
        ref.child("\(name)/description").getData {
            (error, snapshot) in
            let pop = snapshot.value as? String
            self.description = pop ?? "No Description"
        }
        ref.child("\(name)/price").getData {
            (error, snapshot) in
            let pop = snapshot.value as? Int
            self.price = pop ?? 0
        }
    }
    
    var body: some View {
            VStack{
                ScrollView{
                    Text(username)
                        .font(.system(size: 20, design: .rounded))
                        .frame(width: 350, alignment: .leading)
                        .foregroundColor(.black)
                        .padding()
                    if self.thumbnail1.count == postCount1 {
                        if postCount1 == 1 {
                            ForEach(thumbnail1, id: \.self) { thing in
                                Image(uiImage: thing)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 350, height: 350, alignment: .center)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                        }
                        else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(thumbnail1, id: \.self) { thing in
                                        Image(uiImage: thing)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 350, height: 350, alignment: .center)
                                            .clipped()
                                            .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    else {
                        Image("greyPost")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 350, alignment: .center)
                            .clipped()
                            .cornerRadius(10)
                    }
                    VStack {
                        Text("Description")
                            .font(.system(size: 25, design: .rounded))
                            .frame(width: 350, alignment: .leading)
                            .foregroundColor(.black)
                        Text(self.description)
                            .font(.system(size: 20, design: .rounded))
                            .frame(width: 350, alignment: .leading)
                            .foregroundColor(.black)
                    }
                    .padding()
                    Text("Points: \(self.price)")
                        .font(.system(size: 20, design: .rounded))
                        .frame(width: 350, alignment: .leading)
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                }
                .padding(.top, 1)
            }
            .navigationBarTitle("", displayMode: .inline)
            .onAppear{
                    loader()
            }
    }
}
