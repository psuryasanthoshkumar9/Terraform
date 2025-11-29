from flask import Flask, jsonify, request
from flask_cors import CORS
import sqlite3
import os

DB_FILE = os.path.join(os.path.dirname(__file__), 'students.db')

def init_db():
    conn = sqlite3.connect(DB_FILE)
    cur = conn.cursor()
    cur.execute('''
        CREATE TABLE IF NOT EXISTS students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            age INTEGER
        )
    ''')
    conn.commit()
    conn.close()

def get_all_students():
    conn = sqlite3.connect(DB_FILE)
    cur = conn.cursor()
    cur.execute('SELECT name, age FROM students')
    rows = cur.fetchall()
    conn.close()
    return [{"name": r[0], "age": r[1]} for r in rows]

def add_student(name, age):
    conn = sqlite3.connect(DB_FILE)
    cur = conn.cursor()
    cur.execute('INSERT INTO students (name, age) VALUES (?, ?)', (name, age))
    conn.commit()
    conn.close()

def find_student(name):
    conn = sqlite3.connect(DB_FILE)
    cur = conn.cursor()
    cur.execute('SELECT name, age FROM students WHERE name = ?', (name,))
    row = cur.fetchone()
    conn.close()
    return {"name": row[0], "age": row[1]} if row else None

app = Flask(__name__)
CORS(app)

@app.route('/student/all', methods=['GET'])
def all_students():
    return jsonify(get_all_students())

@app.route('/student/post', methods=['POST'])
def post_student():
    data = request.get_json(force=True)
    name = data.get('name')
    age = data.get('age')
    if not name:
        return jsonify({"error": "name required"}), 400
    add_student(name, age)
    return jsonify({"status": "ok"}), 200

@app.route('/student/get/<name>', methods=['GET'])
def get_student(name):
    s = find_student(name)
    if s:
        return jsonify(s), 200
    return jsonify({"error": "not found"}), 404

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "ok"}), 200

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=int(os.environ.get('BACKEND_PORT', 5000)))
