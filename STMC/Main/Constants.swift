//
//  Constants.swift
//  STMC
//
//  Created by Eric Zhang on 2019-11-30.
//  Copyright © 2019 Eric Zhang. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftyJSON

// Defines basic API information.
struct API {
    static let url = "https://app.stmc.bc.ca/api/"
    static let calendar = "https://app.stmc.bc.ca/api/calendar/"
}

let houseGradients = Gradient(colors: [Color("Darker STMC"), .STMC])

let houseGradient = [
    "Canterbury": Gradient(colors: [Color(red: 24/255, green: 107/255, blue: 60/255), Color(red: 29/255, green: 130/255, blue: 73/255)]),
    "Dublin": Gradient(colors: [Color(red: 0/255, green: 42/255, blue: 144/255), Color(red: 0/255, green: 85/255, blue: 183/255)]),
    "Limerick": Gradient(colors: [Color(red: 67/255, green: 15/255, blue: 118/255), Color(red: 80/255, green: 16/255, blue: 143/255)]),
    "London": Gradient(colors: [Color(red: 158/255, green: 51/255, blue: 0/255), Color(red: 219/255, green: 68/255, blue: 0/255)]),
    "Oxford": Gradient(colors: [Color(red: 191/255, green: 118/255, blue: 0/255), Color(red: 227/255, green: 164/255, blue: 63/255)]),
    "Waterford": Gradient(colors: [Color(red: 0/255, green: 81/255, blue: 129/255), Color(red: 63/255, green: 152/255, blue: 211/255)])
]

let houseColors = [
    "Canterbury": Color(red: 29/255, green: 130/255, blue: 73/255),
    "Dublin": Color(red: 0/255, green: 85/255, blue: 183/255),
    "Limerick": Color(red: 80/255, green: 16/255, blue: 143/255),
    "London": Color(red: 219/255, green: 68/255, blue: 0/255),
    "Oxford": Color(red: 227/255, green: 164/255, blue: 63/255),
    "Waterford": Color(red: 63/255, green: 152/255, blue: 211/255)
]

func sendRequest(url: String, completion: @escaping(JSON)->()) {
    guard let url = URL(string: url) else { return }
    
    let session = URLSession.shared
    session.dataTask(with: url) { (data, response, error) in
        if error != nil{
            let errorJSON = JSON.init(parseJSON: String("{ \"error\": \"\((error?.localizedDescription)!)\" }"))
            print((error?.localizedDescription)! as String)
            completion(errorJSON)
            return
        }
        
        let json = try! JSON(data: data ?? Data(), options: .allowFragments)
        
        completion(json)
        
    }.resume()
}

extension Color {
    static let STMC = Color("Default STMC Color")
    static let ACAS = Color("Academic Assembly Color")
    static let LTST = Color("Late Start Color")
    static let MASS = Color("Mass Color")
    static let MODF = Color("Modified Schedule Color")
    static let NSCH = Color("No School Color")
    static let STBR = Color("STMC Bright Color")
    static let SPGR = Color("Special Gray")
    static let SPAD = Color("STMC Adaptable")
    static let GR = Color("Gray")
    static let TBRC = Color("Tab Bar Color")
    static let LC = Color("Link Color")

}


struct Constants_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
