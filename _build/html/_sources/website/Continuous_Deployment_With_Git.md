# CI/CD With Git Hooks

## Continuous Integration and Deployment Pipeline With Git Hooks

In the process of building my website, I was repeatedly faced with the tedious task of manually deploying updates to my web server each time a minor change was introduced. I knew there had to be a better way to automate this process. 

I found my solution in hosting a bare git repository on my production web server and leveraging BASH scripts along with git hooks to expedite updates to my Nginx www directory.

While there are more commercial and feature-rich solutions such as [GitLab](https://about.gitlab.com/), [Jenkins](https://www.jenkins.io/), or even [Github Actions](https://github.com/features/actions), they all were overkill for my use case. Using git hooks was the most straightforward and elegant solution that fit my needs without any additional features I did not need.

## 1. Initialize Bare Repository

Bare repositories are git repositories that do not have working directories, and they are often used as a remote repository for your code base for sharing and collaboration. An example of a bare repository would be a GitHub repo.

To create a bare repository, first, ssh into your production server and create a production repository directory which will be used to hold all of the repositories you run on your production server. Then create a bare repository. Bare repositories conventionally use the .git suffix.

````sh
❯ ssh user@server.com
❯ mikdr production && cd production
❯ git init -bare repository.git
````

Now you have a bare repository on your production server. You can now clone this repository to your local machine and push your working directory to the remote repository.

for additional information on getting git set up on a server, check out the [documentation](https://git-scm.com/book/en/v2/Git-on-the-Server-Getting-Git-on-a-Server)

## 2. Create Git Hook

Hooks are bash scripts located in the .git/hooks/ directory of your git repository, which executes during specific points in a commits execution. There are two types of hooks: client-side and server-side. Client-side hooks are triggered by committing and merging, while server-side hooks are triggered by network operations such as receiving pushed commits. We can use the server-side hooks to automate our deployment process.

````sh
❯ cd repository.git/hooks/
❯ vim post-receive
````

below is an example of a post-receive script.

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
credit to [noel boss](https://gist.github.com/noelboss/3fe13927025b89757f8fb12e9066f2fa), the original author of this code. I have made slight modifications to suit my use case. For more information on git hooks, check out the [documentation](https://git-scm.com/docs/githooks), and [examples](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).

In this script, the branch reference from each push is read and compared to the designated deployment branch ("main"). If it matches, the script checks out the branch's content to the TARGET directory, thus deploying it to the production server. If not, it simply acknowledges the push without any action.

After the checkout, the script performs an additional task: copying the contents of the HTML folder from the repository to the HTML folder of the NGINX server, thereby updating the website with the latest changes. This script thus aids in automating website updates in a CI/CD pipeline.

## 3. Add Remote Repository

To incorporate the recently created remote repository, head to your working directory on your local machine and add the remote repository:

````sh
     ❯ cd ~/working/repository
     ❯ git remote add production user@server.com/production/repository.git
     ❯ git push production main
````

With this setup, each time you push updates from your local working directory to the remote production repository, the post-receive script is triggered. This script can be modified to automate additional tasks like validation, unit testing, and deployment, further streamlining your workflow.