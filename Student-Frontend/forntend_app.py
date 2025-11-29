import streamlit as st
import requests
import os
import pandas as pd

# Page config
st.set_page_config(page_title="Students DataStore", page_icon="📚", layout="wide")

# Hide default menu and footer
st.markdown("<style>#MainMenu {visibility: hidden;} footer {visibility: hidden;}</style>", unsafe_allow_html=True)

# Custom CSS for background, buttons, and headers
st.markdown("""
    <style>
    .stApp {
        background: linear-gradient(135deg, #74ebd5, #ACB6E5);
        color: #333333;
    }
    .welcome {
        background-color: rgba(255,255,255,0.2);
        padding: 25px;
        border-radius: 15px;
        text-align: center;
        font-family: 'Arial';
    }
    .welcome h1 {
        color: #fff;
        font-size: 40px;
    }
    .welcome p {
        color: #f0f0f0;
        font-size: 20px;
    }
    .stButton>button {
        background-color: #ff7f50;
        color:white;
        height:3em;
        width:12em;
        border-radius:10px;
        border:none;
        font-size:16px;
    }
    .dataframe tbody tr:hover {
        background-color: #ffe4b5;
    }
    </style>
""", unsafe_allow_html=True)

# Welcome Banner
st.markdown("""
<div class="welcome">
    <h1>Student DataStore App (Streamlit)</h1>
    <p>Manage your students easily!</p>
</div>
""", unsafe_allow_html=True)

# API URL for Backend Spring Boot
API_URL = os.environ.get("API_URL", "http://3.84.186.229:8084")

# Tabs
tab1, tab2, tab3 = st.tabs(["Add Student", "Search Student", "List Students"])

# ---------------- TAB 1: ADD STUDENT ----------------
with tab1:
    st.subheader("Add Student")

    with st.form("add_form"):
        name = st.text_input("Name")
        age = st.number_input("Age", min_value=1, max_value=120)
        submit = st.form_submit_button("Add Student")

        if submit:
            if not name:
                st.warning("Name required!")
            else:
                try:
                    response = requests.post(f"{API_URL}/student/post",
                                             json={"name": name, "age": age})
                    if response.status_code == 200:
                        st.success("Student Added Successfully")
                    else:
                        st.error("Backend Error: " + response.text)
                except Exception as e:
                    st.error(f"Connection Error: {e}")

# ---------------- TAB 2: SEARCH STUDENT ----------------
with tab2:
    st.subheader("Search Student")

    search_name = st.text_input("Enter name to search")
    if st.button("Search"):
        try:
            response = requests.get(f"{API_URL}/student/get/{search_name}")
            if response.status_code == 200:
                data = response.json()
                st.write(f"**Name:** {data['name']}")
                st.write(f"**Age:** {data['age']}")
            else:
                st.warning("Student Not Found")
        except Exception as e:
            st.error(f"Connection Error: {e}")

# ---------------- TAB 3: LIST STUDENTS ----------------
with tab3:
    st.subheader("All Students")

    try:
        response = requests.get(f"{API_URL}/student/all")
        if response.status_code == 200:
            students = response.json()
            if students:
                df = pd.DataFrame(students)
                st.dataframe(df)
            else:
                st.info("No students found.")
        else:
            st.error("Backend Error")
    except:
        st.error("Backend Not Reachable!")
