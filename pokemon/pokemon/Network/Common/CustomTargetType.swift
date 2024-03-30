//
//  CustomTargetType.swift
//  pokemon
//
//  Created by 文 on 2024/3/30.
//

import Foundation
import Moya

protocol CustomTargetType:TargetType {
    var showProgessHUDIfNeeded:Bool {get}
}
