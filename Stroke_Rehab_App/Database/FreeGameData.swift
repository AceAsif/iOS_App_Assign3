//
//  FreeGameData.swift
//  Stroke_Rehab_App
//
//  Created by Md Asif Iqbal on 12/5/2022.
//

import Firebase
import FirebaseFirestoreSwift

public struct FreeGameData : Codable
{
    @DocumentID var dataID:String?
    var startTime:String
    var endTime:String
    var durationOfGame:Int

    var totalButtonClick:Int
    var correctButtonClick:Int
    var wrongButtonClick:Int
    var buttonList: [String]
    var userPicture: String
}
