import java.util.ArrayList;
import java.util.List;

public class StudentService {
    private List<Student> students = new ArrayList<>();

    public void addStudent(int id, String name, int marks) {
        students.add(new Student(id, name, marks));
        System.out.println("Student added successfully!");
    }

    public void listStudents() {
        if (students.isEmpty()) {
            System.out.println("No students found!");
            return;
        }
        System.out.println("---- Student List ----");
        for (Student s : students) {
            System.out.println(s);
        }
    }
}
