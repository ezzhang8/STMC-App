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
    static let url = "https://ericzhang.ca/app/api/"
    static let calendar = "https://m-gapdev.stthomasmorecollegiate.ca/temp/tv/calendar.php"
}

let houseGradients = Gradient(colors: [Color("Darker STMC"), .STMC])

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
        let json = try! JSON(data: data!)
        
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
