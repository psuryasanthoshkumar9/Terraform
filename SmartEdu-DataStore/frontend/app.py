import streamlit as st
import requests
import os
import pandas as pd

st.set_page_config(page_title="Students DataStore", page_icon="📚", layout="wide")
st.markdown("<style>#MainMenu {visibility: hidden;} footer {visibility: hidden;}</style>", unsafe_allow_html=True)

API_URL = os.environ.get("API_URL", "http://localhost:8084")

st.markdown("<div style='padding:20px;background:linear-gradient(135deg,#74ebd5,#ACB6E5);border-radius:10px'><h1 style='color:white'>SmartEdu DataStore</h1></div>", unsafe_allow_html=True)

tab1, tab2, tab3 = st.tabs(["Add Student", "Search Student", "List Students"])

with tab1:
    st.header("Add a new student")
    with st.form("add"):
        name = st.text_input("Name")
        age = st.number_input("Age", min_value=1, max_value=100, value=18)
        if st.form_submit_button("Add"):
            if name:
                try:
                    resp = requests.post(f"{API_URL}/student/post", json={"name": name, "age": age})
                    if resp.ok:
                        st.success("Added")
                    else:
                        st.error(resp.text)
                except Exception as e:
                    st.error(e)

with tab2:
    st.header("Search")
    q = st.text_input("Name")
    if st.button("Search") and q:
        try:
            r = requests.get(f"{API_URL}/student/get/{q}")
            if r.ok:
                s = r.json()
                st.write(s)
            else:
                st.warning("Not found")
        except Exception as e:
            st.error(e)

with tab3:
    st.header("All students")
    try:
        r = requests.get(f"{API_URL}/student/all")
        if r.ok:
            df = pd.DataFrame(r.json())
            st.dataframe(df)
        else:
            st.info("No students")
    except Exception as e:
        st.error(e)
