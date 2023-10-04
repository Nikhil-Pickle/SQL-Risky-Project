# SQL Risky Projects

[Link to Question](https://platform.stratascratch.com/coding/10304-risky-projects?code_type=1)

Identify projects that are at risk for going overbudget. A project is considered to be overbudget if the cost of all employees assigned to the project is greater than the budget of the project.

You'll need to prorate the cost of the employees to the duration of the project. For example, if the budget for a project that takes half a year to complete is $10K, then the total half-year salary of all employees assigned to the project should not exceed $10K. Salary is defined on a yearly basis, so be careful how to calculate salaries for the projects that last less or more than one year.

Output a list of projects that are overbudget with their project name, project budget, and prorated total employee expense (rounded to the next dollar amount).

HINT: to make it simpler, consider that all years have 365 days. You don't need to think about the leap years.

My Solution:

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
