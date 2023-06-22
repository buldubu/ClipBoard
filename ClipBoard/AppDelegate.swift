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
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.addItem(NSMenuItem.separator())
        statusItem.menu = menu
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
        print(clipboard!)
        let menuItem = NSMenuItem(title: String(clipboard!.prefix(32)), action: #selector(TapString), keyEquivalent: "")
        menuItem.tag = clipboardHistory.count
        clipboardHistory.append(clipboard!)
        statusItem.menu?.addItem(menuItem)
    }
}
