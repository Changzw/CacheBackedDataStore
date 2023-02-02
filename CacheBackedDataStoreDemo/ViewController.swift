//
//  ViewController.swift
//  CacheBackedDataStoreDemo
//
//  Created by Fri on 2023/2/2.
//

import UIKit

final class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let localUserStore = ArrayBackedUserStore()
    let remoteUserStore = RemoteUserStore()
    
    let cache = CacheBackedDataSource(localStore: localUserStore, remoteStore: remoteUserStore)
    cache.find("someObjectId") { (result: Result<User, Error>) in

    }
  }

}

