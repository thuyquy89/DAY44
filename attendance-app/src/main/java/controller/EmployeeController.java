package controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import Entity.Employee;
import Repository.EmployeeRepo;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/employees")
@RequiredArgsConstructor
public class EmployeeController {
	private final EmployeeRepo employeeRepo = null;

	@PostMapping
	public Employee create(@RequestBody Employee e) {
		return employeeRepo.save(e);
	}

	@GetMapping
	public List<Employee> list() {
		return employeeRepo.findAll();
	}
}
