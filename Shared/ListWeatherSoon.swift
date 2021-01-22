import SwiftUI
import Alamofire

struct ListWeatherSoon: View {
    @Binding var city: City
    @State var weather: WeatherHList? = nil
    @State var weatherIcon: [String] = ["sun.max.fill", "cloud.fill", "cloud.rain.fill", "snow"]
    var body: some View {
        HStack{
            if weather != nil{
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(weather!.list, id:\.self){weather in
                            VStack(spacing: 20){
                                let date = Date(timeIntervalSinceReferenceDate: weather.dt)
                                let hours = dateFormatter.string(from: date)
                                Text(hours)
                                if weather.weather[0].main == "Clouds"{
                                    Image(systemName: weatherIcon[1])
                                }else if weather.weather[0].main == "Sun" || weather.weather[0].main == "Clear"{
                                    Image(systemName: weatherIcon[0])
                                }else if weather.weather[0].main == "Rain"{
                                    Image(systemName: weatherIcon[2])
                                }else if weather.weather[0].main == "Snow"{
                                    Image(systemName: weatherIcon[3])
                                }
                                Text("\(Int(weather.main.temp)-274)")
                            }
                            .frame(width: 50, height: 100)
                            .foregroundColor(.white)
                        }
                    }
                }
            }
        }.onAppear(perform: {
            AF
                .request(
                    "http://api.openweathermap.org/data/2.5/forecast?",
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
                    .responseDecodable(of: WeatherHList.self){response in
                        dateFormatter.setLocalizedDateFormatFromTemplate("HH")
                        self.weather = response.value!
                    }
        })
    }
}

struct WeatherHList:Codable{
    let list: [HList]
}

struct HList: Codable, Hashable{
    let dt: Double
    let main: HMain
    let weather: [HWeather]
}

struct HWeather: Codable, Hashable{
    let main:String
}

struct HMain: Codable, Hashable{
    let temp:Double
}

//struct ListWeatherSoon_Previews: PreviewProvider {
//    static var previews: some View {
//        ListWeatherSoon()
//    }
//}
