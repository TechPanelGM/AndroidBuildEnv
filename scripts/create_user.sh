#!/bin/bash

# Function to create a new user
create_user() {
  read -p "Enter the username: " username
  sudo adduser $username
  
  if [ $? -eq 0 ]; then
    echo "User $username created successfully."
    
    # Assign permissions (example: adding the user to the sudo group)
    sudo usermod -aG sudo $username
    
    if [ $? -eq 0 ]; then
      echo "User $username has been given sudo permissions."
      su $username
    else
      echo "Failed to assign permissions to $username."
    fi
  else
    echo "Failed to create user $username."
  fi
}

create_user
