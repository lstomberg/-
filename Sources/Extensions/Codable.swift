//
//  Created by Lucas Stomberg on 3/3/18.
//  Copyright © 2018 Epic. All rights reserved.
//

import Foundation

//: Decodable Extension
public extension Decodable {

   // example let people = try [Person].decode(JSONData: data)
   static func decode(fromJSON data: Data) throws -> Self {
      let decoder: JSONDecoder = JSONDecoder()

      return try decoder.decode(Self.self, from: data)
   }

}

//: Encodable Extension
public extension Encodable {

   //example let jsonData = try people.encode()
   func encodeJSON() throws -> Data {
      let encoder: JSONEncoder = JSONEncoder()

      encoder.outputFormatting = .prettyPrinted
      return try encoder.encode(self)
   }

}
