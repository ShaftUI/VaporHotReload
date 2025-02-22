import Vapor

func routes(_ app: Application) throws {
    app.get(use: home)

    app.get("hello", use: hello)
}

@Sendable
func home(_ req: Request) async throws -> String {
    return "It works!"
}

@Sendable
func hello(_ req: Request) async throws -> String {
    return "Hello, world!"
}
