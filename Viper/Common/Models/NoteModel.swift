import Foundation

class NoteModel: Codable  {
    let uuid: String
    let title: String
    let content: String

    enum CodingKeys: String, CodingKey {
        case uuid, title, content
    }

    init(uuid: String = UUID().uuidString, title: String, content: String) throws {
        guard !uuid.isEmpty else {
            throw ModelError.invalidUUID
        }
        guard !title.isEmpty else {
            throw ModelError.invalidTitle
        }
        guard !content.isEmpty else {
            throw ModelError.invalidContent
        }
        
        self.uuid = uuid
        self.title = title
        self.content = content
    }

    convenience init(title: String, content: String) throws {
        let uuid = UUID().uuidString
        try self.init(uuid: uuid, title: title, content: content)
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let uuid = try container.decode(String.self, forKey: .uuid)
        let title = try container.decode(String.self, forKey: .title)
        let content = try container.decode(String.self, forKey: .content)
        try self.init(uuid: uuid, title: title, content: content)
    }

    enum ModelError: Error {
        case invalidUUID
        case invalidTitle
        case invalidContent
    }
}
