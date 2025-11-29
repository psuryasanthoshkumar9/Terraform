import streamlit as st
import requests
import os
import pandas as pd

st.set_page_config(page_title="Students DataStore", page_icon="📚", layout="wide")
st.markdown("<style>#MainMenu {visibility: hidden;} footer {visibility: hidden;}</style>", unsafe_allow_html=True)

st.markdown("""
    <style>
    .stApp { background: linear-gradient(135deg, #74ebd5, #ACB6E5); color: #333; }
    .welcome { background-color: rgba(255,255,255,0.2); padding: 20px; border-radius: 10px; text-align:center;}
    .stButton>button { background-color:#ff7f50; color:white; height:3em; width:12em; border-radius:10px; }
    </style>
""", unsafe_allow_html=True)

st.markdown('<div class="welcome"><h1>Student DataStore (Streamlit)</h1><p>Manage students easily</p></div>', unsafe_allow_html=True)

API_URL = os.environ.get("API_URL", "http://localhost:5000")

tab1, tab2, tab3 = st.tabs(["Add Student", "Search Student", "List Students"])

with tab1:
    st.header("Add Student")
    with st.form("add_form"):
        name = st.text_input("Name")
        age = st.number_input("Age", min_value=1, max_value=120, value=18)
        submitted = st.form_submit_button("Add")
        if submitted:
            if not name:
                st.warning("Please enter a name")
            else:
                try:
                    r = requests.post(f"{API_URL}/student/post", json={"name": name, "age": age}, timeout=5)
                    if r.status_code == 200:
                        st.success(f"Added {name}")
                    else:
                        st.error(f"Error: {r.text}")
                except Exception as e:
                    st.error(f"Connection error: {e}")

with tab2:
    st.header("Search Student")
    q = st.text_input("Name to search")
    if st.button("Search") and q:
        try:
            r = requests.get(f"{API_URL}/student/get/{q}", timeout=5)
            if r.status_code == 200:
                s = r.json()
                st.write(s)
            else:
                st.info("Not found")
        except Exception as e:
            st.error(f"Connection error: {e}")

with tab3:
    st.header("All Students")
    if st.button("Refresh"):
        pass
    try:
        r = requests.get(f"{API_URL}/student/all", timeout=5)
        if r.status_code == 200:
            students = r.json()
            if students:
                df = pd.DataFrame(students)
                st.dataframe(df)
            else:
                st.info("No students found")
        else:
            st.error("Backend error")
    except Exception as e:
        st.error(f"Connection error: {e}")
