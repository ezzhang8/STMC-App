//
//  CalendarDetails.swift
//  STMC
//
//  Created by Eric Zhang on 2020-07-04.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI
import MobileCoreServices
import EventKit
import EventKitUI

struct CalendarDetails: View {
    @Environment(\.openURL) var openURL
    @State private var showAlert = false
    @ObservedObject var eventSaver = CalendarSaver()
    var CalendarEvent: CalendarEvent?
    
    var alert: Alert {
        Alert(title: Text(eventSaver.completionTitle), message: Text(eventSaver.completionMsg), dismissButton: .default(Text("OK")))
    }
    var body: some View {
        List {
            Section (header:
                HStack {
                    Image(systemName: "pencil.and.outline")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.primary)
                    Text(CalendarEvent?.summary ?? "Error")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .textCase(.none)
                        .foregroundColor(Color.primary)
                }
            ){
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 20.0, height: 20.0)
                    Text("Date")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(CalendarEvent?.startDate ?? "Error")
                }
                if CalendarEvent?.startTime != nil {
                    HStack {
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 20.0, height: 20.0)
                        Text("Time")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(formatDateTime(dateString: CalendarEvent?.startTime)! + "–"+formatDateTime(dateString: CalendarEvent?.endTime)!)
                    }
                }
            }
            if CalendarEvent?.description != nil && !(CalendarEvent?.description?.contains("</"))!{
                Section (header:
                    HStack {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color.primary)
                        Text("Description")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)
                            .textCase(.none)
                            .foregroundColor(Color.primary)
                    }
                ){
                    HStack {
                        Text((CalendarEvent?.description)!)
                            .contextMenu(ContextMenu(menuItems: {
                                Button(action: {UIPasteboard.general.setValue(CalendarEvent?.description as Any,forPasteboardType: kUTTypePlainText as String)}, label: {
                                    Text("Copy to Clipboard")
                                    Image(systemName: "doc.on.doc")
                                })
                            }))
                    }
                }
            }
                
            Section (header:
                HStack {
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.primary)
                    Text("Actions")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .textCase(.none)
                        .foregroundColor(Color.primary)
                        
                }
            ){
                Button(action: {
                    eventSaver.saveEventToCalendar(CalendarEvent: CalendarEvent!)
                    self.showAlert.toggle()
                }) {
                    HStack {
                        Text("Save Event to Calendar")
                        Spacer()
                        Image(systemName: "calendar.badge.plus")
                    }
                    
                }
                .alert(isPresented: $showAlert, content: {self.alert})
                .foregroundColor(.STMC)
                Button(action: {
                    openURL(URL(string: CalendarEvent!.htmlLink)!)
                }) {
                    HStack {
                        Text("Open in Browser")
                        Spacer()
                        Image(systemName: "safari")
                    }
                }
                .foregroundColor(.STMC)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text(formatTitle(eventName: CalendarEvent?.summary ?? "Event")))
        .font(.body)
    }
}

class CalendarSaver: ObservableObject {
    @Published var completionTitle: String
    @Published var completionMsg: String
    
    init() {
        self.completionTitle = ""
        self.completionMsg = ""
    }
    func saveEventToCalendar(CalendarEvent: CalendarEvent) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                let event:EKEvent = EKEvent(eventStore: eventStore)
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en-US")
                
                event.title = CalendarEvent.summary
                
                if CalendarEvent.startTime == nil {
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    event.isAllDay = true
                    event.startDate = dateFormatter.date(from: CalendarEvent.startDate)
                    event.endDate = dateFormatter.date(from: CalendarEvent.endDate)
                }
                else {
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                    
                    event.isAllDay = false
                    event.startDate = dateFormatter.date(from: CalendarEvent.startTime!)
                    event.endDate = dateFormatter.date(from: CalendarEvent.endTime!)
                }
                event.notes = CalendarEvent.description ?? ""
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    
                    
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                    
                    DispatchQueue.main.async {
                        self.completionTitle = "Error saving"
                        self.completionMsg = error as! String
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.completionTitle = "Event Saved"
                    self.completionMsg = "You can now view this event in your default calendar in the Calendar app."
                }
            }
            else {
                DispatchQueue.main.async {
                    self.completionTitle = "Access not granted"
                    self.completionMsg = "STMC does not have permission to access the Calendar to add events."
                }
            }
        }
    }
    
}

private func saveEventToCalendar(CalendarEvent: CalendarEvent) {
    let eventStore = EKEventStore()
    eventStore.requestAccess(to: .event) { (granted, error) in
        if (granted) && (error == nil) {
            let event:EKEvent = EKEvent(eventStore: eventStore)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en-US")
            
            event.title = CalendarEvent.summary
            
            if CalendarEvent.startTime == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd"

                event.isAllDay = true
                event.startDate = dateFormatter.date(from: CalendarEvent.startDate)
                event.endDate = dateFormatter.date(from: CalendarEvent.endDate)
            }
            else {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                                
                event.isAllDay = false
                event.startDate = dateFormatter.date(from: CalendarEvent.startTime!)
                event.endDate = dateFormatter.date(from: CalendarEvent.endTime!)
            }
            event.notes = CalendarEvent.description ?? ""
            event.calendar = eventStore.defaultCalendarForNewEvents
            
            do {
                try eventStore.save(event, span: .thisEvent)
            } catch let error as NSError {
                print("failed to save event with error : \(error)")
            }
        }
    }
}

private func formatTitle(eventName: String)-> String {
    if eventName.count < 25 {
        return eventName
    }
    else {
        return "Event"
    }
}

// Returns the time given an ISO timestamp
private func formatDateTime(dateString: String?) -> String? {
    if dateString != nil {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
        let date = dateFormatter.date(from: dateString!)
        dateFormatter.dateFormat = "h:mm a"
        
        return dateFormatter.string(from: date ?? Date())
    }
    return nil
}

struct CalendarDetails_Previews: PreviewProvider {
    static var previews: some View {
        CalendarDetails()
    }
}
