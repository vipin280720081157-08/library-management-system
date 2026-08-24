-- ============================================
-- LIBRARY MANAGEMENT SYSTEM - SAMPLE DATA
-- ============================================

-- ============================================
-- STUDENTS (12 records)
-- ============================================
INSERT INTO students (full_name, email, phone, department, enrollment_year, joined_date) VALUES
('Aarav Sharma', 'aarav.sharma@example.com', '9876500001', 'AI & Data Science', 2023, '2023-07-15'),
('Diya Patel', 'diya.patel@example.com', '9876500002', 'Computer Science', 2022, '2022-08-01'),
('Kabir Singh', 'kabir.singh@example.com', '9876500003', 'AI & Data Science', 2023, '2023-07-20'),
('Ananya Iyer', 'ananya.iyer@example.com', '9876500004', 'Electronics', 2021, '2021-08-10'),
('Vihaan Reddy', 'vihaan.reddy@example.com', '9876500005', 'AI & Data Science', 2022, '2022-07-25'),
('Ishita Nair', 'ishita.nair@example.com', '9876500006', 'Mechanical', 2023, '2023-08-05'),
('Reyansh Gupta', 'reyansh.gupta@example.com', '9876500007', 'Computer Science', 2021, '2021-07-18'),
('Myra Desai', 'myra.desai@example.com', '9876500008', 'AI & Data Science', 2023, '2023-07-22'),
('Arjun Verma', 'arjun.verma@example.com', '9876500009', 'Civil', 2022, '2022-08-12'),
('Saanvi Rao', 'saanvi.rao@example.com', '9876500010', 'AI & Data Science', 2021, '2021-07-30'),
('Vivaan Joshi', 'vivaan.joshi@example.com', '9876500011', 'Computer Science', 2023, '2023-08-03'),
('Aditi Menon', 'aditi.menon@example.com', '9876500012', 'AI & Data Science', 2022, '2022-07-28');

-- ============================================
-- BOOKS (16 records)
-- ============================================
INSERT INTO books (title, author, category, isbn, total_copies, available_copies, added_date) VALUES
('Introduction to Algorithms', 'Thomas H. Cormen', 'Computer Science', '9780262033848', 5, 2, '2021-01-10'),
('Database System Concepts', 'Abraham Silberschatz', 'Computer Science', '9780078022159', 4, 1, '2021-01-10'),
('Artificial Intelligence: A Modern Approach', 'Stuart Russell', 'AI & ML', '9780136042594', 6, 3, '2021-02-15'),
('Pattern Recognition and Machine Learning', 'Christopher Bishop', 'AI & ML', '9780387310732', 3, 1, '2021-02-15'),
('Clean Code', 'Robert C. Martin', 'Software Engineering', '9780132350884', 5, 3, '2021-03-01'),
('The Pragmatic Programmer', 'Andrew Hunt', 'Software Engineering', '9780201616224', 4, 2, '2021-03-01'),
('Deep Learning', 'Ian Goodfellow', 'AI & ML', '9780262035613', 3, 0, '2021-04-05'),
('Python Crash Course', 'Eric Matthes', 'Programming', '9781593279288', 6, 4, '2021-04-05'),
('Operating System Concepts', 'Abraham Silberschatz', 'Computer Science', '9781118063330', 4, 2, '2021-05-10'),
('Computer Networks', 'Andrew S. Tanenbaum', 'Computer Science', '9780132126953', 3, 1, '2021-05-10'),
('The Elements of Statistical Learning', 'Trevor Hastie', 'AI & ML', '9780387848570', 2, 0, '2021-06-01'),
('Design Patterns', 'Erich Gamma', 'Software Engineering', '9780201633610', 3, 2, '2021-06-15'),
('Structured Query Language Guide', 'Alan Beaulieu', 'Databases', '9780596520847', 5, 3, '2021-07-01'),
('Data Structures Using C', 'Reema Thareja', 'Computer Science', '9780198099307', 4, 2, '2021-07-10'),
('Machine Learning Yearning', 'Andrew Ng', 'AI & ML', '9780999579500', 3, 1, '2021-08-01'),
('Fluent Python', 'Luciano Ramalho', 'Programming', '9781491946008', 4, 3, '2021-08-15');

-- ============================================
-- BOOK_ISSUE (20 records - mix of returned, current, overdue)
-- ============================================

-- Returned on time
INSERT INTO book_issue (student_id, book_id, issue_date, due_date, return_date, status) VALUES
(1, 1, '2024-01-05', '2024-01-19', '2024-01-17', 'RETURNED'),
(2, 3, '2024-01-06', '2024-01-20', '2024-01-19', 'RETURNED'),
(3, 5, '2024-01-08', '2024-01-22', '2024-01-20', 'RETURNED'),
(4, 8, '2024-01-10', '2024-01-24', '2024-01-22', 'RETURNED'),
(5, 13, '2024-01-12', '2024-01-26', '2024-01-25', 'RETURNED');

-- Returned LATE (fine applicable)
INSERT INTO book_issue (student_id, book_id, issue_date, due_date, return_date, status) VALUES
(6, 2, '2024-01-15', '2024-01-29', '2024-02-05', 'RETURNED'),
(7, 4, '2024-01-16', '2024-01-30', '2024-02-08', 'RETURNED'),
(8, 7, '2024-01-18', '2024-02-01', '2024-02-10', 'RETURNED'),
(9, 9, '2024-01-20', '2024-02-03', '2024-02-12', 'RETURNED');

-- Currently issued (within due date - not overdue)
INSERT INTO book_issue (student_id, book_id, issue_date, due_date, return_date, status) VALUES
(10, 6, '2026-08-10', '2026-08-24', NULL, 'ISSUED'),
(11, 10, '2026-08-12', '2026-08-26', NULL, 'ISSUED'),
(1, 14, '2026-08-15', '2026-08-29', NULL, 'ISSUED'),
(3, 16, '2026-08-18', '2026-09-01', NULL, 'ISSUED');

-- Currently OVERDUE (due date passed, not yet returned)
INSERT INTO book_issue (student_id, book_id, issue_date, due_date, return_date, status) VALUES
(2, 7, '2026-07-01', '2026-07-15', NULL, 'OVERDUE'),
(4, 11, '2026-07-05', '2026-07-19', NULL, 'OVERDUE'),
(5, 2, '2026-07-10', '2026-07-24', NULL, 'OVERDUE'),
(12, 9, '2026-07-12', '2026-07-26', NULL, 'OVERDUE'),
(6, 15, '2026-07-20', '2026-08-03', NULL, 'OVERDUE');

-- More returned records for richer stats
INSERT INTO book_issue (student_id, book_id, issue_date, due_date, return_date, status) VALUES
(7, 1, '2024-02-01', '2024-02-15', '2024-02-14', 'RETURNED'),
(8, 3, '2024-02-05', '2024-02-19', '2024-02-18', 'RETURNED'),
(9, 5, '2024-02-10', '2024-02-24', '2024-03-01', 'RETURNED');

-- ============================================
-- FINE (for the late-returned and overdue records)
-- issue_id values below correspond to the order inserted above
-- ============================================
INSERT INTO fine (issue_id, fine_amount, fine_date, paid) VALUES
(6, 35.00, '2024-02-05', TRUE),    -- returned late by 7 days (5/day)
(7, 45.00, '2024-02-08', TRUE),    -- late by 9 days
(8, 45.00, '2024-02-10', FALSE),   -- late by 9 days, unpaid
(9, 45.00, '2024-02-12', TRUE),    -- late by 9 days
(15, 45.00, '2026-08-24', FALSE),  -- overdue, still accruing (id 15 = first OVERDUE row)
(16, 25.00, '2026-08-24', FALSE),
(17, 15.00, '2026-08-24', FALSE),
(18, 5.00, '2026-08-24', FALSE),
(20, 65.00, '2024-03-01', TRUE);   -- returned very late