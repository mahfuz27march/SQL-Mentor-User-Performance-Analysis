-- Table creation--------
create table user_submissions(
	id serial primary key,
	user_id bigint,
	question_id int,
	points int,
	submitted_at timestamp with time zone,
	username varchar(50)
)

-- Problem solving------------
select * from user_submissions
/*
Q1. List All Distinct Users and Their Stats
Description: Return the user name, total submissions, and total points earned by each user.
Expected Output: A list of users with their submission count and total points.
*/

select 
	distinct username,
	count(id) as total_submissions,
	sum(points) as total_points_earned
from user_submissions	
group by 1
order by 2 desc

/*
Q2. Calculate the Daily Average Points for Each User
Description: For each day, calculate the average points earned by each user.
Expected Output: A report showing the average points per user for each day.
*/

select 
	username,
	to_char(submitted_at,'DD-MM') as day,
	avg(points) as avg_points_user
from user_submissions 
	group by 1,2
	order by 1

/*
Q3. Find the Top 3 Users with the Most Correct Submissions for Each Day
Description: Identify the top 3 users with the most correct submissions for each day.
Expected Output: A list of users and their correct submissions, ranked daily.
*/----------not complete yet
	select username,sum(points),count(user_id) from(	
		select * from user_submissions 
		where to_char(submitted_at,'dd-mm-yyyy')='04-11-2024' ) group by 1
select
	username,
	to_char(submitted_at,'dd-mm-yyyy') as day,
	sum(points) as submission_points
from user_submissions
group by 1,2
order by 3 desc
limit 3

/*
Q4: Find the Top 5 Users with the Highest Number of Incorrect Submissions
*/


select 
	username,
	sum(case when points<0 then 1 else 0 end) as incorrent_answer,
	sum(case when points<0 then points else 0 end) as incorrent_answer_point
from user_submissions	
group by 1
order by 2 desc
limit 5

/*
Q5: Find the Top 10 Performers for Each Week
*/
select * from user_submissions
select * from
(select 
	username,
	extract(week from submitted_at) no_week,
	count(question_id) as no_of_question,
	sum(points) as total_point,
	dense_rank() over(partition by extract(week from submitted_at) order by sum(points) desc) as rank
from user_submissions
group by 1,2)
where rank<=10
