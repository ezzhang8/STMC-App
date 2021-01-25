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
    @Environment(\.presentationMode) private var presentationMode
    @State var width = UIScreen.main.bounds.width

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.STMC)
                .frame(width: self.width + 400, height: self.width + 200)
                .padding(.horizontal, -100)
                .offset(y: -self.width)
            ScrollView(showsIndicators: false) {
                VStack {
                    RemoteImage(url: URL(string: bulletin.imageLink!)!)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300)
                        .cornerRadius(10)
                        .padding(EdgeInsets(top: 75, leading: 0, bottom: 0, trailing: 0))
                    
                    VStack {
                        VStack(alignment: .leading) {
                            Text(bulletin.name)
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            Text(formatDate(dateString: bulletin.dateAdded))
                                .fontWeight(.semibold)
                                .font(.system(.subheadline, design: .rounded))
                                .padding(.bottom, 10)
                                .foregroundColor(Color.SPGR)
                            Divider()
                            Text(bulletin.description)
                                .font(.callout)
                                .padding(.bottom, 5)
                            
                            
                        }
                        .padding(15)
                        .frame(width: self.width-30)

                    }
                    .background(Color.TBRC)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    if bulletin.webLink != nil {
                        Button(action: {
                            openURL(URL(string: bulletin.webLink!)!)
                        }) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.white)
                                Text("Open Link")
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                        .background(LinearGradient(gradient: houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading))
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                        .padding(.vertical, 10)
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.TBRC)
                }
            }
            .position(x: 130, y: 35)
            .shadow(radius: 5)

        }
        .navigationBarHidden(true)
        .padding(.horizontal)
        .background(Color.GR.edgesIgnoringSafeArea(.all))
    }
}

struct BulletinHouseView: View {
    var bulletin: Bulletin
    @Environment(\.openURL) private var openURL
    @Environment(\.presentationMode) private var presentationMode
    @State var width = UIScreen.main.bounds.width
    
    init(bulletin: Bulletin) {
        self.bulletin = bulletin
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(houseColors[bulletin.house!]!)
                .frame(width: self.width + 400, height: self.width + 200)
                .padding(.horizontal, -100)
                .offset(y: -self.width)
            ScrollView(showsIndicators: false) {
                VStack {
                    Image(bulletin.house!)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .shadow(radius: 8)
                        .padding(.top, 75)
                    
                    VStack {
                        VStack(alignment: .leading) {
                            Text(bulletin.name)
                                .font(.system(.title2, design: .rounded))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            Text(formatDate(dateString: bulletin.dateAdded))
                                .fontWeight(.semibold)
                                .font(.system(.subheadline, design: .rounded))
                                .padding(.bottom, 10)
                                .foregroundColor(Color.SPGR)
                            Divider()
                            Text(bulletin.description)
                                .font(.callout)
                                .padding(.bottom, 5)
                            
                            
                        }
                        .padding(15)
                        .frame(width: self.width-30)

                    }
                    .background(Color.TBRC)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    if bulletin.webLink != nil {
                        Button(action: {
                            openURL(URL(string: bulletin.webLink!)!)
                        }) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.white)
                                Text("Open Link")
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                        }
                        .background(LinearGradient(gradient: houseGradient[bulletin.house!] ?? houseGradients, startPoint: .bottomTrailing, endPoint: .topLeading))
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                        .padding(.vertical, 10)
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.TBRC)
                }
            }
            .position(x: 130, y: 35)
            .shadow(radius: 5)

        }
        .navigationBarHidden(true)
        .padding(.horizontal)
        .background(Color.GR.edgesIgnoringSafeArea(.all))
    }
}

struct RemoteImage: View {
    var url: URL
    @StateObject var viewModel = ImageProvider()
    var body: some View {
        Image(uiImage: viewModel.image)
            .resizable()
            .onAppear {
                viewModel.loadImage(url: url)
            }
    }
}

class ImageProvider: ObservableObject {
    @Published var image = UIImage(named: "STMC")!
    private var cancellable: AnyCancellable?
    private let imageLoader = ImageLoader()

    func loadImage(url: URL) {
        self.cancellable = imageLoader.publisher(for: url)
            .sink(receiveCompletion: { failure in
            print(failure)
        }, receiveValue: { image in
            self.image = image
        })
    }
}

class ImageLoader {

    private let urlSession: URLSession
    private let cache: NSCache<NSURL, UIImage>

    init(urlSession: URLSession = .shared,
         cache: NSCache<NSURL, UIImage> = .init()) {
        self.urlSession = urlSession
        self.cache = cache
    }

    func publisher(for url: URL) -> AnyPublisher<UIImage, Error> {
        if let image = cache.object(forKey: url as NSURL) {
            return Just(image)
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        } else {
            return urlSession
                .dataTaskPublisher(for: url)
                .map(\.data)
                .tryMap { data in
                    guard let image = UIImage(data: data) else {
                        throw URLError(.badServerResponse, userInfo: [
                            NSURLErrorFailingURLErrorKey: url
                        ])
                    }
                    return image
                }
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveOutput: { [cache] image in
                    cache.setObject(image, forKey: url as NSURL)
                })
                .eraseToAnyPublisher()
        }
    }
}
