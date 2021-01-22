import SwiftUI
import Alamofire

struct ListWeatherV: View {
    @Binding var city: City
    @State var weather: WeatherVList? = nil
    @State var weatherIcon: [String] = ["sun.max.fill", "cloud.fill", "cloud.rain.fill", "snow"]
    var body: some View {
        VStack{
            if weather != nil{
                ForEach(weather!.daily, id:\.self){weather in
                    HStack(spacing: 60){
                        let date = Date(timeIntervalSinceReferenceDate: weather.dt)
                        let day = dateFormatter.string(from: date)
                        Text(day)
                            .frame(width: 120)
                        HStack{
                            if weather.weather[0].main == "Clouds"{
                                Image(systemName: weatherIcon[1])
                            }else if weather.weather[0].main == "Sun" || weather.weather[0].main == "Clear"{
                                Image(systemName: weatherIcon[0])
                            }else if weather.weather[0].main == "Rain"{
                                Image(systemName: weatherIcon[2])
                            }else if weather.weather[0].main == "Snow"{
                                Image(systemName: weatherIcon[3])
                            }
                            Text("\(weather.humidity)%")
                        }
                        HStack(spacing: 20){
                            Text("\(Int(weather.temp.max) - 274)")
                                .foregroundColor(.white)
                            Text("\(Int(weather.temp.min) - 274)")
                                .opacity(0.6)
                                .foregroundColor(.white)
                        }
                    }
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                }
            }
        }.onAppear(perform: {
            AF
                .request("https://api.openweathermap.org/data/2.5/onecall?",
                         method: .get,
                         parameters: [
                            "lat": city.lat,
                            "lon": city.lng,
//                            "lat": 82.9344,
//                            "lon": 55.0411,
                            "appid": appId
                         ],
                         encoding: URLEncoding.queryString,
                         headers: [
                             HTTPHeader(name: "Content-Type", value: "application/json"),
                             HTTPHeader(name: "Accept", value: "application/json")
                ])
                .validate(statusCode: 200..<300)
                .responseDecodable(of: WeatherVList.self){response in
                    dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
                    self.weather = response.value!
                }
        })
    }
}

struct WeatherVList: Codable{
    var daily: [Daily]
}

struct Daily:Codable, Hashable{
    let dt: Double
    let temp:VTemp
    let weather:[VWeather]
    let humidity: Int
}

struct VTemp:Codable, Hashable{
    var min: Double
    var max: Double
}

struct VWeather: Codable, Hashable{
   var main: String
}

//struct ListWeatherV_Previews: PreviewProvider {
//    static var previews: some View {
//        ListWeatherV()
//    }
//}
