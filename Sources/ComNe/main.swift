import Foundation

var isServer = false
let firstArgument = CommandLine.arguments[1]

func initServer(port: UInt16) {
    if #available(macOS 10.14, *) {
        let server = Server(port: port)
        try! server.start()
    } else {
        // Fallback on earlier versions
    }
}

func initClient(server: String, port: UInt16) {
    if #available(macOS 10.14, *) {
        let client = Client(host: server, port: port)
        client.start()
        while(true) {
          var command = readLine(strippingNewline: true)
          switch (command){
          case "CRLF":
              command = "\r\n"
          case "RETURN":
              command = "\n"
          case "exit":
              client.stop()
          default:
              break
          }
          client.connection.send(data: (command?.data(using: .utf8))!)
        }
    } else {
        // Fallback on earlier versions
    }
}

switch (firstArgument) {
case "-l":
    isServer = true
default:
    break
}

if isServer {
    if let port = UInt16(CommandLine.arguments[2]) {
      initServer(port: port)
    } else {
        print("Error invalid port")
    }
} else {
    let server = CommandLine.arguments[1]
    if let port = UInt16(CommandLine.arguments[2]) {
        initClient(server: server, port: port)
    } else {
        print("Error invalid port")
    }
}

RunLoop.current.run()
