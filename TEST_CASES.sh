#!/bin/bash
# Test Script - Student Timetable App
# Comprehensive test for all features

echo "========================================"
echo "STUDENT TIMETABLE APP - COMPREHENSIVE TEST"
echo "========================================"
echo ""

# Test 1: Login with demo account
echo "TEST 1: Login with demo account (demo@test.com:demo123)"
echo "- Navigate to login page"
echo "- Enter email: demo@test.com"
echo "- Enter password: demo123"
echo "- Click login"
echo "- Expected: Redirect to Home page"
echo ""

# Test 2: Home Dashboard
echo "TEST 2: Home Dashboard"
echo "- Check greeting displays user name"
echo "- Check 4 stats cards: Môn học, Hôm nay, Lịch thi, Thông báo"
echo "- Click refresh button to reload stats"
echo "- Expected: Stats update with real data from providers"
echo ""

# Test 3: Add Subject
echo "TEST 3: Add Subject (CRUD - Create)"
echo "- Go to Subjects page"
echo "- Click 'Thêm môn học'"
echo "- Fill form: name='Toán Cao Cấp', day='Thứ 2', time='07:30-09:00'"
echo "- Click Save"
echo "- Expected: Subject appears in list, SnackBar shows success"
echo ""

# Test 4: Edit Subject
echo "TEST 4: Edit Subject (CRUD - Update)"
echo "- Go to Subjects page"
echo "- Click edit icon on a subject"
echo "- Change details and save"
echo "- Expected: Subject updated in list"
echo ""

# Test 5: Delete Subject
echo "TEST 5: Delete Subject (CRUD - Delete)"
echo "- Go to Subjects page"
echo "- Click delete icon on a subject"
echo "- Confirm in dialog"
echo "- Expected: Subject removed from list"
echo ""

# Test 6: Add Schedule
echo "TEST 6: Add Schedule"
echo "- Go to Schedule page"
echo "- Click 'Thêm lịch học'"
echo "- Select subject and enter time/room"
echo "- Click Save"
echo "- Expected: Schedule appears in list with subject info"
echo ""

# Test 7: Add Exam
echo "TEST 7: Add Exam"
echo "- Go to Exam page"
echo "- Click 'Thêm lịch thi'"
echo "- Fill form with subject and date"
echo "- Click Save"
echo "- Expected: Exam shows in list with countdown"
echo ""

# Test 8: Notifications
echo "TEST 8: Notifications Page"
echo "- Go to Notifications page"
echo "- Expected: Shows today's schedules + upcoming exams (within 3 days)"
echo "- Should combine data from Schedule + Exam providers"
echo ""

# Test 9: Settings
echo "TEST 9: Settings Page"
echo "- Go to Settings"
echo "- Check profile info displays"
echo "- Click Logout"
echo "- Confirm logout"
echo "- Expected: Redirect to Login page"
echo ""

# Test 10: Auth Redirect
echo "TEST 10: Auth Redirect"
echo "- Register new account"
echo "- Expected: Instant redirect to Home (no manual redirect needed)"
echo ""

echo "========================================"
echo "END OF TEST CASES"
echo "========================================"
