//
//  FCollectionRefrence.swift
//  messenger
//
//  Created by Andrew Li on 3/31/19.
//  Copyright © 2019 Andrew Li. All rights reserved.
//

import Foundation
import FirebaseFirestore


enum FCollectionReference: String {
    case User
    case Typing
    case Recent
    case Message
    case Group
    case Call
}


func reference(_ collectionReference: FCollectionReference) -> CollectionReference{
    return Firestore.firestore().collection(collectionReference.rawValue)
}

