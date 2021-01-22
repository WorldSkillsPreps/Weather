import SwiftUI
import Alamofire

struct WeatherNow: View {
    @Binding var city: City
    @State var weather: Weather? = nil
    var body: some View {
        VStack{
            if weather != nil{
                Text(weather!.name)
                    .font(.system(size: 30))
                Text(weather!.weather[0].description)
                HStack{
                    Text("\(Int(weather!.main.temp) - 274)")
                        .font(.system(size: 60))
                    VStack{
                        Circle()
                            .strokeBorder(Color.white, lineWidth: 3)
                            .frame(width: 20, height: 20)
                            .padding(.bottom, 30)
                    }
                }
                HStack{
                    Text("Макс.\(Int(weather!.main.temp_max) - 274)")
                    Text("мин.\(Int(weather!.main.temp_min) - 274)")
                }
                .font(.system(size: 20))
            }
        }.foregroundColor(.white)
        .onAppear(perform: {
            AF.request(
                "http://api.openweathermap.org/data/2.5/weather?",
                method: .get,
                parameters: [
                    "q": city.name,
                    "appid": appId
                ],
                encoding: URLEncoding.queryString,
                headers: [
                    HTTPHeader(name: "Content-Type", value: "application/json"),
                    HTTPHeader(name: "Accept", value: "application/json")
                ])
                .validate(statusCode: 200..<300)
                .responseDecodable(of: Weather.self){response in
                    self.weather = response.value!
                    city.temp = response.value!.main.temp
                    let date = Date(timeIntervalSinceReferenceDate: response.value!.dt)
                    dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
                    let time = dateFormatter.string(from: date)
                    city.time = time
                    city.lat = response.value!.coord.lat
                    city.lng = response.value!.coord.lon
                }
        })
    }
}

struct Weather: Decodable{
    let coord: Coord
    let weather:[Weath]
    let main:Main
    let wind:Wind
    let dt:Double
    let name:String
}

struct Coord:Codable{
    let lon:Double
    let lat:Double
}

struct Weath:Codable, Hashable{
    let description:String
}

struct Main:Codable{
    let temp:Double
    let feels_like:Double
    let temp_min:Double
    let temp_max:Double
}

struct Wind:Decodable{
    let speed: Int
    let deg:Int
}
