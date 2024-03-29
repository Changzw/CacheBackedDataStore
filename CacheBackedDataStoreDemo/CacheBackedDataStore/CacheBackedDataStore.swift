//
//  CacheBackedDataStore.swift
//  CacheBackedDataStoreDemo
//
//  Created by Fri on 2023/2/2.
//

import Foundation

/*
 在不迷失于细节的情况下设计 API：
 
 设计代码的时候
 1. 设计主流程，主框架
 2. 调用接口
 */

/*
 如何设计一个使用泛型的 API
 泛型已经足够复杂了，我不想让你感到困惑，以至于你不确定我们正在设计什么。
 开始构建这样的东西的一个好方法是写下一些伪代码（核心代码框架都有什么/构成主流程）
 以演示您希望如何使用正在构建的 API 或组件。这是我为缓存层写的：
 
 let localDataStore = UserDataStore()
 let remoteDataStore = UserApi()
 // 管理者
 let dataStore = CacheBackedDataStore(localDataStore, remoteDataStore)

 dataStore.fetch(userID) { result in
   // handle result
 }
 */

struct CacheBackedDataSource<Local: LocalStore, Remote: RemoteStore>
  where Local.StoredObject == Remote.TargetObject {
  let localStore: Local
  let remoteStore: Remote
  
  func find(_ objectID: String, completion: @escaping (Result<Local.StoredObject, Error>) -> Void) {
    localStore.find(objectID) { result in
      do {
        let object = try result.get()
        completion(.success(object))
      } catch {
        self.remoteStore.find(objectID) { result in
          do {
            let object = try result.get()
            self.localStore.persist(object)
            completion(.success(object))
          } catch {
            completion(.failure(error))
          }
        }
      }
    }
  }
}

protocol LocalStore {
  associatedtype StoredObject

  func find(_ objectID: String, completion: @escaping (Result<StoredObject, Error>) -> Void)
  func persist(_ object: StoredObject)
}

protocol RemoteStore {
  associatedtype TargetObject: Decodable

  func find(_ objectID: String, completion: @escaping (Result<TargetObject, Error>) -> Void)
}

