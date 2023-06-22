//
//  main.swift
//  ClipBoard
//
//  Created by Burak Buldu on 22.06.2023.
//

import Foundation
import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
