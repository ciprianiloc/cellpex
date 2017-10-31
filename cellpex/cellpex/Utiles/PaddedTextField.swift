//
//  PaddedTextField.swift
//  cellpex
//
//  Created by Ciprian Iloc on 10/31/17.
//  Copyright © 2017 Ciprian Iloc. All rights reserved.
//

import UIKit

class PaddedTextField: UITextField {
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rightBounds = CGRect(x: bounds.size.width - 22, y: 6, width: 18, height: 18)
        return rightBounds
    }
}
