#!/bin/bash

# Define the HTML content to inject with inline CSS
new_html=$'\n<div class="sidebar-primary-item" style="margin-top: -2rem;">\
<a class="navbar-brand logo" href="#">\
    <p class="title logo__title" style="font-size: 2rem;">Seth Dowden<\/p>\
<\/a>\
<\/div>'

# Change to the target directory
cd _build/html/

# Loop through all HTML files in the current directory
for file in *.html; do
    # Use sed to insert the new_html content after the target element
    sed -i '' -e '/<img src="_static\/Head.png" class="logo__image only-light" alt="Logo image"\/>/{n; a\'"$new_html"'
}' "$file"
done
