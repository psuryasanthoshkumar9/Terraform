from flask import Flask, jsonify, request
import mysql.connector
import os
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # allow frontend requests

def get_conn():
    return mysql.connector.connect(
        host=os.getenv("MYSQL_HOST", "db"),
        user=os.getenv("MYSQL_USER", "root"),
        password=os.getenv("MYSQL_PASSWORD", "rootpass"),
        database=os.getenv("MYSQL_DATABASE", "school")
    )

@app.route("/")
def index():
    return "Welcome to School Management Dashboard"

@app.route("/students", methods=["GET", "POST"])
def students():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    if request.method == "GET":
        cursor.execute("SELECT id, name, age, `class` FROM students")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(data)
    else:
        body = request.get_json() or {}
        cursor.execute(
            "INSERT INTO students (name, age, `class`) VALUES (%s,%s,%s)",
            (body.get("name"), body.get("age"), body.get("class"))
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"status": "created"}), 201

@app.route("/teachers", methods=["GET", "POST"])
def teachers():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    if request.method == "GET":
        cursor.execute("SELECT id, name, subject FROM teachers")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(data)
    else:
        body = request.get_json() or {}
        cursor.execute(
            "INSERT INTO teachers (name, subject) VALUES (%s,%s)",
            (body.get("name"), body.get("subject"))
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"status": "created"}), 201

@app.route("/dashboard")
def dashboard():
    conn = get_conn()
    cursor = conn.cursor()
    cursor.execute("SELECT COUNT(*) FROM students")
    students_count = cursor.fetchone()[0]
    cursor.execute("SELECT COUNT(*) FROM teachers")
    teachers_count = cursor.fetchone()[0]
    cursor.close()
    conn.close()
    return jsonify({"students": students_count, "teachers": teachers_count})

if __name__ == "__main__":
    # Use 0.0.0.0 so container exposes port
    app.run(host="0.0.0.0", port=5000)
