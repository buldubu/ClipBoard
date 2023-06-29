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
    var lineLength: Int = 50
    var timer: Timer!
    var timerInterval: Double = 0.1
    var changeCount: Int = NSPasteboard.general.changeCount

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "c.circle", accessibilityDescription: "c")
        }
        setupMenus()
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(checkChangeCount), userInfo: nil, repeats: true)
    }
    
    @objc func checkChangeCount() {
        if NSPasteboard.general.changeCount == changeCount {
            return
        }
        changeCount = NSPasteboard.general.changeCount
        self.SaveClipboard()
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
        timer.invalidate()
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
        guard let clipboard = NSPasteboard.general.string(forType: .string) else { return }
        let menuItem = NSMenuItem(title: String(clipboard.prefix(lineLength)), action: #selector(TapString), keyEquivalent: "")
        menuItem.tag = clipboardHistory.count
        clipboardHistory.append(clipboard)
        statusItem.menu?.insertItem(menuItem, at: statusItemStartPoint)
        rearrange()
        statusItemFinishPoint += 1
    }
    
    @objc func rearrange() {
        for i: Int in 0...8 {
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
        if (statusItemFinishPoint - 50 >= statusItemStartPoint){
            statusItem.menu?.removeItem(at: statusItemStartPoint+12)
            statusItemFinishPoint -= 1
        }
    }
    
    @objc func ClearClipboard() {
        statusItem.menu?.removeAllItems()
        setupMenus()
        clipboardHistory.removeAll()
    }
}
