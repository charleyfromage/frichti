struct Product {
    let title: String?
    let description: String?
    let images: [String]
    let price: Int?
}

extension Product: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case images = "images"
        case price = "price"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try? container.decode(String?.self, forKey: .title)
        self.description = try? container.decode(String?.self, forKey: .description)
        self.images = try container.decode([String].self, forKey: .images)
        self.price = try? container.decode(Int?.self, forKey: .price)
    }
}
