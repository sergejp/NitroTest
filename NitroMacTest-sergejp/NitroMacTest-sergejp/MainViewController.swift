//
//  MainViewController.swift
//  NitroMacTest-sergejp
//
//  Created by Sergej Pershaj on 21/10/2022.
//

import Cocoa

final class MainViewController: NSViewController {

    @IBOutlet private weak var logTextArea: NSTextView!
    @IBOutlet private weak var totalRectsLabel: NSTextField!
    @IBOutlet private weak var totalIntersectionsLabel: NSTextField!
    
    // in real project the model would be injected
    private let model = MainViewModel()
    
    @IBAction private func onSelectFileButtonTap(sender: AnyObject) {
        openFileSelectionPanel()
    }
    
    private func openFileSelectionPanel() {
        let panel = RectFileOpenPanelFactory().makePanel()
        panel.delegate = self
        let userActionResult = panel.runModal()
        switch userActionResult {
        case NSApplication.ModalResponse.OK: //if the user clicks the OK button
            if let url = panel.url {
                let result = model.findIntersections(inRectsFrom: url)
                switch result {
                case .success(let result):
                    updateTexts(log: result.log,
                                totalRects: result.totalRects,
                                totalIntersections: result.totalIntersections)
                case .failure(let error):
                    updateTexts(log: error.description)
                }
                
            } else {
                // this should never happen in theory, so relaunching app is the only meaningful way
                // to mitigate this kind of error
                updateTexts(log: "System error: please relaunch the app and try again")
            }
        case NSApplication.ModalResponse.cancel: //if the user clicks the Cancel button
            // do nothing
            return
        default:
            // this shouldn't happen, but in case runModal returns more results in future
            // this would need to be handled differently
            return
        }
    }

    private func updateTexts(log: String,
                          totalRects: String = "0",
                          totalIntersections: String = "0") {
        logTextArea.string = log
        totalRectsLabel.stringValue = totalRects
        totalIntersectionsLabel.stringValue = totalIntersections
    }
    
}

extension MainViewController: NSOpenSavePanelDelegate {
    
    func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
        model.shouldAllow(openPanelFileSelection: url)
    }
    
}
