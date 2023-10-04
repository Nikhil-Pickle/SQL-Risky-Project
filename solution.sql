-- find the duration of each project
with t1 as 
    (select 
        id, 
        title, 
        budget, 
        (end_date - start_date) as duration 
    from linkedin_projects), 

-- SUM every salary of each employee assigned to each project
t2 as 
    (select 
        project_id, 
        sum(salary) 
        salarysum
    from linkedin_emp_projects lep
    join linkedin_employees le
    on lep.emp_id = le.id
    group by project_id
    order by project_id),

-- join the previous 2 CTEs, calculate the prorated salary
t3 as 
    (select 
        title, 
        budget, 
        duration, 
        (1.00 * duration / 365 * salarysum) as prorated_employee_expense
    from t1
    join t2
    on t1.id = t2.project_id)

-- filter the previous CTE to only show overbudget projects. rounded up to the next dollar.

select 
    title, 
    budget, 
    ceiling(prorated_employee_expense) as prorated_employee_expense
from t3
where prorated_employee_expense > budget
