-- ============================================
-- LIBRARY MANAGEMENT SYSTEM - TABLE CREATION
-- ============================================

-- Drop tables if they exist (safe re-run, respects FK order)
DROP TABLE IF EXISTS fine;
DROP TABLE IF EXISTS book_issue;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS students;

-- ============================================
-- TABLE: students
-- ============================================
CREATE TABLE students (
    student_id      SERIAL PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    phone           VARCHAR(15) UNIQUE,
    department      VARCHAR(50) NOT NULL,
    enrollment_year INTEGER NOT NULL CHECK (enrollment_year BETWEEN 2015 AND 2030),
    joined_date     DATE NOT NULL DEFAULT CURRENT_DATE
);

-- ============================================
-- TABLE: books
-- ============================================
CREATE TABLE books (
    book_id         SERIAL PRIMARY KEY,
    title           VARCHAR(150) NOT NULL,
    author          VARCHAR(100) NOT NULL,
    category        VARCHAR(50) NOT NULL,
    isbn            VARCHAR(20) NOT NULL UNIQUE,
    total_copies    INTEGER NOT NULL CHECK (total_copies >= 0),
    available_copies INTEGER NOT NULL CHECK (available_copies >= 0),
    added_date      DATE NOT NULL DEFAULT CURRENT_DATE,
    CHECK (available_copies <= total_copies)
);

-- ============================================
-- TABLE: book_issue
-- (Also stores return info: return_date, status)
-- ============================================
CREATE TABLE book_issue (
    issue_id        SERIAL PRIMARY KEY,
    student_id      INTEGER NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    book_id         INTEGER NOT NULL REFERENCES books(book_id) ON DELETE CASCADE,
    issue_date      DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date        DATE NOT NULL,
    return_date     DATE,
    status          VARCHAR(20) NOT NULL DEFAULT 'ISSUED'
                    CHECK (status IN ('ISSUED', 'RETURNED', 'OVERDUE')),
    CHECK (due_date >= issue_date),
    CHECK (return_date IS NULL OR return_date >= issue_date)
);

-- ============================================
-- TABLE: fine
-- One fine per issue record (0 or 1 relationship)
-- ============================================
CREATE TABLE fine (
    fine_id         SERIAL PRIMARY KEY,
    issue_id        INTEGER NOT NULL UNIQUE REFERENCES book_issue(issue_id) ON DELETE CASCADE,
    fine_amount     NUMERIC(6,2) NOT NULL CHECK (fine_amount >= 0),
    fine_date       DATE NOT NULL DEFAULT CURRENT_DATE,
    paid            BOOLEAN NOT NULL DEFAULT FALSE
);

-- ============================================
-- INDEXES for performance
-- ============================================
CREATE INDEX idx_issue_student ON book_issue(student_id);
CREATE INDEX idx_issue_book ON book_issue(book_id);
CREATE INDEX idx_issue_status ON book_issue(status);