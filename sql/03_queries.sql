-- ============================================
-- LIBRARY MANAGEMENT SYSTEM - QUERIES
-- ============================================

-- ==============================
-- SECTION 1: BASIC SELECTS
-- ==============================

-- 1. Display all students
SELECT * FROM students ORDER BY student_id;

-- 2. Display all books
SELECT * FROM books ORDER BY book_id;

-- 3. Search books by title (partial match, case-insensitive)
SELECT title, author, category FROM books
WHERE title ILIKE '%python%';

-- 4. Search books by author/category
SELECT title, author, category FROM books
WHERE author ILIKE '%silberschatz%' OR category = 'AI & ML';

-- 5. Count total books (by copies, not titles)
SELECT SUM(total_copies) AS total_book_copies FROM books;

-- 6. Count books by category
SELECT category, COUNT(*) AS number_of_titles
FROM books
GROUP BY category
ORDER BY number_of_titles DESC;

-- ==============================
-- SECTION 2: ISSUE / RETURN STATUS
-- ==============================

-- 7. Display currently issued books (status = ISSUED)
SELECT issue_id, student_id, book_id, issue_date, due_date
FROM book_issue
WHERE status = 'ISSUED';

-- 8. Display complete issue history
SELECT * FROM book_issue ORDER BY issue_date;

-- 9. Issue details with student and book names (INNER JOIN across 3 tables)
SELECT
    bi.issue_id,
    s.full_name AS student_name,
    b.title AS book_title,
    bi.issue_date,
    bi.due_date,
    bi.status
FROM book_issue bi
INNER JOIN students s ON bi.student_id = s.student_id
INNER JOIN books b ON bi.book_id = b.book_id
ORDER BY bi.issue_date;

-- 10. Show returned books
SELECT s.full_name, b.title, bi.issue_date, bi.return_date
FROM book_issue bi
JOIN students s ON bi.student_id = s.student_id
JOIN books b ON bi.book_id = b.book_id
WHERE bi.status = 'RETURNED';

-- 11. Show currently borrowed books (not yet returned)
SELECT s.full_name, b.title, bi.due_date
FROM book_issue bi
JOIN students s ON bi.student_id = s.student_id
JOIN books b ON bi.book_id = b.book_id
WHERE bi.status IN ('ISSUED', 'OVERDUE');

-- ==============================
-- SECTION 3: OVERDUE & FINES
-- ==============================

-- 12. Find overdue books (due date passed, not returned)
SELECT s.full_name, b.title, bi.due_date
FROM book_issue bi
JOIN students s ON bi.student_id = s.student_id
JOIN books b ON bi.book_id = b.book_id
WHERE bi.status = 'OVERDUE' OR (bi.return_date IS NULL AND bi.due_date < CURRENT_DATE);

-- 13. Calculate overdue days for each active loan
SELECT
    s.full_name,
    b.title,
    bi.due_date,
    (CURRENT_DATE - bi.due_date) AS days_overdue
FROM book_issue bi
JOIN students s ON bi.student_id = s.student_id
JOIN books b ON bi.book_id = b.book_id
WHERE bi.return_date IS NULL AND bi.due_date < CURRENT_DATE;

-- 14. Calculate fines dynamically (₹5/day late) for RETURNED records
SELECT
    bi.issue_id,
    s.full_name,
    b.title,
    (bi.return_date - bi.due_date) AS days_late,
    GREATEST((bi.return_date - bi.due_date) * 5, 0) AS calculated_fine
FROM book_issue bi
JOIN students s ON bi.student_id = s.student_id
JOIN books b ON bi.book_id = b.book_id
WHERE bi.status = 'RETURNED' AND bi.return_date > bi.due_date;

-- 15. Students with currently borrowed books
SELECT DISTINCT s.student_id, s.full_name
FROM students s
JOIN book_issue bi ON s.student_id = bi.student_id
WHERE bi.status IN ('ISSUED', 'OVERDUE');

-- ==============================
-- SECTION 4: AGGREGATES & GROUP BY
-- ==============================

-- 16. Count books borrowed by each student
SELECT s.full_name, COUNT(bi.issue_id) AS books_borrowed
FROM students s
LEFT JOIN book_issue bi ON s.student_id = bi.student_id
GROUP BY s.full_name
ORDER BY books_borrowed DESC;

-- 17. Student who borrowed the most books
SELECT s.full_name, COUNT(bi.issue_id) AS total_borrowed
FROM students s
JOIN book_issue bi ON s.student_id = bi.student_id
GROUP BY s.full_name
ORDER BY total_borrowed DESC
LIMIT 1;

-- 18. Most frequently borrowed books
SELECT b.title, COUNT(bi.issue_id) AS times_borrowed
FROM books b
JOIN book_issue bi ON b.book_id = bi.book_id
GROUP BY b.title
ORDER BY times_borrowed DESC
LIMIT 5;

-- 19. Calculate total fines collected and pending
SELECT
    SUM(fine_amount) AS total_fine_amount,
    SUM(CASE WHEN paid THEN fine_amount ELSE 0 END) AS collected,
    SUM(CASE WHEN NOT paid THEN fine_amount ELSE 0 END) AS pending
FROM fine;

-- 20. Students with unpaid/active fines
SELECT s.full_name, b.title, f.fine_amount, f.paid
FROM fine f
JOIN book_issue bi ON f.issue_id = bi.issue_id
JOIN students s ON bi.student_id = s.student_id
JOIN books b ON bi.book_id = b.book_id
WHERE f.paid = FALSE
ORDER BY f.fine_amount DESC;

-- ==============================
-- SECTION 5: GROUP BY + HAVING
-- ==============================

-- 21. Categories with more than 2 titles (GROUP BY)
SELECT category, COUNT(*) AS title_count
FROM books
GROUP BY category
ORDER BY title_count DESC;

-- 22. Students who borrowed more than 1 book (HAVING)
SELECT s.full_name, COUNT(bi.issue_id) AS total_books
FROM students s
JOIN book_issue bi ON s.student_id = bi.student_id
GROUP BY s.full_name
HAVING COUNT(bi.issue_id) > 1
ORDER BY total_books DESC;

-- ==============================
-- SECTION 6: JOIN VARIATIONS
-- ==============================

-- 23. INNER JOIN - only students who have issued at least one book
SELECT s.full_name, b.title
FROM students s
INNER JOIN book_issue bi ON s.student_id = bi.student_id
INNER JOIN books b ON bi.book_id = b.book_id;

-- 24. LEFT JOIN - all students, including those who never borrowed anything
SELECT s.full_name, bi.issue_id, b.title
FROM students s
LEFT JOIN book_issue bi ON s.student_id = bi.student_id
LEFT JOIN books b ON bi.book_id = b.book_id
ORDER BY s.full_name;

-- ==============================
-- SECTION 7: CASE EXPRESSIONS
-- ==============================

-- 25. Label each loan with a human-readable status using CASE
SELECT
    s.full_name,
    b.title,
    bi.due_date,
    bi.return_date,
    CASE
        WHEN bi.status = 'RETURNED' AND bi.return_date <= bi.due_date THEN 'Returned On Time'
        WHEN bi.status = 'RETURNED' AND bi.return_date > bi.due_date THEN 'Returned Late'
        WHEN bi.status = 'OVERDUE' THEN 'Currently Overdue'
        ELSE 'Currently Issued'
    END AS loan_status
FROM book_issue bi
JOIN students s ON bi.student_id = s.student_id
JOIN books b ON bi.book_id = b.book_id
ORDER BY bi.issue_date;

-- ==============================
-- SECTION 8: AGGREGATE FUNCTIONS
-- ==============================

-- 26. Average, min, max fine amount
SELECT
    ROUND(AVG(fine_amount), 2) AS avg_fine,
    MIN(fine_amount) AS min_fine,
    MAX(fine_amount) AS max_fine
FROM fine;

-- ==============================
-- SECTION 9: SUBQUERIES
-- ==============================

-- 27. Books that have NEVER been issued (subquery with NOT IN)
SELECT title, author
FROM books
WHERE book_id NOT IN (SELECT DISTINCT book_id FROM book_issue);

-- 28. Students who have an unpaid fine (subquery with IN)
SELECT full_name, email
FROM students
WHERE student_id IN (
    SELECT bi.student_id
    FROM book_issue bi
    JOIN fine f ON bi.issue_id = f.issue_id
    WHERE f.paid = FALSE
);