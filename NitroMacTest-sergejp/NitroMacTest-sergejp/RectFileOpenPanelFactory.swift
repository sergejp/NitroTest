//
//  RectFileOpenPanelFactory.swift
//  NitroMacTest-sergejp
//
//  Created by Sergej Pershaj on 24/10/2022.
//

import AppKit

struct RectFileOpenPanelFactory {
    
    func makePanel() -> NSOpenPanel {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.showsHiddenFiles = false
        panel.showsResizeIndicator = true
        return panel
    }
    
}
