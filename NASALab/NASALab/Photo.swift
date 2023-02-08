//
//  Photo.swift
//  NASALab
//
//  Created by Tati on 2/3/23.
//


import Foundation


//structure of api for decoding
//will need only rover, earth_date and img_src

struct PhotoDisplay:Codable {
    let photos: [Photo]
}

struct Photo:Identifiable,Codable {
    var id : Int
    var sol : Int
    var camera : Camera
    var img_src : String
    var earth_date : String
    var rover : Rover
    
}


struct Camera:Identifiable,Codable {
    var id : Int
    var name : String
    var rover_id : Int
    var full_name : String
}


struct Rover:Identifiable,Codable {
    var id : Int
    var name : String
    var landing_date : String
    var launch_date : String
    var status : String
}
