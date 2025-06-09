#!/usr/bin/env fish

# Simple test for ccw script
echo "🧪 Testing ccw script..."

# Set test mode
set -gx CCW_TEST_MODE 1

# Test 1: Help flag
echo -n "Test 1 - Help flag: "
if fish -c "source /Users/joeldrotleff/.config/nvim/lua/custom/fish/scripts/ccw.fish; ccw --help" | grep -q "ccw - Create Claude Worktree"
    echo "✅ PASS"
else
    echo "❌ FAIL"
end

# Test 2: No arguments
echo -n "Test 2 - No arguments error: "
if fish -c "source /Users/joeldrotleff/.config/nvim/lua/custom/fish/scripts/ccw.fish; ccw 2>&1" | grep -q "Error: Branch name required"
    echo "✅ PASS"
else
    echo "❌ FAIL"
end

# Test 3: Branch selection with invalid input
echo -n "Test 3 - Invalid branch selection: "
set output (echo "99" | fish -c "source /Users/joeldrotleff/.config/nvim/lua/custom/fish/scripts/ccw.fish; ccw test-branch 2>&1")
if echo "$output" | grep -q "Invalid selection"
    echo "✅ PASS"
else
    echo "❌ FAIL"
end

echo ""
echo "✨ Basic tests complete!"