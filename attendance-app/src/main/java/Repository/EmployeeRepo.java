package Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import Entity.Employee;

public interface EmployeeRepo extends JpaRepository<Employee, String> {
}
