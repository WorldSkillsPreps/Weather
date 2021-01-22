import SwiftUI

struct MainWeather: View {
    @Binding var city: City
    @Binding var cityData: [City]
    @Binding var list:Bool
    var body: some View {
        ZStack{
            Color.blue
            VStack{
                ScrollView{
                    WeatherNow(city: $city)
                        .padding([.top, .bottom], 100)
                    Divider()
                        .background(Color.white)
                    ListWeatherSoon(city: $city)
                    Divider()
                        .background(Color.white)
                    ListWeatherV(city: $city)
                }
                HStack{
                    Link("Source API", destination: URL(string: "https://openweathermap.org/")!)
                        .foregroundColor(.white)
                        .frame(width: 90)
                        .padding(.trailing, 10)
                    HStack(spacing: 10){
                        ForEach(cityData){circle in
                            Circle()
                                .fill(Color.white)
                                .frame(width: 10, height: 10)
                        }
                    }
                    .frame(width: 200)
                    .padding(.trailing, 50)
                    Button(action: {
                        self.list.toggle()
                    }, label: {
                        Image(systemName: "list.dash")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    })
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

//struct MainWeather_Previews: PreviewProvider {
//    static var previews: some View {
//        MainWeather()
//    }
//}
