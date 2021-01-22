import SwiftUI
import Alamofire

var appId = "82c7d78e188a67bb78da085b4a35546c"
var dateFormatter = DateFormatter()

struct ContentView: View {
    @State var cityData:[City] = [
        City(name: "Novosibirsk", temp: 0, time: "00:00", lat: 0, lng: 0)
    ]
    @State var selectionWeather:Int = 0
    @State var list:Bool = false
    
    var body: some View {
        if list{
            MenuWeather(cities: $cityData, list: $list, selectionWeather: $selectionWeather)
        }else if !list{
            MainWeather(city: $cityData[selectionWeather], cityData: $cityData, list: $list)
        }
    }
}

struct City:Identifiable{
    var id = UUID()
    var name:String
    var temp:Double
    var time:String
    var lat:Double
    var lng:Double
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
