from flask import Flask, jsonify
import mysql.connector
import os

app = Flask(__name__)

db_host = os.getenv("MYSQL_HOST", "db")
db_user = os.getenv("MYSQL_USER", "root")
db_pass = os.getenv("MYSQL_PASSWORD", "rootpass")
db_name = os.getenv("MYSQL_DATABASE", "school")

@app.route('/')
def index():
    return "Welcome to School Management System"

@app.route('/students')
def get_students():
    conn = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_pass,
        database=db_name
    )
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM students")
    students = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(students)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
