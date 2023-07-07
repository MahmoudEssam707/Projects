import streamlit as st


def calculate_gpa(semester_number):
    # GPA calculation logic
    dic = {
        "A": 4,
        "A-": 3.7,
        "B+": 3.3,
        "B": 3,
        "B-": 2.7,
        "C+": 2.3,
        "C": 2,
        "C-": 1.7,
        "D+": 1.3,
        "D": 1,
        "D-": 0.7
    }
    s = st.number_input(f"**Enter the number of subjects for semester {semester_number}:**", min_value=1, step=1,
                        key=f"subjects_{semester_number}")
    marks = []
    hours = []
    for i in range(s):
        mark = st.text_input(f"**Enter your marks for subject {i + 1} in semester {semester_number}:**",
                             key=f"marks_{semester_number}_{i + 1}")
        hour = st.number_input(f"**Enter the credit hours for subject {i + 1} in semester {semester_number}:**",
                               min_value=1, step=1, value=1, key=f"hours_{semester_number}_{i + 1}")
        marks.append(mark)
        hours.append(hour)
    grades = [dic.get(mark) for mark in marks]
    total_points = [hours[i] * grades[i] for i in range(s) if grades[i] is not None and hours[i] is not None]
    gpa = sum(total_points) / sum(hours)
    return gpa


def calculate_cgpa(semester, hours, gpa):
    # CGPA calculation logic
    hxg = [hours[i] * gpa[i] for i in range(semester)]
    cgpa = sum(hxg) / sum(hours)
    return cgpa


def main():
    st.markdown("<h1 style='text-align: center; font-weight: bold;'>CGPA Calculator</h1>", unsafe_allow_html=True)
    semester = st.number_input(label="**Please enter the number of semesters**", min_value=1, step=1,
                               key="num_semesters")
    hours = []
    gpas = []
    for i in range(semester):
        st.write(f"## Semester {i + 1}")
        gpa = calculate_gpa(i + 1)
        gpas.append(gpa)
        hour = st.number_input(f"**How many credit hours did you take in semester {i + 1}:**", min_value=0, step=1,
                               value=1, key=f"semester_hours_{i + 1}")
        hours.append(hour)
    cgpa = calculate_cgpa(semester, hours, gpas)
    st.write(f"## Your CGPA is: {cgpa:.2f}")


if __name__ == "__main__":
    main()
