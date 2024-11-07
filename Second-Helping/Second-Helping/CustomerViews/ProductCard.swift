import SwiftUI

// Custom color
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

//Round individual corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

// Struct -> rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


// Product card
struct ProductCard: View {
    // Def global variables
    var image: Image
    var quantity: Int
    var name: String
    var bagType: String
    var rangePickUpTime: String // Modify later
    var ranking: Double
    var distance: Double
    var price: Double
    var btnHandler: (() -> ())? // Optional, no param, return nothing
    
    init(image: Image,
         quantity: Int,
         name: String,
         bagType: String,
         rangePickUpTime: String, // Modify later
         ranking: Double,
         distance: Double,
         price: Double,
         btnHandler: (() -> ())?) {
        
        self.image = image
        self.quantity = quantity
        self.name = name
        self.bagType = bagType
        self.rangePickUpTime = rangePickUpTime
        self.ranking = ranking
        self.distance = distance
        self.price = price
        self.btnHandler = btnHandler
    }
    
    var body: some View {
        VStack (alignment: .leading){
            let customGreen = Color(hex: "#4f7942")
            HStack {
                self.image
                    .resizable()
                    .frame(maxWidth: 240, maxHeight: 130, alignment: .leading)
                    .overlay(
                        GeometryReader { geometry in
                            let imagePosition = CGSize(width: 2300, height: 120)
                            let quantityPosition = CGSize(width: 200, height: 16)
                            let namePosition = CGSize(width: 1150, height: 100)
                            let heartPosition = CGSize(width: 2000, height: 20)
                            
                            Text("\(self.quantity)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(customGreen)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(9, corners: [.bottomRight])
                                .position(
                                    x: quantityPosition.width / imagePosition.width * geometry.size.width,
                                    y: quantityPosition.height / imagePosition.height * geometry.size.height
                                )
                            // Name of business
                            Text(self.name)
                                .kerning(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                                .foregroundColor(customGreen)
                                .font(.custom("HelveticaNeue", size: 16))
                                .fontWeight(.bold)
                                .padding(5)
                                .background(Color.white.opacity(1.0))
                                .cornerRadius(7)
                                .position(
                                    x: namePosition.width / imagePosition.width * geometry.size.width,
                                    y: namePosition.height / imagePosition.height * geometry.size.height
                                )
                            
                            // Favorite a bag
                            Image(systemName: "heart.square.fill")
                                .foregroundColor(.white.opacity(1.0))
                                .font(.system(size: 35))
                                .position(
                                    x: heartPosition.width / imagePosition.width * geometry.size.width,
                                    y: heartPosition.height / imagePosition.height * geometry.size.height
                                )
                        }
                    )
            }
            
            // Bottom of product card
            VStack (alignment: .leading) {
                Text(self.bagType)
                    .font(.system(size: 18, weight: .heavy))
                    .padding(.bottom, 1)
                    
                Text(self.rangePickUpTime)
                    .font(.custom("Hiragino-Sans", size: 14))
                    .padding(.bottom, 5)
                
                HStack {
                    // All doubles, round 1 decimal point
                    Image(systemName: "star.square.fill")
                        .foregroundStyle(.yellow)
                    Text(String(format: "%.1f", self.ranking))
                    Divider().frame(height: 20)
                    Text(String(format: "%.1f", self.distance))
                        Spacer()
                    Text(String(format: "$%.2f", self.price))
                }
                .font(.system(size: 14))
            }
            .padding([.horizontal, .bottom], 8)
        }
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 7, x: 0, y: 2)
        .padding()
//        .background(Color.blue)
    }
}

struct ProductCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ProductCard(
                    image: Image("theGriffin"),
                    quantity: Int(4),
                    name: "The Griffin",
                    bagType: "Mystery Bag",
                    rangePickUpTime: "1:00 pm - 1:45 pm",
                    ranking: 4.4,
                    distance: 0.8,
                    price: 5.50,
                    btnHandler: nil
                )
                ProductCard(
                    image: Image("blueBird"),
                    quantity: Int(2),
                    name: "BlueBird Barbeque",
                    bagType: "Mystery Bag",
                    rangePickUpTime: "12:15 pm - 1:15 pm",
                    ranking: 3.2,
                    distance: 0.6,
                    price: 6.00,
                    btnHandler: nil
                )
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
