#!/usr/bin/env fish

# Test suite for ccw (Create Claude Worktree) script
# Run with: fish test_ccw.fish

# Colors for output
set -g GREEN (tput setaf 2)
set -g RED (tput setaf 1)
set -g YELLOW (tput setaf 3)
set -g RESET (tput sgr0)

# Test counters
set -g tests_passed 0
set -g tests_failed 0

# Test helper functions
function test_start
    set -g current_test $argv[1]
    echo -n "Testing $current_test... "
end

function test_pass
    echo "$GREEN✓ PASS$RESET"
    set tests_passed (math $tests_passed + 1)
end

function test_fail
    echo "$RED✗ FAIL$RESET"
    echo "  Error: $argv[1]"
    set tests_failed (math $tests_failed + 1)
end

function assert_equals
    if test "$argv[1]" = "$argv[2]"
        return 0
    else
        test_fail "Expected '$argv[2]' but got '$argv[1]'"
        return 1
    end
end

function assert_contains
    if string match -q "*$argv[2]*" "$argv[1]"
        return 0
    else
        test_fail "Expected to contain '$argv[2]' but got '$argv[1]'"
        return 1
    end
end

function assert_file_exists
    if test -f "$argv[1]"
        return 0
    else
        test_fail "Expected file '$argv[1]' to exist"
        return 1
    end
end

function assert_dir_exists
    if test -d "$argv[1]"
        return 0
    else
        test_fail "Expected directory '$argv[1]' to exist"
        return 1
    end
end

# Setup test environment
function setup_test_repo
    # Set test mode to prevent starting Claude
    set -gx CCW_TEST_MODE 1
    
    set -g test_dir (mktemp -d)
    set -g original_dir (pwd)
    cd $test_dir
    
    # Initialize git repo
    git init --quiet
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # Create initial commit
    echo "# Test Repository" > README.md
    git add README.md
    git commit -m "Initial commit" --quiet
    
    # Create main branch
    git branch -M main
    
    # Add a fake remote to prevent fetch errors
    git remote add origin https://github.com/test/test.git
    
    # Create some test branches
    git checkout -b feature-1 --quiet
    echo "Feature 1" > feature1.txt
    git add feature1.txt
    git commit -m "Add feature 1" --quiet
    
    git checkout -b feature-2 --quiet
    echo "Feature 2" > feature2.txt
    git add feature2.txt
    git commit -m "Add feature 2" --quiet
    
    git checkout main --quiet
    
    # Create a test .env file
    echo "TEST_VAR=123" > .env
    echo "ANOTHER_VAR=abc" > .env.local
    
    # Source the ccw script from the absolute path
    source /Users/joeldrotleff/.config/nvim/lua/custom/fish/scripts/ccw.fish
end

function cleanup_test_repo
    cd $original_dir
    rm -rf $test_dir
end

# Test 1: Help flag
function test_help_flag
    test_start "help flag"
    
    set output (ccw --help 2>&1)
    
    if assert_contains "$output" "ccw - Create Claude Worktree"
        and assert_contains "$output" "Usage:"
        and assert_contains "$output" "Examples:"
        test_pass
    end
end

# Test 2: No arguments error
function test_no_arguments
    test_start "no arguments error"
    
    set output (ccw 2>&1)
    set exit_code $status
    
    if test $exit_code -eq 1
        and assert_contains "$output" "Error: Branch name required"
        test_pass
    else
        test_fail "Expected error with exit code 1"
    end
end

# Test 3: Random name generation
function test_random_name
    test_start "random name generation"
    
    # Save current directory
    set test_cwd (pwd)
    
    # Mock user input for branch selection (just press Enter for default)
    echo "" | ccw --randomize >/dev/null 2>&1
    
    # Go back to test directory (ccw changes directory)
    cd $test_cwd
    
    # Check if a worktree was created with wt- prefix
    set worktrees
    for dir in wt-*
        if test -d "$dir"
            set worktrees $worktrees $dir
        end
    end
    
    if test (count $worktrees) -eq 1
        and string match -qr "^wt-[a-z]+-[a-z]+\$" $worktrees[1]
        test_pass
        # Cleanup
        git worktree remove $worktrees[1] --force 2>/dev/null
    else
        test_fail "Expected one worktree with pattern wt-<adjective>-<noun>"
    end
end

# Test 4: Named branch creation
function test_named_branch
    test_start "named branch creation"
    
    # Save current directory
    set test_cwd (pwd)
    
    # Mock user input for branch selection (just press Enter for default)
    echo "" | ccw test-feature >/dev/null 2>&1
    
    # Go back to test directory
    cd $test_cwd
    
    # Check if worktree was created
    if assert_dir_exists "wt-test-feature"
        # Check if branch was created
        set branches (git branch --format="%(refname:short)")
        if contains "test-feature" $branches
            test_pass
            # Cleanup
            git worktree remove wt-test-feature --force 2>/dev/null
        else
            test_fail "Branch 'test-feature' was not created"
        end
    end
end

# Test 5: .env file copying
function test_env_file_copy
    test_start ".env file copying"
    
    # Save current directory
    set test_cwd (pwd)
    
    # Create worktree (just press Enter for default)
    echo "" | ccw env-test >/dev/null 2>&1
    
    # Go back to test directory
    cd $test_cwd
    
    if assert_file_exists "wt-env-test/.env"
        and assert_file_exists "wt-env-test/.env.local"
        # Check content
        set env_content (cat wt-env-test/.env)
        if assert_equals "$env_content" "TEST_VAR=123"
            test_pass
            # Cleanup
            git worktree remove wt-env-test --force 2>/dev/null
        end
    end
end

# Test 6: Not in git repo error
function test_not_in_git_repo
    test_start "not in git repo error"
    
    # Save current directory
    set test_cwd (pwd)
    
    # Create temp dir without git
    set temp_dir (mktemp -d)
    cd $temp_dir
    
    set output (ccw test-branch 2>&1)
    set exit_code $status
    
    if test $exit_code -eq 1
        and assert_contains "$output" "Error: Not in a git repository"
        test_pass
    else
        test_fail "Expected error when not in git repo"
    end
    
    # Cleanup
    cd $test_cwd
    rm -rf $temp_dir
end

# Test 7: --imdone cleanup
function test_imdone_cleanup
    test_start "--imdone cleanup"
    
    # Save current directory
    set test_cwd (pwd)
    
    # Create a worktree first (just press Enter for default)
    echo "" | ccw cleanup-test >/dev/null 2>&1
    
    # Go back to test directory (ccw changes dir)
    cd $test_cwd
    
    # Go to the worktree
    cd $test_cwd/wt-cleanup-test
    
    # The .env files are copied but untracked, so we need to either:
    # 1. Add them to .gitignore, or
    # 2. Use --force, or
    # 3. Remove them before cleanup
    # Let's remove them for this test
    rm -f .env .env.local
    
    # Try cleanup
    set output (ccw --imdone 2>&1)
    
    if assert_contains "$output" "Worktree 'wt-cleanup-test' has been cleaned up"
        and test (basename (pwd)) = (basename $test_dir)  # Should be back in main repo
        test_pass
    else
        test_fail "Cleanup did not work as expected"
    end
    
    # Ensure we're back in test directory for next test
    cd $test_cwd
end

# Test 8: --imdone with uncommitted changes
function test_imdone_uncommitted_changes
    test_start "--imdone with uncommitted changes"
    
    # Save current directory
    set test_cwd (pwd)
    
    # Create a worktree (just press Enter for default)
    echo "" | ccw uncommitted-test >/dev/null 2>&1
    
    # Go back to test directory (ccw changes dir)
    cd $test_cwd
    
    # Go to the worktree
    cd $test_cwd/wt-uncommitted-test
    
    # Make uncommitted changes
    echo "uncommitted" > uncommitted.txt
    
    # Try cleanup without force
    set output (ccw --imdone 2>&1)
    set exit_code $status
    
    if test $exit_code -eq 1
        and assert_contains "$output" "You have uncommitted changes"
        test_pass
        # Cleanup
        cd $test_cwd
        git worktree remove wt-uncommitted-test --force 2>/dev/null
    else
        test_fail "Should fail with uncommitted changes"
    end
    
    # Ensure we're back in test directory for next test
    cd $test_cwd
end

# Test 9: --imdone --force
function test_imdone_force
    test_start "--imdone --force"
    
    # Save current directory
    set test_cwd (pwd)
    
    # Create a worktree (just press Enter for default)
    echo "" | ccw force-test >/dev/null 2>&1
    
    # Go back to test directory (ccw changes dir)
    cd $test_cwd
    
    # Go to the worktree
    cd $test_cwd/wt-force-test
    
    # Make uncommitted changes
    echo "will be discarded" > discard.txt
    
    # Try cleanup with force
    set output (ccw --imdone --force 2>&1)
    
    if assert_contains "$output" "Force mode enabled"
        and assert_contains "$output" "All changes have been reset"
        and assert_contains "$output" "Worktree 'wt-force-test' has been cleaned up"
        test_pass
    else
        test_fail "Force cleanup did not work"
    end
    
    # Ensure we're back in test directory for next test
    cd $test_cwd
end

# Test 10: Branch selection validation
function test_branch_selection
    test_start "branch selection"
    
    # Save current directory
    set test_cwd (pwd)
    
    # Test invalid number selection
    set output (echo "99" | ccw branch-select-test 2>&1)
    
    # Go back to test directory if needed
    cd $test_cwd
    
    if echo "$output" | grep -q "Invalid selection"
        test_pass
    else
        test_fail "Should reject invalid branch number"
    end
end

# Test 11: --imdone not in worktree error
function test_imdone_not_in_worktree
    test_start "--imdone not in worktree"
    
    # Run --imdone in main repo (not a worktree)
    set output (ccw --imdone 2>&1)
    set exit_code $status
    
    if test $exit_code -eq 1
        and assert_contains "$output" "Error: Not in a worktree"
        test_pass
    else
        test_fail "Should fail when not in worktree"
    end
end

# Main test runner
echo "🧪 Running ccw test suite..."
echo ""

# Setup
setup_test_repo

# Run tests
test_help_flag
test_no_arguments
test_random_name
test_named_branch
test_env_file_copy
test_not_in_git_repo
test_imdone_not_in_worktree
test_imdone_cleanup
test_imdone_uncommitted_changes
test_imdone_force
test_branch_selection

# Cleanup
cleanup_test_repo

# Summary
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Test Summary:"
echo "  $GREEN✓ Passed: $tests_passed$RESET"
echo "  $RED✗ Failed: $tests_failed$RESET"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Exit with appropriate code
if test $tests_failed -gt 0
    exit 1
else
    exit 0
end