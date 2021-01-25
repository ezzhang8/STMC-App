//
//  CourseDetails.swift
//  STMC
//
//  Created by Eric Zhang on 2020-10-26.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI

struct CourseDetails: View {
    var course: Course
    
    var body: some View {
        List {
            Section (header:
                HStack {
                    Text(course.name)
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .textCase(.none)
                        .foregroundColor(Color.primary)
                }
            ){
                HStack {
                    Image(systemName: "rectangle.grid.1x2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20.0, height: 20.0)
                    Text("Category")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(course.category)
                }
                HStack {
                    Image(systemName: "tag.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20.0, height: 20.0)
                    Text("Type")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String((course.qualities)!.map(String.init).joined(separator: ", ")))
                }
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20.0, height: 20.0)
                    Text("Teachers")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String((course.teachers)!.map(String.init).joined(separator: ", ")))
                }

            }
       
            Section (header:
                HStack {
                    Text("Description")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .textCase(.none)
                        .foregroundColor(Color.primary)
                }
            ){
                Text(course.description)
            }
            
            if course.prerecommended != nil {
                Section (header:
                    HStack {
                        Text("Prerequisites (Recommended)")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
                    }
                ){
                    Text(String((course.prerecommended)!.map(String.init).joined(separator: ", ")))
                }
            }
            if course.prerequisites != nil {
                Section (header:
                    HStack {
                        Text("Prerequisites (Mandatory)")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
                    }
                ){
                    Text(String((course.prerequisites)!.map(String.init).joined(separator: ", ")))
                }
            }
            if course.corequisites != nil {
                Section (header:
                    HStack {
                        Text("Corequisites")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
                    }
                ){
                    Text(String((course.corequisites)!.map(String.init).joined(separator: ", ")))
                }
            }

        }
        .listStyle(InsetGroupedListStyle())
        .accentColor(Color.primary)
        .navigationBarTitle(Text("Course"))


    }
}
