//
//  dataFiles.swift
//  AssignmentProject
//
//  Created by iOS on 06/08/2021.
//

import Foundation

enum Filter{
    case englandandwales
    case scotland
    case Northernirland
    case buntingholidaysonly
    case containnotes
    case None

}
class Bankholiday: Codable
{
    let englandAndWales, scotland, northernIreland: EnglandAndWales?

    enum CodingKeys: String, CodingKey {
        case englandAndWales = "england-and-wales"
        case scotland
        case northernIreland = "northern-ireland"
    }

    init(englandAndWales: EnglandAndWales?, scotland: EnglandAndWales?, northernIreland: EnglandAndWales?) {
        self.englandAndWales = englandAndWales
        self.scotland = scotland
        self.northernIreland = northernIreland
    }
}
class Newbankdata: Codable {
    let division: String?
    var events: [Event]?

    init(division: String?, events: [Event]?) {
        self.division = division
        self.events = events
    }
}

// MARK: - EnglandAndWales
class EnglandAndWales: Codable {
    let division: String?
    var events: [Event]?

    init(division: String?, events: [Event]?) {
        self.division = division
        self.events = events
    }
}

// MARK: - Event
class Event: Codable {
    let title, date: String?
    let notes: String?
    let bunting: Bool?

    init(title: String?, date: String?, notes: String?, bunting: Bool?) {
        self.title = title
        self.date = date
        self.notes = notes
        self.bunting = bunting
    }
}
class newEvent: Codable {
    let title, date,category: String?
    let notes: String?
    let bunting: Bool?

    init(title: String?, date: String?, notes: String?, bunting: Bool?,category: String?) {
        self.title = title
        self.date = date
        self.notes = notes
        self.bunting = bunting
        self.category = category
    }
}
enum Notes: String, Codable {
    case empty = ""
    case substituteDay = "Substitute day"
}


class ProfileInfo: Codable {
    let results: [Result]
 
    init(results: [Result] ) {
        self.results = results
     }
}
 

// MARK: - Result
class Result: Codable {
    let gender: String
    let name: Name
     let email: String
     let dob, registered: Dob
    let phone, cell: String
     let picture: Picture
    let nat: String

    init(gender: String, name: Name,  email: String,  dob: Dob, registered: Dob, phone: String, cell: String, picture: Picture, nat: String) {
        self.gender = gender
        self.name = name
         self.email = email
        self.dob = dob
        self.registered = registered
        self.phone = phone
        self.cell = cell
         self.picture = picture
        self.nat = nat
    }
}

// MARK: - Dob
class Dob: Codable {
    let date: String
    let age: Int

    init(date: String, age: Int) {
        self.date = date
        self.age = age
    }
}
/*


// MARK: - ID
class ID: Codable {
    let name, value: String

    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}
// MARK: - Location
class Location: Codable {
    let street: Street
    let city, state, country: String
    let postcode: Int
    let coordinates: Coordinates
    let timezone: Timezone

    init(street: Street, city: String, state: String, country: String, postcode: Int, coordinates: Coordinates, timezone: Timezone) {
        self.street = street
        self.city = city
        self.state = state
        self.country = country
        self.postcode = postcode
        self.coordinates = coordinates
        self.timezone = timezone
    }
}

// MARK: - Coordinates
class Coordinates: Codable {
    let latitude, longitude: String

    init(latitude: String, longitude: String) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - Street
class Street: Codable {
    let number: Int
    let name: String

    init(number: Int, name: String) {
        self.number = number
        self.name = name
    }
}

// MARK: - Timezone
class Timezone: Codable {
    let offset, timezoneDescription: String

    enum CodingKeys: String, CodingKey {
        case offset
        case timezoneDescription = "description"
    }

    init(offset: String, timezoneDescription: String) {
        self.offset = offset
        self.timezoneDescription = timezoneDescription
    }
}
 // MARK: - Login
class Login: Codable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String

    init(uuid: String, username: String, password: String, salt: String, md5: String, sha1: String, sha256: String) {
        self.uuid = uuid
        self.username = username
        self.password = password
        self.salt = salt
        self.md5 = md5
        self.sha1 = sha1
        self.sha256 = sha256
    }
}
*/
// MARK: - Name
class Name: Codable {
    let title, first, last: String

    init(title: String, first: String, last: String) {
        self.title = title
        self.first = first
        self.last = last
    }
}

// MARK: - Picture
class Picture: Codable {
    let large, medium, thumbnail: String

    init(large: String, medium: String, thumbnail: String) {
        self.large = large
        self.medium = medium
        self.thumbnail = thumbnail
    }
}
class Items {
    var title:String?
    var isSelected:Bool?
    var types:String?
    init(title:String?,isSelected:Bool?,types:String?) {
        self.title  = title
        self.isSelected = isSelected
        self.types = types
    }
}
