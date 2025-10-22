#!/usr/bin/env python3

from http.server import BaseHTTPRequestHandler, HTTPServer
import socket, os

PORT = int(os.environ.get("APP_PORT", "8080"))

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        body = f"Python APP at: {socket.gethostname()}\n"
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.end_headers()
        self.wfile.write(body.encode())

if __name__ == "__main__":

    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()