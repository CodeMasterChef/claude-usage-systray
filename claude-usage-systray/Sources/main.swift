import AppKit

let app = NSApplication.shared
let isTesting = NSClassFromString("XCTestCase") != nil
if !isTesting {
    let delegate = AppDelegate()
    app.delegate = delegate
}
app.run()
