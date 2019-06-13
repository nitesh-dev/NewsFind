
import Foundation

struct WeatherModel: Codable {
    let weather : [Weather]?
    let main: MainBlock?
    let wind: Wind?
    let name: String?
    let visibility: Double?
    enum CodingKeys: String, CodingKey {
        
        case weather = "weather"
        case main = "main"
        case wind = "wind"
        case name = "name"
        case visibility = "visibility"
    }
}
struct Weather : Codable {
    let id : Int?
    let main : String?
    let desc : String?
    let icon : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case main = "main"
        case desc = "description"
        case icon = "icon"
    }
}
struct MainBlock: Codable {
    let temp: Float?
    let pressure: Double?
    let humidity: Double?
    let temp_min: Float?
    let temp_max: Float?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case temp_min = "temp_min"
        case temp_max = "temp_max"
    }
}
struct Wind: Codable {
    let speed: Float?
    let degree: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case degree = "degree"
    }
}


