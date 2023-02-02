//
//  Model.swift
//  CacheBackedDataStoreDemo
//
//  Created by Fri on 2023/2/2.
//

import Foundation

struct User: Decodable {
  var name: String?
  var age: Int?
  var gender: Bool?
}

struct ArrayBackedUserStore: LocalStore {
  func find(_ objectID: String, completion: @escaping (Result<User, Error>) -> Void) {
    print(#function)
  }
  
  func persist(_ object: User) {
    print(#function)
  }
}

struct RemoteUserStore: RemoteStore {
  typealias TargetObject = User
  func find(_ objectID: String, completion: @escaping (Result<User, Error>) -> Void) {
    print(#function)
  }
}
