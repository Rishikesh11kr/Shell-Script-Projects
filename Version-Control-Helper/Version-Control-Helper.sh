#!/bin/bash

while true; do
    echo "Select a version control operation:"
    echo "1. Initialize Repository"
    echo "2. Stage Files"
    echo "3. Commit Changes"
    echo "4. Push Changes"
    echo "5. Pull Changes"
    echo "6. Resolve Merge Conflicts"
    echo "7. Exit"
    
    read -p "Enter your choice [1-7]: " choice

    if [ "$choice" -eq 1 ]; then
        git init
        echo "Repository initialized."
    elif [ "$choice" -eq 2 ]; then
        git add .
        echo "All files are  added to staging area."
    elif [ "$choice" -eq 3 ]; then
        read -p "enter commit message: " commit-message
        git commit -m "$commit-message"
        echo "Changes committed with message: '$commit-message'"
    elif [ "$choice" -eq 4 ]; then
        git push
        echo "Changes pushed to remote repository."
    elif [ "$choice" -eq 5 ]; then
        git pull
        echo "Changes pulled from remote repository."
    elif [ "$choice" -eq 6 ]; then
        echo "Checking for merge conflicts..."
        conflicts=$( git ls-files -u | wc -l)
        if [ "$conflicts" -gt 0 ]; then
            echo "Merge conflicts detected. Please resolve manually..."
            git status
        else
            echo "No merge conflicts found."
        fi
    elif [ "$choice" -eq 7 ]; then
        exit 0
    else
        echo "Invalid option. Please try again."
    fi
done
