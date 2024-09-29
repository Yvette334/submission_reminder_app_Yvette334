#!/bin/bash

# Create main app directory
mkdir -p submission_reminder_app

# Create subdirectories
mkdir -p submission_reminder_app/app
mkdir -p submission_reminder_app/config
mkdir -p submission_reminder_app/assets
mkdir -p submission_reminder_app/modules

# Create necessary files
touch submission_reminder_app/config/config.env
touch submission_reminder_app/assets/submissions.txt
touch submission_reminder_app/modules/functions.sh
touch submission_reminder_app/app/reminder.sh
touch submission_reminder_app/startup.sh

# Populate config.env file
cat <<EOL > submission_reminder_app/config/config.env
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL

# Populate submissions.txt file
cat <<EOL > submission_reminder_app/assets/submissions.txt
student, assignment, submission status
here, Shell Navigation, submitted
Noel, Shell Navigation, not submitted
paci, Shell Navigation, submitted
Desire, Shell Navigation, submitted
issa, Shell Navigation, submitted
yvette, Shell Navigation, not submitted
benitha, Shell Navigation, submitted
EOL

# Populate functions.sh file
cat <<EOL > submission_reminder_app/modules/functions.sh
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=\$1
    echo "Checking submissions in \$submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=\$(echo "\$student" | xargs)
        assignment=\$(echo "\$assignment" | xargs)
        status=\$(echo "\$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "\$assignment" == "\$ASSIGNMENT" && "\$status" == "not submitted" ]]; then
            echo "Reminder: \$student has not submitted the \$ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "\$submissions_file") # Skip the header
}
EOL

# Populate reminder.sh file
cat <<EOL > submission_reminder_app/app/reminder.sh
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: \$ASSIGNMENT"
echo "Days remaining to submit: \$DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions \$submissions_file
EOL

# Populate startup.sh file
cat <<EOL > submission_reminder_app/startup.sh
#!/bin/bash

# Navigate to the app directory and run the reminder script
./app/reminder.sh
EOL

# Make scripts executable
chmod +x submission_reminder_app/app/reminder.sh
chmod +x submission_reminder_app/modules/functions.sh
chmod +x submission_reminder_app/startup.sh

echo "Application environment created successfully!"

