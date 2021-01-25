//
//  CourseView.swift
//  STMC
//
//  Created by Eric Zhang on 2020-10-26.
//  Copyright © 2020 Eric Zhang. All rights reserved.
//

import SwiftUI



let courseDict: [[Course]] = [
    [
        Course(name: "Woodwork 8", category: "Applied Arts", description: "The course is mainly an introduction to hand tools, with a variety of smaller power tools and machines being included.  The main objective is to provide a variety of woodworking experiences and techniques, which develop the students’ skills in proper woodworking procedures, including the safe setup, operation, general maintenance, and use of all the hand and power tools in the course.  Techniques for developing good designs, choosing and manufacturing the most appropriate wood joints, proper production procedures, assembly strategies and finishing techniques will also be covered.", qualities: ["Elective", "1/3 year"], teachers: ["Mr. Kinal"], prerequisites: nil, prerecommended: nil, corequisites: nil),
        Course(name: "Woodwork 9", category: "Applied Arts", description: "The emphasis in this course is to introduce students to the proper setup and safe use of power tools and power machines, primarily the table saw, radial arm saw, jointer and surface planer.  The use of the late is optional. By their choice of specific projects and assignments – coffee and end tables, medicine cabinets, chests of drawers, piano benches, etc. students develop specific skills, which will enable them to calculate materials and costs and to manufacture quality modern and/or traditional furniture.", qualities: ["Elective", "1/3 year"], teachers: ["Mr. Kinal"], prerequisites: nil, prerecommended: ["Woodwork 8"], corequisites: nil),
        Course(name: "Guitar Building 11/12", category: "Applied Arts", description: "We are also proud to offer a popular specialized course for students interested in building an electric or acoustic guitar. Students are instructed in a systematic building method. Each student is encouraged to use their creativity in design and finishing techniques. Career opportunities are presented in repairing and building guitars at the professional level. Students are exposed to a wide variety of music genres and are given lessons on how to play the guitar!", qualities: ["Elective"], teachers: ["Mr. Kinal"], prerequisites: nil, prerecommended: ["Woodwork 8", "Woodwork 9"], corequisites: nil)
    ],
    [
        Course(name: "Band 8", category: "Fine Arts (Music)", description: "This full year course is designed for Grade 8’s who are interested in playing in a concert band setting.  This on the timetable course allows students the opportunity to learn basic music theory, history, and performance skills on an approved concert band instrument.  During the course of the year students will rehearse, perform, and take part in clinics and workshops. Students are required to rent their own instrument for this course.  Prior musical training is not required for this class.", qualities: ["Elective"], teachers: ["Mr. Shoemaker"], prerequisites: nil, prerecommended: nil, corequisites: nil),
        Course(name: "Junior Concert Band 9/10", category: "Fine Arts (Music)", description: "This on the time table, full year course is designed to further the musical development within a concert band setting for students in Grade 9 and 10.  Students will be instructed in areas of music theory, listening, music history, and musical performance in various musical styles. Students are required to rent their own instrument for this course. Students must either have completed Grade 8 band or have permission of the Band Director to be eligible to take this course.  This course is a co-requisite for Jazz Band.", qualities: ["Elective"], teachers: ["Mr. Shoemaker"], prerequisites: nil, prerecommended: ["Band 8"], corequisites: nil),
        Course(name: "Senior Concert Band 11/12", category: "Fine Arts (Music)", description: "This on timetable full year course is open to students from grades 11 to 12 and is designed to develop students’ musical skills to a higher degree within a concert band setting.  Students will be further instructed in areas of music, theory, listening, music history, composition, and musical performance in various musical styles. Students are required to rent their own instrument for this course.  Students must either have completed Grade 10 band or have the permission of the Band Director to be eligible to take this course.", qualities: ["Elective"], teachers: ["Mr. Shoemaker"], prerequisites: nil, prerecommended: ["Band 10"], corequisites: nil),
        Course(name: "Jazz Band A/B", category: "Fine Arts (Music)", description: "This full year course meets regularly off the timetable. This auditioned group is open to students from Grades 8 to 12 who are selected based on their audition. Students will be instructed in advanced areas of Jazz theory, listening, Jazz history, composition, Jazz improvisation, and performance in the Jazz style.  Students are required to rent their own instrument for this course.  Students must either be enrolled in a concert band program or have the permission of the Band Director to be eligible to take this course.  All students must audition to be eligible for this class. They will be placed in either Jazz Band A or B dependent on their audition.", qualities: ["Elective", "Off-schedule"], teachers: ["Mr. Shoemaker"], prerequisites: nil, prerecommended: nil, corequisites: ["Band 8-12"]),
        Course(name: "Choir 8", category: "Fine Arts (Music)", description: "This year long course explores choral music from a wide variety of cultures, genres, and periods through study and performance.  Emphasis will be placed on developing the complete musicianship of each student through instruction on basic vocal technique, sight-reading sills, and introductory music theory.  In addition to our Christmas and Spring music nights, all choir students will have the opportunity to perform at music festivals, school masses and services, and are eligible to go on the STMC music trips.", qualities: ["Elective"], teachers: ["Mr. Lui"], prerequisites: nil, prerecommended: nil, corequisites: nil),
        Course(name: "Choir 9", category: "Fine Arts (Music)", description: "This yearlong course explores choral music from a wide variety of cultures, genres, and periods through study and performance.  Emphasis will be placed on developing the complete musicianship of each student through instruction on basic vocal technique, sight-reading sills, and music theory.  In addition to our Christmas and Spring music nights, all choir students will have the opportunity to perform at music festivals, school masses and services, and are eligible to go on the STMC music trips", qualities: ["Elective"], teachers: ["Mr. Lui"], prerequisites: nil, prerecommended: ["Choir 8"], corequisites: nil),
        Course(name: "Choir 10", category: "Fine Arts (Music)", description: "This yearlong course explores choral music from a wide variety of cultures, genres, and periods through study and performance.  Emphasis will be placed on developing the complete musicianship of each student through instruction on basic vocal technique, sight-reading sills, and music theory.  In addition to our Christmas and Spring music nights, all choir students will have the opportunity to perform at music festivals, school masses and services, and are eligible to go on the STMC music trips", qualities: ["Elective"], teachers: ["Mr. Lui"], prerequisites: nil, prerecommended: ["Choir 9"], corequisites: nil),
        Course(name: "Senior Concert Choir 11/12", category: "Fine Arts (Music)", description: "This yearlong course explores choral music from a wide variety of cultures, genres, and periods through study and performance.  Emphasis will be placed on developing the complete musicianship of each student through instruction on basic vocal technique, sight-reading skills, and advanced level music theory.  In addition to our Christmas and Spring music nights, all choir students will have the opportunity to perform at music festivals, school masses and services, and are eligible to go on the STMC music trips.", qualities: ["Elective"], teachers: ["Mr. Lui"], prerequisites: nil, prerecommended: ["Choir 10"], corequisites: nil),
        Course(name: "Chamber Choir", category: "Fine Arts (Music)", description: "This is an auditioned choir open to students in grades 9 to 12.  Students must be registered in the concert choir program to be eligible for this course.  Emphasis will be placed on performing challenging choral music from a wide variety of cultures, genres, and periods.  In addition to our Christmas and Spring music nights, the chamber singers will perform at various festivals throughout the lower mainland. Opening and remembrance mass, the STMC open house, the elementary recruitment tour, as well as a number of different performance engagements that come up throughout the course of the year.", qualities: ["Elective", "Off-schedule"], teachers: ["Mr. Lui"], prerequisites: nil, prerecommended: nil, corequisites: ["Choir 9-12"]),
        Course(name: "Jazz Choir", category: "Fine Arts (Music)", description: "This is an auditioned choir open to students in grades 10 to 12.  Students must be registered in the concert choir program to be eligible for this course.  Emphasis will be placed on performing a wide variety of vocal jazz repertoire as well as study of history and jazz theory.  In addition to our Christmas and Jazz music nights, the Jazz Singers also perform at various competitive festivals throughout the lower mainland and at occasional school functions.", qualities: ["Elective", "Off-schedule"], teachers: ["Mr. Lui"], prerequisites: nil, prerecommended: nil, corequisites: ["Choir 10-12"]),
        Course(name: "Recording & Sound 11/12", category: "Fine Arts (Music)", description: "The St. Thomas More Collegiate Music program is excited to offer a specialized Recording and Sound program for senior students in Grades 11 and 12. In this program, students will receive instruction and practice with live sound set up and design, basic music theory and composition, live studio recording techniques, and MIDI composition creation. Students will use current recording software and equipment to create various projects including covers, originals, and soundscapes.", qualities: ["Elective"], teachers: ["Mr. Shoemaker"], prerequisites: nil, prerecommended: nil, corequisites: nil)
    ],
    [
        Course(name: "Drama 8", category: "Fine Arts (Theatre)", description: "This course allows students to learn and develop communication skills and gain speaking and performing confidence.  Students partake in improv activities, learn about theatre history and vocabulary and work collaboratively with their peers to create and perform scenes based on a variety of concepts.", qualities: ["Elective", "1/3 year"], teachers: ["Ms. Stepkowski"], prerequisites: nil, prerecommended: nil, corequisites: nil),
        Course(name: "Drama 9", category: "Fine Arts (Theatre)", description: "This class builds upon the skills explored in Drama 8.  Students participate in various activities, which help them develop their creativity and concentration skills.  Students are also introduced to basic theater terminology. The skills that are learned in this class can also be used in other classes.", qualities: ["Elective", "1/3 year"], teachers: ["Ms. Stepkowski"], prerequisites: nil, prerecommended: ["Drama 8"], corequisites: nil),
        Course(name: "Drama 10-12", category: "Fine Arts (Theatre)", description: "In Drama (Theatre Production) 10-12, we continue working on some of the advanced skills necessary to play for truth on stage. Building on scene work and improvisational skills, students focus primarily on the elements of effective dramaturgy and storytelling, with an eye to creating and performing in front of an audience. To that end, we write and perform short pieces based on personal experience, create outlines based on a hero’s journey, and stage and perform scenes around dramatic moments. As well, students work on short one-act plays with the emphasis placed on staging, production values, and playing honestly and simply.", qualities: ["Elective"], teachers: ["Ms. Stepkowski"], prerequisites: nil, prerecommended: ["Drama 9"], corequisites: nil)

    
    ],
    [
        Course(name: "Art 8", category: "Fine Arts (Visual Arts)", description: "Art 8 provides students with an introduction to Visual Arts at a secondary level.  In Art 8, students will use a variety or art media, which include graphite, ink, charcoal, pencil crayon, collage material and water colour paint. Students will complete sketchbook activities and drawing tutorials that reinforce the skills and techniques learned in the classroom and modeled in the studio.  The students will engage in an extensive study of the visual Elements of Art and Design. These elements are line, colour, form, space, shape, texture, value and tone. The focus on Art 8 is to have fun and learn about Visual Art. The focus of Art 8 is to have fun and learn about Visual Art", qualities: ["Elective", "1/3 year"], teachers: ["Ms. Codd"], prerequisites: nil, prerecommended: nil, corequisites: nil),
        Course(name: "Art 9", category: "Fine Arts (Visual Arts)", description: "Art 9 allows students to expand upon the visual art styles and methods studied and work towards mastering the art media they were introduced to in Art 8.  Students will complete sketchbook activities and drawing tutorials that reinforce the skills and techniques learned in the classroom and modeled in the studio. Students engage in an intensive study of the visual Principles of Art and Design: balance, movement, rhythm, contrast, emphasis, pattern & unity.  The focus of Art 9 is to have fun and develop confidence using various art media.", qualities: ["Elective", "1/3 year"], teachers: ["Ms. Codd"], prerequisites: nil, prerecommended: ["Art 8"], corequisites: nil),
        Course(name: "Art 10", category: "Fine Arts (Visual Arts)", description: "In Art 10, students experiment with a wide range of processes, materials and technologies, both individually and collaboratively to explore their identity and sense of belonging. They develop skills and techniques in a range of styles and movements, comment on social and environmental issues and explore traditions, perspectives, and worldviews through visual arts.", qualities: ["Elective"], teachers: ["Ms. Codd"], prerequisites: nil, prerecommended: ["Art 9"], corequisites: nil),
        Course(name: "Art 11", category: "Fine Arts (Visual Arts)", description: "In Art 11, students reflect on the interconnectedness of the individual, community, history and society. Working individually and collaboratively, students use imagination, observation and inquiry to create meaningful artistic expression to represent personal identity and cultural expression. Engaging in risk taking, and problem solving, they develop artworks with a specific audience in mind, using visual arts to communicate and respond to social and environmental issues and connect to their personal values.", qualities: ["Elective"], teachers: ["Ms. Codd"], prerequisites: nil, prerecommended: ["Art 10"], corequisites: nil),
        Course(name: "Art 12", category: "Fine Arts (Visual Arts)", description: "In Art 12, students refine artistic skills, and make purposeful artistic choices to enhance the depth and passion of their message. Students create works to reflect their own personal voice, story and values in connection with a specific place, time and context. Working individually and collaboratively, they combine various materials and processes, demonstrate creative thinking and innovation to communicate ideas and express emotions.", qualities: ["Elective"], teachers: ["Ms. Codd"], prerequisites: nil, prerecommended: ["Art 11"], corequisites: nil),
        Course(name: "Architectural Design 10-12", category: "Fine Arts (Visual Arts)", description: "Architectural Design students will explore Industrial, Interior, Landscape and Architectural Design. Through the design process and study of 20th century architects and their philosophies students will solve design problems, create various types of design drawings, build real and 3D models, construct animation walkthroughs, and create technical drawings used for fabrication and construction. Students will collaborate with others to communicate ideas and participate in critiques and presentations. Students will also learn to use tools and technologies used in design fields today such as AutoCAD, Revit, Sketch Up, Blender, and Photoshop.", qualities: ["Elective"], teachers: ["Ms. Codd"], prerequisites: nil, prerecommended: nil, corequisites: nil)


    ]
]

let categoryDict: [Course] = [
    Course(name: "Applied Arts", category: "", color: Color.orange, symbol: "hammer.fill", description: "", subcourses: courseDict[0]), Course(name: "Fine Arts (Music)", category: "", color: Color.purple, symbol: "music.note", description: "", subcourses: courseDict[1]), Course(name: "Fine Arts (Theatre)", category: "", color: Color.green, symbol: "person.3.fill", description: "", subcourses: courseDict[2]), Course(name: "Fine Arts (Visual Arts)", category: "", color: Color.blue, symbol: "paintbrush.fill", description: "", subcourses: courseDict[3])
]

struct CourseView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView {
            List(categoryDict, children: \.subcourses) { category in
                HStack {
                    if category.symbol != nil {
                        Image(systemName: category.symbol ?? "")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(category.color)
                    }
                    if category.description != "" {
                        NavigationLink(destination: CourseDetails(course: category)) {
                            Text(category.name)
                                .font(.system(.headline, design: .rounded))
                                .bold()

                        }
                        
                    }
                    else {
                        Text(category.name)
                            .font(.system(.title3, design: .rounded))
                            .bold()
                            .foregroundColor(category.color)

                    }
                }
            }
            .accentColor(Color.primary)
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Courses"))
            .navigationBarItems(leading:
                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.down")
                        .resizable()
                        .accentColor(.STMC)
                        .scaledToFit()
                }
                .frame(width: 20, height: 20)
            )
        }
        .accentColor(.STMC)
        .font(.body)
    }
}

struct Course: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var category: String
    var color: Color?
    var symbol: String?
    var description: String
    var qualities: [String]?
    var teachers: [String]?
    var prerequisites: [String]?
    var prerecommended: [String]?
    var corequisites: [String]?
    var subcourses: [Course]?
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView()
    }
}
