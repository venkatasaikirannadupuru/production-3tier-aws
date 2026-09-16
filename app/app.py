from flask import Flask
import socket

app = Flask(__name__)


@app.route("/")
def home():
    hostname = socket.gethostname()
    return f"Production 3-Tier Application - Server: {hostname}"


@app.route("/health")
def health():
    return "Healthy", 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
