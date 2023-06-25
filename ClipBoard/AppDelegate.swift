//
//  AppDelegate.swift
//  ClipBoard
//
//  Created by Burak Buldu on 22.06.2023.
//

import Cocoa
import AppKit.NSPasteboard

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    var clipboardHistory: [String] = []
    var statusItemStartPoint: Int = 0
    var statusItemFinishPoint: Int = 0

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "c.circle", accessibilityDescription: "c")
        }
        setupMenus()
    }

    func setupMenus() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Save Clipboard", action: #selector(SaveClipboard), keyEquivalent: "s"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Clear Clipboard", action: #selector(ClearClipboard), keyEquivalent: "r"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.addItem(NSMenuItem.separator())
        statusItem.menu = menu
        statusItemStartPoint = 6
        statusItemFinishPoint = 6
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @objc func TapString(_ sender: NSMenuItem) {
        let clickedIndex = sender.tag
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(clipboardHistory[clickedIndex], forType: NSPasteboard.PasteboardType.string)
    }

    @objc func SaveClipboard() {
        let clipboard = NSPasteboard.general.string(forType: .string)
        let menuItem = NSMenuItem(title: String(clipboard!.prefix(50)), action: #selector(TapString), keyEquivalent: "")
        menuItem.tag = clipboardHistory.count
        clipboardHistory.append(clipboard!)
        statusItem.menu?.insertItem(menuItem, at: statusItemStartPoint)
        rearrange()
        statusItemFinishPoint += 1
    }
    
    @objc func rearrange() {
        for i in 0...8 {
            if (statusItemFinishPoint - i < statusItemStartPoint){
                break
            }
            statusItem.menu?.item(at: (statusItemStartPoint+i))?.keyEquivalent = String(i+1)
        }
        if (statusItemFinishPoint - 9 >= statusItemStartPoint){
            statusItem.menu?.item(at: (statusItemStartPoint+9))?.keyEquivalent = "0"
        }
        if (statusItemFinishPoint - 10 >= statusItemStartPoint){
            statusItem.menu?.item(at: (statusItemStartPoint+10))?.keyEquivalent = ""
        }
    }
    
    @objc func ClearClipboard() {
        statusItem.menu?.removeAllItems()
        setupMenus()
        clipboardHistory.removeAll()
    }
}
