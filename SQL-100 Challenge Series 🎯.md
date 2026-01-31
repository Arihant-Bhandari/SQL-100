# SQL-100 Challenge Series 🎯

## Welcome, Data Detective!

These 100 challenges will transform how you think about data. Each puzzle builds on the last, training your brain to spot patterns, anomalies, and hidden stories in databases.

**How to Play:**
- Start at Level 1 and work your way up
- Each challenge has a difficulty rating (⭐ to ⭐⭐⭐⭐⭐)
- Hints are provided, but try solving without them first
- "Trap Alerts" warn you about intentional data issues to find

---

# 🟢 LEVEL 1: THE BASICS (Challenges 1-15)
*Building your foundation*

---

### Challenge 1: Roll Call ⭐
**Database:** COMPANY_DB

Count the total number of employees in the company.

> 💡 *Hint: A simple COUNT will do. But wait... should you count everyone?*

---

### Challenge 2: Department Directory ⭐
**Database:** COMPANY_DB

List all department names along with their annual budgets, sorted from highest to lowest budget.

> 💡 *Hint: Watch out for departments that might not have a budget set.*

---

### Challenge 3: Student Census ⭐
**Database:** SCHOOL_DB

How many students are enrolled in each grade level? Display the grade and count.

> 💡 *Hint: GROUP BY is your friend here.*

---

### Challenge 4: The Email List ⭐
**Database:** COMPANY_DB

Generate a list of all employee full names and their email addresses, sorted alphabetically by last name.

> 💡 *Hint: Combine first and last names for readability.*

---

### Challenge 5: Active vs Inactive ⭐
**Database:** COMPANY_DB

How many clients are currently active versus inactive?

> 💡 *Hint: The is_active column holds the key.*

---

### Challenge 6: Project Status Report ⭐
**Database:** COMPANY_DB

Count how many projects exist in each status (Completed, In Progress, Planning, Cancelled).

> 💡 *Hint: A simple grouping exercise.*

---

### Challenge 7: Teacher Roster ⭐
**Database:** SCHOOL_DB

List all teachers with their full names, subjects, and the school they teach at.

> 💡 *Hint: You'll need to JOIN tables to get school names.*

---

### Challenge 8: Budget Check ⭐⭐
**Database:** COMPANY_DB

Find all departments where the budget exceeds $1,000,000.

> 💡 *Hint: Simple WHERE clause. But one department might surprise you...*

---

### Challenge 9: New Hires ⭐⭐
**Database:** COMPANY_DB

List all employees hired in 2021 or later. Show their names, hire dates, and job titles.

> 💡 *Hint: Use date filtering. Keep an eye out for anything unusual about hire dates.*

---

### Challenge 10: Course Catalog ⭐⭐
**Database:** SCHOOL_DB

Display all courses with their names, credit values, and which department offers them.

> 💡 *Hint: A JOIN will connect courses to departments.*

---

### Challenge 11: The Salary Spectrum ⭐⭐
**Database:** COMPANY_DB

What are the minimum, maximum, and average salaries across all employees?

> 💡 *Hint: Aggregate functions are key. But can you trust all the salary values?*

---

### Challenge 12: Overdue Books ⭐⭐
**Database:** SCHOOL_DB

Find all library books that are currently checked out and overdue (past their due date).

> 💡 *Hint: Compare due_date to the current date. Check if return_date is NULL.*

---

### Challenge 13: Client Geography ⭐⭐
**Database:** COMPANY_DB

How many clients are in each state? Show the top 5 states by client count.

> 💡 *Hint: GROUP BY state, then ORDER and LIMIT.*

---

### Challenge 14: Class Size Check ⭐⭐
**Database:** SCHOOL_DB

Find the average number of students enrolled per class section.

> 💡 *Hint: You'll need to count enrollments and then average.*

---

### Challenge 15: Employment Types ⭐⭐
**Database:** COMPANY_DB

Break down the employee count by employment type (Full-time, Part-time, Contractor, Intern).

> 💡 *Hint: GROUP BY employment_type. Notice anything about the distribution?*

---

# 🟡 LEVEL 2: MAKING CONNECTIONS (Challenges 16-35)
*Joining tables and seeing relationships*

---

### Challenge 16: Who's the Boss? ⭐⭐
**Database:** COMPANY_DB

List each employee with their manager's name. Include employees who don't have a manager.

> 💡 *Hint: Self-JOIN on the employees table. LEFT JOIN preserves everyone.*

---

### Challenge 17: Project Teams ⭐⭐
**Database:** COMPANY_DB

For each project, list the project name and the count of team members assigned to it.

> 💡 *Hint: JOIN projects with employee_projects, then GROUP BY.*

---

### Challenge 18: Homeless Employees ⭐⭐⭐
**Database:** COMPANY_DB

Find any employees who are assigned to a department that doesn't exist in the departments table.

> 🚨 *Trap Alert: This is checking for orphaned foreign key references.*

> 💡 *Hint: LEFT JOIN employees to departments and look for NULLs.*

---

### Challenge 19: The Loners ⭐⭐⭐
**Database:** COMPANY_DB

Find projects that have NO employees assigned to them.

> 💡 *Hint: LEFT JOIN and filter for NULL matches.*

---

### Challenge 20: Student Activities ⭐⭐
**Database:** SCHOOL_DB

List students who are members of more than 2 extracurricular activities.

> 💡 *Hint: GROUP BY student and HAVING COUNT > 2.*

---

### Challenge 21: Invoice Tracker ⭐⭐⭐
**Database:** COMPANY_DB

For each client, show the total value of all invoices and how much has been paid.

> 💡 *Hint: Multiple JOINs from clients → contracts → invoices, then aggregate.*

---

### Challenge 22: The Teacher Load ⭐⭐⭐
**Database:** SCHOOL_DB

Which teachers are teaching more than 3 class sections this term?

> 💡 *Hint: JOIN teachers to class_sections and count.*

---

### Challenge 23: Skills Inventory ⭐⭐
**Database:** COMPANY_DB

List all employees in the Engineering department (dept_id = 1) and their skills with proficiency levels.

> 💡 *Hint: JOIN employees → employee_skills → skills, filter by department.*

---

### Challenge 24: Guardian Search ⭐⭐⭐
**Database:** SCHOOL_DB

Find all students who have more than 2 guardians listed.

> 💡 *Hint: student_guardians is a junction table. Group and count.*

---

### Challenge 25: Contract Value by Client ⭐⭐⭐
**Database:** COMPANY_DB

Show each client's total contract value, ordered from highest to lowest. Include clients with no contracts (showing $0).

> 💡 *Hint: LEFT JOIN and COALESCE for the zero values.*

---

### Challenge 26: GPA by School ⭐⭐
**Database:** SCHOOL_DB

Calculate the average GPA of students at each school.

> 💡 *Hint: JOIN students to schools, then GROUP BY school.*

---

### Challenge 27: The Reporting Chain ⭐⭐⭐
**Database:** COMPANY_DB

Show the full management chain for employee ID 16. Who do they report to, and who does that person report to, all the way up?

> 💡 *Hint: Recursive thinking! Follow manager_id links upward.*

---

### Challenge 28: Multi-Project Workers ⭐⭐⭐
**Database:** COMPANY_DB

Find employees who are currently working on more than 2 active projects (projects with status 'In Progress').

> 💡 *Hint: JOIN employees to employee_projects to projects, filter and count.*

---

### Challenge 29: Course Prerequisites ⭐⭐⭐
**Database:** SCHOOL_DB

List all courses along with their prerequisite course names (if any).

> 💡 *Hint: Self-JOIN on the courses table using prerequisite_id.*

---

### Challenge 30: Expense Reports by Department ⭐⭐⭐
**Database:** COMPANY_DB

Show total approved expenses per department for 2023.

> 💡 *Hint: JOIN expenses → employees → departments, filter by status and year.*

---

### Challenge 31: Students Without Guardians ⭐⭐⭐
**Database:** SCHOOL_DB

Find any students who have no guardians listed in the system.

> 🚨 *Trap Alert: Orphaned records that shouldn't exist.*

> 💡 *Hint: LEFT JOIN to student_guardians and look for NULLs.*

---

### Challenge 32: Training Completion ⭐⭐⭐
**Database:** COMPANY_DB

Which employees have NOT completed the mandatory "Cybersecurity Awareness" training?

> 💡 *Hint: Find employees NOT IN the set who completed training_id = 2.*

---

### Challenge 33: Fee Collection ⭐⭐⭐
**Database:** SCHOOL_DB

Calculate the total fees owed vs. total fees paid, broken down by school.

> 💡 *Hint: Aggregate amount and amount_paid from fees, grouped by school.*

---

### Challenge 34: Office Capacity ⭐⭐⭐
**Database:** COMPANY_DB

For each office location, show how many employees work there versus the capacity.

> 💡 *Hint: You'll need to count employees by their department's location.*

---

### Challenge 35: Assignment Grades ⭐⭐⭐
**Database:** SCHOOL_DB

Show the average grade for each assignment, along with how many students submitted it.

> 💡 *Hint: GROUP BY assignment_id with AVG and COUNT.*

---

# 🟠 LEVEL 3: DETECTIVE WORK (Challenges 36-55)
*Finding anomalies and data quality issues*

---

### Challenge 36: The Ghost Employee 👻 ⭐⭐⭐
**Database:** COMPANY_DB

Find the employee who is marked as terminated (has a termination_date) but is still flagged as is_active = 1.

> 🚨 *Trap Alert: This is an intentional data integrity violation.*

> 💡 *Hint: WHERE termination_date IS NOT NULL AND is_active = 1*

---

### Challenge 37: The Time Traveler ⏰ ⭐⭐⭐
**Database:** COMPANY_DB

Find any employees with a hire_date in the future.

> 🚨 *Trap Alert: Someone was added before they should start.*

> 💡 *Hint: Compare hire_date to CURDATE() or '2024-06-01'.*

---

### Challenge 38: The Impossible Project ⭐⭐⭐
**Database:** COMPANY_DB

Find projects where the end_date is BEFORE the start_date.

> 🚨 *Trap Alert: A clear data entry error to catch.*

> 💡 *Hint: WHERE end_date < start_date*

---

### Challenge 39: Duplicate Emails 📧 ⭐⭐⭐
**Database:** COMPANY_DB

Find any email addresses that appear more than once in the employees table.

> 🚨 *Trap Alert: Emails should be unique!*

> 💡 *Hint: GROUP BY email HAVING COUNT(*) > 1*

---

### Challenge 40: The NULL Salary ⭐⭐⭐
**Database:** COMPANY_DB

Find employees who have no salary set.

> 🚨 *Trap Alert: Someone is working for free?*

> 💡 *Hint: WHERE salary IS NULL*

---

### Challenge 41: The Self-Approver 🔄 ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find any expenses where the employee approved their own expense report.

> 🚨 *Trap Alert: This is a control violation!*

> 💡 *Hint: WHERE emp_id = approved_by*

---

### Challenge 42: The Self-Reviewer ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find performance reviews where someone reviewed themselves.

> 🚨 *Trap Alert: Another control violation.*

> 💡 *Hint: WHERE emp_id = reviewer_id*

---

### Challenge 43: Self-Approved Leave ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find leave requests that were approved by the person who requested them.

> 🚨 *Trap Alert: HR policy violation.*

> 💡 *Hint: WHERE emp_id = approved_by AND status = 'Approved'*

---

### Challenge 44: The Rating Anomaly ⭐⭐⭐⭐
**Database:** COMPANY_DB

Performance ratings should be 1-5. Find any reviews with ratings outside this range.

> 🚨 *Trap Alert: Data validation failure.*

> 💡 *Hint: WHERE rating < 1 OR rating > 5*

---

### Challenge 45: The Overachiever ⭐⭐⭐
**Database:** COMPANY_DB

Find any performance reviews where goals_met_percentage exceeds 100%.

> 💡 *Hint: WHERE goals_met_percentage > 100. Is this valid or an error?*

---

### Challenge 46: Skill Level Anomaly ⭐⭐⭐⭐
**Database:** COMPANY_DB

Proficiency levels should be 1-5. Find employee skills with invalid proficiency levels.

> 🚨 *Trap Alert: Out of range values.*

> 💡 *Hint: WHERE proficiency_level < 1 OR proficiency_level > 5*

---

### Challenge 47: The Partial Payment 💰 ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find invoices where the amount_paid is less than total_amount but the status is 'Paid'.

> 🚨 *Trap Alert: Payment reconciliation issue.*

> 💡 *Hint: WHERE status = 'Paid' AND amount_paid < total_amount*

---

### Challenge 48: The Tax Mismatch ⭐⭐⭐⭐
**Database:** COMPANY_DB

Assuming tax should be 9% of the subtotal, find invoices where the tax amount doesn't match.

> 🚨 *Trap Alert: Calculation error or fraud indicator.*

> 💡 *Hint: WHERE ABS(tax_amount - (subtotal * 0.09)) > 0.01*

---

### Challenge 49: Expired Lease ⭐⭐⭐
**Database:** COMPANY_DB

Find office locations where the lease has expired (lease_end is in the past).

> 🚨 *Trap Alert: We might be operating illegally!*

> 💡 *Hint: WHERE lease_end < CURDATE()*

---

### Challenge 50: Inactive Client, Active Contract ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find clients marked as inactive who still have active contracts.

> 🚨 *Trap Alert: Business logic inconsistency.*

> 💡 *Hint: JOIN clients to contracts, filter accordingly.*

---

### Challenge 51: Overlapping Leave ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find employees who have overlapping approved leave requests (same days covered by multiple requests).

> 🚨 *Trap Alert: Double-booking time off.*

> 💡 *Hint: Self-JOIN leave_requests comparing date ranges.*

---

### Challenge 52: Attendance Math ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find attendance records where the hours_worked doesn't match the difference between clock_in and clock_out.

> 🚨 *Trap Alert: Time calculation error or manipulation.*

> 💡 *Hint: Calculate expected hours from times and compare.*

---

### Challenge 53: Missing Clock-Out ⭐⭐⭐
**Database:** COMPANY_DB

Find attendance records where status is 'Present' but clock_out is NULL.

> 🚨 *Trap Alert: Incomplete records.*

> 💡 *Hint: WHERE status = 'Present' AND clock_out IS NULL*

---

### Challenge 54: Weekend Warriors ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find employees who have attendance records on weekends (Saturday or Sunday).

> 💡 *Hint: Use DAYOFWEEK() or WEEKDAY() function on work_date.*

---

### Challenge 55: The Duplicate Client ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find clients with the same company name but different contact information.

> 🚨 *Trap Alert: Potential duplicate data entry.*

> 💡 *Hint: GROUP BY company_name HAVING COUNT(*) > 1*

---

# 🔴 LEVEL 4: ANALYSIS & INSIGHTS (Challenges 56-80)
*Deriving business intelligence*

---

### Challenge 56: Budget vs Actual ⭐⭐⭐⭐
**Database:** COMPANY_DB

For each completed project, calculate the difference between budget and actual spending. Flag projects that went over budget.

> 💡 *Hint: CASE statement to create an over/under flag.*

---

### Challenge 57: Top Performers ⭐⭐⭐⭐
**Database:** COMPANY_DB

Rank employees by their most recent performance review rating. Show top 10.

> 💡 *Hint: You need the most recent review per employee, then rank.*

---

### Challenge 58: Revenue by Industry ⭐⭐⭐
**Database:** COMPANY_DB

Calculate total contract value by client industry. Which industry brings the most business?

> 💡 *Hint: JOIN contracts to clients, GROUP BY industry.*

---

### Challenge 59: Student Success Predictor ⭐⭐⭐⭐
**Database:** SCHOOL_DB

Is there a correlation between attendance rate and GPA? Show average GPA for students with >95%, 90-95%, 85-90%, and <85% attendance rates.

> 💡 *Hint: Calculate attendance percentage first, then bucket students.*

---

### Challenge 60: The Experience Premium ⭐⭐⭐⭐
**Database:** COMPANY_DB

What's the average salary for employees by years of tenure? (0-2 years, 3-5 years, 6-10 years, 10+ years)

> 💡 *Hint: Calculate tenure from hire_date, create buckets with CASE.*

---

### Challenge 61: Training ROI ⭐⭐⭐⭐
**Database:** COMPANY_DB

Compare average performance ratings for employees who completed the "Leadership Fundamentals" training vs those who didn't.

> 💡 *Hint: LEFT JOIN to filter training completion, then compare averages.*

---

### Challenge 62: Invoice Aging Report ⭐⭐⭐⭐
**Database:** COMPANY_DB

Categorize outstanding invoices by age: Current (0-30 days), Aging (31-60 days), Overdue (61-90 days), Severely Overdue (90+ days).

> 💡 *Hint: DATEDIFF from due_date, filter for unpaid, use CASE.*

---

### Challenge 63: Department Skill Gaps ⭐⭐⭐⭐
**Database:** COMPANY_DB

Which departments have no employees with cloud skills (AWS or Azure)?

> 💡 *Hint: Find departments NOT IN those with cloud-skilled employees.*

---

### Challenge 64: Activity Popularity ⭐⭐⭐
**Database:** SCHOOL_DB

Rank extracurricular activities by participation rate (members vs school enrollment).

> 💡 *Hint: Complex join and calculation, then rank.*

---

### Challenge 65: Salary Band Analysis ⭐⭐⭐⭐
**Database:** COMPANY_DB

Create salary bands (50k-75k, 75k-100k, 100k-125k, etc.) and count employees in each. Include average tenure per band.

> 💡 *Hint: CASE statement for bands, aggregate functions.*

---

### Challenge 66: The Workaholic Report ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find employees who regularly work more than 9 hours per day (average over all their attendance records).

> 💡 *Hint: GROUP BY employee, HAVING AVG(hours_worked) > 9.*

---

### Challenge 67: Payment Terms Analysis ⭐⭐⭐⭐
**Database:** COMPANY_DB

Which payment terms (Net 30, Net 45, Net 60) have the best on-time payment rate?

> 💡 *Hint: Calculate if payment_date <= due_date for each term type.*

---

### Challenge 68: Grade Distribution ⭐⭐⭐
**Database:** SCHOOL_DB

For each course, show the distribution of grades (A: 90-100, B: 80-89, C: 70-79, D: 60-69, F: <60).

> 💡 *Hint: CASE to bucket grades, COUNT per bucket per course.*

---

### Challenge 69: Salary Growth Tracker ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

For employees with salary history, calculate their total percentage increase from first salary to current salary.

> 💡 *Hint: Get first and last (current) salary per employee, calculate % change.*

---

### Challenge 70: The Training Gap ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find employees who joined more than 2 years ago but haven't completed the "New Employee Orientation" (training_id = 1).

> 🚨 *Trap Alert: Compliance issue - everyone should complete orientation.*

> 💡 *Hint: NOT IN or NOT EXISTS pattern.*

---

### Challenge 71: Client Health Score ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Create a client health score based on: contract value (40%), payment timeliness (30%), and years as client (30%). Rank clients.

> 💡 *Hint: Complex weighted scoring with multiple joins and calculations.*

---

### Challenge 72: Teacher Workload Balance ⭐⭐⭐⭐
**Database:** SCHOOL_DB

Find the standard deviation of class section counts per teacher at each school. Which schools have the most uneven distribution?

> 💡 *Hint: Use statistical functions, group appropriately.*

---

### Challenge 73: Project Profitability ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Calculate project profitability: (Contract Value - Actual Spending) / Contract Value. Rank projects.

> 💡 *Hint: JOIN contracts to projects, calculate margin percentage.*

---

### Challenge 74: Skill Coverage Matrix ⭐⭐⭐⭐
**Database:** COMPANY_DB

For each department, show how many employees have each skill category (Programming, Cloud, Management, etc.).

> 💡 *Hint: Cross-tabulation query with department and skill category.*

---

### Challenge 75: Book Popularity ⭐⭐⭐
**Database:** SCHOOL_DB

Rank library books by number of times they've been borrowed. Show top 20.

> 💡 *Hint: COUNT book_loans per book, ORDER DESC.*

---

### Challenge 76: Monthly Revenue Trend ⭐⭐⭐⭐
**Database:** COMPANY_DB

Show monthly invoice revenue for 2023. Include month-over-month growth percentage.

> 💡 *Hint: GROUP BY month, use LAG() for previous month comparison.*

---

### Challenge 77: Discipline Patterns ⭐⭐⭐⭐
**Database:** SCHOOL_DB

Are there patterns in discipline records? Show counts by day of week and identify any hotspots.

> 💡 *Hint: DAYOFWEEK() or DAYNAME() on incident dates.*

---

### Challenge 78: The Skills Multiplier ⭐⭐⭐⭐
**Database:** COMPANY_DB

Is there a correlation between number of skills and salary? Show average salary by skill count brackets (1-3, 4-6, 7+).

> 💡 *Hint: Count skills per employee, bucket them, average salaries.*

---

### Challenge 79: Enrollment Trends ⭐⭐⭐⭐
**Database:** SCHOOL_DB

Compare enrollment counts between current year and previous year for each school. Which schools are growing vs shrinking?

> 💡 *Hint: Aggregate by enrollment year and school, calculate change.*

---

### Challenge 80: Expense Category Analysis ⭐⭐⭐⭐
**Database:** COMPANY_DB

Which expense categories are growing fastest? Compare 2023 vs 2022 spending per category.

> 💡 *Hint: GROUP BY category and year, calculate percentage change.*

---

# 🟣 LEVEL 5: SALARY HISTORY DEEP DIVE (Challenges 81-90)
*Mastering temporal data*

---

### Challenge 81: Salary History Gaps ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Find employees who have gaps in their salary history (periods with no salary record).

> 🚨 *Trap Alert: There's at least one employee with a gap.*

> 💡 *Hint: Compare end_date of one record to effective_date of the next.*

---

### Challenge 82: Overlapping Salary Periods ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Find salary history records that overlap (same employee, overlapping date ranges).

> 🚨 *Trap Alert: This violates data integrity - you can't have two salaries at once.*

> 💡 *Hint: Self-JOIN salary_history, check for date range overlaps.*

---

### Challenge 83: Biggest Raise ⭐⭐⭐⭐
**Database:** COMPANY_DB

Who received the biggest single salary increase (in absolute dollars)?

> 💡 *Hint: Compare consecutive salary records for each employee.*

---

### Challenge 84: Salary at a Point in Time ⭐⭐⭐⭐
**Database:** COMPANY_DB

What was each employee's salary on January 1, 2018?

> 💡 *Hint: WHERE effective_date <= '2018-01-01' AND (end_date >= '2018-01-01' OR end_date IS NULL)*

---

### Challenge 85: Average Tenure Between Raises ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

On average, how long does an employee wait between salary increases?

> 💡 *Hint: Calculate gaps between consecutive salary records, average them.*

---

### Challenge 86: Department Pay Progression ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Compare salary progression rates (average % increase per year) between departments.

> 💡 *Hint: Complex calculation involving salary history and tenure.*

---

### Challenge 87: The Pay Cut ⭐⭐⭐⭐
**Database:** COMPANY_DB

Find any instances where an employee's salary decreased.

> 💡 *Hint: Compare consecutive salary records, look for decreases.*

---

### Challenge 88: Current vs Historical ⭐⭐⭐⭐
**Database:** COMPANY_DB

Verify that the current salary in the employees table matches the most recent salary in salary_history.

> 🚨 *Trap Alert: Check for mismatches between tables.*

> 💡 *Hint: JOIN on emp_id where end_date IS NULL, compare salaries.*

---

### Challenge 89: Promotion Velocity ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Which employees have received the most salary adjustments? Does this correlate with tenure or performance?

> 💡 *Hint: Count salary_history records per employee, join to reviews.*

---

### Challenge 90: Inflation Adjustment ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Assuming 3% annual inflation, which employees' real salaries have actually decreased since hiring?

> 💡 *Hint: Calculate expected salary with compounding, compare to actual.*

---

# ⚫ LEVEL 6: THE GRAND CHALLENGES (Challenges 91-100)
*The ultimate tests of your analytical prowess*

---

### Challenge 91: The Data Quality Report ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Create a comprehensive data quality report that identifies ALL the intentional issues in COMPANY_DB:
- Duplicate emails
- Terminated but active employees
- Future hire dates
- NULL salaries
- Self-approvals
- Invalid ratings
- Payment mismatches
- Expired leases
- etc.

> 💡 *Hint: UNION ALL multiple diagnostic queries into one report.*

---

### Challenge 92: The Complete Picture ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

For each employee, create a single comprehensive view showing:
- Personal info
- Manager name
- Department name
- Current projects (count and names)
- Skills (count and list)
- Training completed (count)
- Latest performance rating
- Total expenses submitted
- Leave days used this year

> 💡 *Hint: Multiple LEFT JOINs and aggregations. Consider subqueries.*

---

### Challenge 93: Financial Reconciliation ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Reconcile all financial data:
- Contract values should match sum of invoices
- Paid invoices should have matching payment amounts
- Project spending should align with expense totals

Identify all discrepancies.

> 💡 *Hint: Multiple aggregation queries compared against expected values.*

---

### Challenge 94: Organizational Network ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Map the complete organizational hierarchy. For each employee, show their level in the org (1 = no manager, 2 = reports to level 1, etc.) and their full reporting chain.

> 💡 *Hint: Recursive CTE to traverse the hierarchy.*

---

### Challenge 95: Student 360 ⭐⭐⭐⭐⭐
**Database:** SCHOOL_DB

Create a comprehensive student view:
- Personal info & guardians
- Current courses and grades (calculated GPA)
- Attendance rate
- Activities participated in
- Library books currently checked out
- Outstanding fees
- Discipline records (if any)

> 💡 *Hint: Massive multi-table join with aggregations.*

---

### Challenge 96: Predict Project Risk ⭐⭐⭐⭐⭐
**Database:** COMPANY_DB

Based on historical data, identify risk factors for projects:
- Projects with fewer than 3 team members
- Budget already 75%+ consumed before halfway point
- Team members with low average performance ratings
- Department history of over-budget projects

Flag current "In Progress" projects that have these risk factors.

> 💡 *Hint: Create a scoring system based on multiple factors.*

---

### Challenge 97: School Performance Dashboard ⭐⭐⭐⭐⭐
**Database:** SCHOOL_DB

Create a school comparison dashboard:
- Average GPA
- Attendance rate
- Activity participation rate
- Fee collection rate
- Student-teacher ratio
- Discipline incident rate

Rank schools overall based on weighted metrics.

> 💡 *Hint: Calculate each metric separately, then combine and weight.*

---

### Challenge 98: The Anomaly Hunter ⭐⭐⭐⭐⭐
**Database:** BOTH

Using statistical analysis, find:
- Salaries more than 2 standard deviations from department average
- Project budgets more than 2 std dev from category average
- Students with GPAs significantly below their school average
- Any other statistical outliers

> 💡 *Hint: Calculate mean and standard deviation, filter for extremes.*

---

### Challenge 99: Cross-Database Analysis ⭐⭐⭐⭐⭐
**Database:** BOTH

If COMPANY_DB's "EduLearn Systems" client (client_id = 6) represents SCHOOL_DB:
- Compare their contract value to the total fees collected in SCHOOL_DB
- Does it make business sense?
- What insights can you draw?

> 💡 *Hint: This requires conceptual thinking about data relationships.*

---

### Challenge 100: The Final Boss 👑 ⭐⭐⭐⭐⭐
**Database:** BOTH

Write a complete data audit script that:

1. **Validates referential integrity** across all tables
2. **Identifies all data quality issues** (you should find at least 15 distinct issues)
3. **Generates business insights** including:
    - Top performing employees by composite score
    - At-risk projects
    - Client churn indicators
    - Underperforming students
4. **Recommends data corrections** for each issue found
5. **Produces an executive summary** with key metrics

This should be a comprehensive, production-ready audit that would impress any data team.

> 💡 *Hint: This is your masterpiece. Combine everything you've learned.*

---

# 🏆 BONUS CHALLENGES

### Bonus A: Create a View
Create a database view for the "Employee 360" (Challenge 92) that can be queried easily.

### Bonus B: Write a Stored Procedure
Write a stored procedure that accepts an employee_id and returns their complete profile.

### Bonus C: Indexing Strategy
Based on the queries you've written, propose an indexing strategy that would optimize the most common query patterns.

### Bonus D: Fix the Data
Write UPDATE and INSERT statements to fix all the data quality issues you've found.

### Bonus E: Document the Schema
Create comprehensive documentation for both databases, including entity-relationship diagrams (described in text).

---

## 📊 Progress Tracker

| Level | Challenges | Status |
|-------|------------|--------|
| Level 1: The Basics | 1-15 | ⬜ |
| Level 2: Making Connections | 16-35 | ⬜ |
| Level 3: Detective Work | 36-55 | ⬜ |
| Level 4: Analysis & Insights | 56-80 | ⬜ |
| Level 5: Salary History Deep Dive | 81-90 | ⬜ |
| Level 6: Grand Challenges | 91-100 | ⬜ |
| Bonus Challenges | A-E | ⬜ |

---

## 🎯 Skills Developed

By completing all 100 challenges, you will have practiced:

- ✅ Basic SELECT, WHERE, ORDER BY
- ✅ Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- ✅ GROUP BY and HAVING
- ✅ All types of JOINs
- ✅ Self-joins for hierarchical data
- ✅ Subqueries and nested queries
- ✅ Date and time functions
- ✅ String manipulation
- ✅ CASE statements
- ✅ Window functions (ROW_NUMBER, RANK, LAG, LEAD)
- ✅ Common Table Expressions (CTEs)
- ✅ Recursive queries
- ✅ Data quality analysis
- ✅ Statistical analysis in SQL
- ✅ Business intelligence queries
- ✅ Multi-table complex aggregations
- ✅ Temporal data handling
- ✅ Financial reconciliation
- ✅ Anomaly detection

---

**Good luck, detective! May your queries always return the truth. 🔍**