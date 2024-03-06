###############################################################################
# Variables

CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
STUDENT_FOLDER='student-submission'
GRADING_FOLDER='grading-area'

# Grading values to track
PASS_NUM=0
TOTAL_NUM=5

###############################################################################
# Macros for sanity

divider() {
    for i in {1..80}; do echo -n "-"; done; echo # Line divider  
}

report_grade() {
    # Calculate grade percentage with AWK
    PERCENT_GRADE=$(awk -v total=$TOTAL_NUM -v pass=$PASS_NUM \
     'BEGIN {printf pass/total*100}')
    divider
    echo -e "\nFinal test Grade: \t\t \
    [$PASS_NUM/$TOTAL_NUM]\t$PERCENT_GRADE%\n"
    divider
}

###############################################################################
# Filesystem setup

if [[ -d $STUDENT_FOLDER ]]; then
    rm -rf $STUDENT_FOLDER
fi
if [[ -d $GRADING_FOLDER ]]; then
    rm -rf $GRADING_FOLDER
fi

divider
echo "Testing submission: $1"
divider

###############################################################################
# Clone student submission; check if repo exists

git clone $1 $STUDENT_FOLDER > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "[INFO] Finished cloning submission."
else
    echo "[ERROR] Failed to clone student repo, Check URL."
    report_grade
    exit -1
fi

###############################################################################
# Check that student submission file exists

if [[ -f $STUDENT_FOLDER/ListExamples.java ]]; then
    echo "[PASS](1/1) Found student submission"
    PASS_NUM=$(($PASS_NUM+1))
else
    echo "[FAIL](0/1) Could not find student submission."
    report_grade
    exit -1
fi
###############################################################################
# Set up grading folder

mkdir $GRADING_FOLDER
cp -r ./lib $GRADING_FOLDER
cp $STUDENT_FOLDER/ListExamples.java $GRADING_FOLDER
cp TestListExamples.java $GRADING_FOLDER

cd $GRADING_FOLDER
javac -cp $CPATH *.java > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "[PASS](1/1) Compilation successful."
    PASS_NUM=$(($PASS_NUM+1))
else
    echo "[FAIL](0/1) Compilation of student submission failed."
    report_grade
    exit -1
fi

divider

###############################################################################
# Grading

TEST_OUTPUT=$(java -cp $CPATH org.junit.runner.JUnitCore TestListExamples \
 2> /dev/null)


###############################################################################
# Test 1

if [[ -n $(echo $TEST_OUTPUT | grep "testMergeRightEnd") ]]; then
    echo "[FAIL](0/1) merge() did not successfully merge two lists."
else
    echo "[PASS](1/1) merge() successfully merged two lists."
    PASS_NUM=$(($PASS_NUM+1))
fi
###############################################################################
# Test 2

if [[ -n $(echo $TEST_OUTPUT | grep "testMergeEmpty") ]]; then
    echo "[FAIL](0/1) merge() failed to merge an empty and non-empty list."
else
    echo "[PASS](1/1) merge() successfully merged an empty and non-empty list."
    PASS_NUM=$(($PASS_NUM+1))
fi

###############################################################################
# Test 3

if [[ -n $(echo $TEST_OUTPUT | grep "testFilter") ]]; then
    echo "[FAIL](0/1) filter() did not return the expected output."
else
    echo "[PASS](1/1) filter() returned expected output."
    PASS_NUM=$(($PASS_NUM+1))
fi

###############################################################################
# Final Reporting

report_grade
