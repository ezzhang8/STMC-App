//
//  ScheduleCard.swift
//  STMC
//
//  Created by Eric Zhang on 2019-11-30.
//  Copyright © 2019 Eric Zhang. All rights reserved.
//

import SwiftUI

struct ScheduleCard: View {
    var schedule: Schedule
    var seniority: String
    var body: some View {
        NavigationLink(destination: ScheduleDetails(schedule: schedule, seniority: seniority)) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 75)
                    .foregroundColor(colorMatch(scheduleType: schedule.scheduleType))
                    
                VStack(alignment: .leading){
                    HStack() {
                        VStack(alignment: .leading){
                            Text(schedule.summary)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.leading)
                            
                            Text("\(schedule.scheduleType) (\(schedule.scheduleFamily))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.white)
                                .padding(.leading)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        Spacer()
                        VStack(alignment: .center, spacing: -5.0) {
                            Text(schedule.dotw)
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.horizontal)
                            Text(formatDay(dayString: schedule.startDate))
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.white)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 5)
            .shadow(radius: 5)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1, anchor:.center)
    }
}

func formatDay(dayString: String) -> String {
    if String(dayString.suffix(2)).hasPrefix("0") {
        return String(dayString.suffix(1))
    }
    else {
        return String(dayString.suffix(2))
    }
}

private func colorMatch(scheduleType: String) -> Color {
    let colorDict = [
        "Regular Schedule": Color.SPAD,
        "CLE/CLC/Staff Meeting Schedule": Color.ACAS,
        "Mass Schedule": Color.MASS,
        "Modified Schedule": Color.MODF
    ]
    
    if colorDict[scheduleType] != nil {
        return colorDict[scheduleType]!
    }
    else {
        return Color.MODF
    }
}


