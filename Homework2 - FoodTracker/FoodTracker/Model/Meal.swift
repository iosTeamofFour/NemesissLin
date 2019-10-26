//
//  Meal.swift
//  ElegantLogin
//
//  Created by NemesissLin on 2019/10/15.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import  UIKit
class Meal : NSObject, NSCoding {
    var Image : UIImage
    var Name : String
    var Rating : Int
    
    required init?(coder aDecoder: NSCoder) {
        Rating = aDecoder.decodeInteger(forKey: "Rating")
        guard let name = aDecoder.decodeObject(forKey: "Name") as? String else {
            return nil
        }
        Name = name
        guard let image = aDecoder.decodeObject(forKey: "Image") as? UIImage else {
            return nil
        }
        Image = image
    }
    
    init(Image : UIImage,  Name : String,  Rating : Int) {
        self.Image = Image
        self.Name = Name
        self.Rating = Rating
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Image, forKey: "Image")
        aCoder.encode(Rating, forKey: "Rating")
        aCoder.encode(Name, forKey: "Name")
    }
}
