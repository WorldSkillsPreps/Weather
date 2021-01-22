import SwiftUI

struct MenuWeather: View {
    @Binding var cities: [City]
    @Binding var list:Bool
    @Binding var selectionWeather:Int
    @State var newCity:String = ""
    var body: some View {
        ScrollView{
            VStack(spacing: 0){
                HStack{
                    TextField("Add city", text: $newCity)
                    Button(action: {
                        cities.append(City(name:self.newCity, temp: 0, time:"00:00", lat:0, lng: 0))
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
                .padding([.leading, .trailing], 20)
                .frame(height: 50)
                ForEach(cities){city in
                    Button(action: {
                        var id = 0
                        while cities[id].name != city.name{
                            id += 1
                        }
                        self.selectionWeather = id
                        self.list.toggle()
                    }, label: {
                        HStack{
                            VStack(alignment:.leading){
                                Text(city.time)
                                Text(city.name)
                                    .font(.system(size: 24))
                            }.padding(.leading, 20)
                            Spacer()
                            HStack{
                                Text("\(Int(city.temp) - 274)")
                                    .font(.system(size: 45))
                                VStack{
                                    Circle()
                                        .strokeBorder(Color.white, lineWidth: 3)
                                        .frame(width: 15, height: 15)
                                    Spacer()
                                }.frame(height: 45)
                            }.padding(.trailing, 20)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .background(Color.blue)
                    })
                }
            }
        }
    }
}

//struct MenuWeather_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuWeather()
//    }
//}
