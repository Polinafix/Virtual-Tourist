//
//  GCDBlackBox.swift
//  Virtual Tourist
//
//  Created by Polina Fiksson on 16/08/2017.
//  Copyright © 2017 PolinaFiksson. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

