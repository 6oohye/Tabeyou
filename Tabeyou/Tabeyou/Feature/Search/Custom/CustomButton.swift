//
//  CustomButton.swift
//  Tabeyou
//
//  Created by 6혜진 on 5/18/24.
//

import UIKit

@IBDesignable
class CustomButton: UIButton {

    override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        override func prepareForInterfaceBuilder() {
            super.prepareForInterfaceBuilder()
            setup()
        }
        
        private func setup() {
            self.layer.borderWidth = 2.0
            self.layer.borderColor =  UIColor(named: "mainColor")?.cgColor
            self.layer.cornerRadius = 5.0
            self.setTitleColor(.white, for: .normal)
            self.backgroundColor = UIColor(named: "wh")
        }

}
