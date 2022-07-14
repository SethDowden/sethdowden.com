# CI/CD With Git Hooks

## Continuous Integration and Deployment Pipeline With Git Hooks

When creating my website, I encountered a problem where I would repeatedly manually deploy updates to my web server every time I made a minor change. This process was laborious and repetitive; there had to be a better way.

The solution was to host a bare git repository on my production web server and use BASH scripts in conjunction with git hooks to push my update to my Nginx http directory.

While there are more commercial and feature-rich solutions such as [GitLab](https://about.gitlab.com/), [Jenkins](https://www.jenkins.io/), or even [Github Actions](https://github.com/features/actions), they all were overkill for my use case. Using git hooks was the most straightforward and elegant solution that fit my needs without any additional features I did not need.

## 1. Initialize Bare Repository

Bare repositories are git repositories that do not have working directories, and they are often used as a remote repository for your code base for sharing and collaboration. An example of bare repositories would be a GitHub repo.

To create a bare repository, first ssh into your production server and create a production repository directory which will be used to hold all of the repositories you run on your production server. Then create a bare repository. Bare repositories conventionally use the .git suffix.

    ❯ ssh user@server.com
    ❯ mikdr production && cd production
    ❯ git init -bare repository.git

for additional information on getting git set up on a server, check out the [documentation](https://git-scm.com/book/en/v2/Git-on-the-Server-Getting-Git-on-a-Server)

## 2. Create Git Hook

Hooks are bash scrips located in the .git/hooks/ directory of your git repository, which executes during specific points in a commits execution.

    ❯ cd repository.git/hooks/
    ❯ vim post-receive

below is an example of a post-receive script, credit to [noel boss](https://gist.github.com/noelboss/3fe13927025b89757f8fb12e9066f2fa), the original author of this code. I have made slight modifications to suit my use case.

````sh
#!/bin/bash
TARGET="/home/production/www"
GIT_DIR="/home/production/www.git"
BRANCH="main"

while read oldrev newrev ref
do
        # only checking out the master (or whatever branch you would like to deploy)
        if [ "$ref" = "refs/heads/$BRANCH" ];
        then
                echo "Ref $ref received. Deploying ${BRANCH} branch to production..."
                git --work-tree=$TARGET --git-dir=$GIT_DIR checkout -f $BRANCH
        else
                echo "Ref $ref received. Doing nothing: only the ${BRANCH} branch may be deployed on this server."
        fi
done

# run additional bash script for validation, testing, and deployment below

# copy html folder from my repository to my NGIN html folder
'cp' -rf /home/production/www/website/_build/html/* /home/docker/www/html
````

For more information on git hooks, check out the [documentation](https://git-scm.com/docs/githooks), and [examples](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).


## 3. Add Remote Repository

In your working directory on your local machine you can now add the remote repository we just created on the server by adding a remote repository.

     ❯ cd ~/working/repository
     ❯ git remote add production user@server.com/production/repository.git
     ❯ git push production main

Now every time you push your working directory to the remote production repository, the post-receive bash script will run. You can modify the post-receive script to run validations, unit testing, and deployment.

