//
//  BulletinView.swift
//  STMC
//
//  Created by Eric Zhang on 2020-08-22.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import Combine


struct BulletinView: View {
    var bulletin: Bulletin
    @Environment(\.openURL) var openURL

    var body: some View {
        
        ScrollView {
            Section {
                VStack {
                    RemoteImage(url: bulletin.imageLink)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)
                        .cornerRadius(10)
                    Text(bulletin.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text(formatDate(dateString: bulletin.dateAdded))
                        .font(.headline)
                        .fontWeight(.light)
                        .textCase(.uppercase)
                        .padding(.bottom, 10)
                        .padding(.top, 5)
                    Divider()
                    Text(bulletin.description)
                        .font(.callout)
                        .padding(.bottom, 5)
                    Button(action: {openURL(URL(string: bulletin.webLink)!)}, label: {
                        Text("Visit Link")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                    .padding(.bottom, 10)
                    
                }
            }
            .navigationBarTitle(Text("Bulletin"))
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

struct RemoteImage: View {
    @ObservedObject var imageLoader = ImageLoader()
    var placeholder: Image
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        imageLoader.fetchImage(url: url)
    }
    
    var body: some View {
        if let image = self.imageLoader.downloadImage {
            
            
            return Image(uiImage: image).resizable()
        }
        return placeholder
    }
}

class ImageLoader: ObservableObject {
    @Published var downloadImage: UIImage?
    
    func fetchImage(url: String) {
        guard let imageURL = URL(string: url) else {
            fatalError("The URL string is invalid.")
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else {
                fatalError(error!.localizedDescription)
            }
            DispatchQueue.main.async {
                self.downloadImage = UIImage(data: data)
        
            }
        }.resume()
    }
}
