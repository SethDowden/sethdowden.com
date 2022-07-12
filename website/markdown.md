# continuous integration and deployment pipeline with Git Hooks

When creating my website, I encountered a problem where I would repeatedly manually deploy updates to my web server every time I made a minor change. This process was laborious and repetitive; there had to be a better way.

The solution was to host a bare git repository on my production web server and use BASH scripts in conjunction with git hooks to push my update to my Nginx http directory. 

While there are more commercial and feature-rich solutions such as [GitLab](https://about.gitlab.com/), [Jenkins](https://www.jenkins.io/), or even [Github Actions](https://github.com/features/actions), they all were overkill for my use case. Using git hooks was the most straightforward and most elegant solution that fit my needs without any additional features I did not need. 

## 1: create a bare repository on your production server
```
$ > git init -bare repository.git
```

## 2: create your Git hook
Hooks are bash scrips located in the .git/hooks/ directory of your git repository, which executes during specific points in a commits execution. 

for more examples on creating and implementing git hooks, check out 

https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks

for mroe information on git hoooks check out the [documentation](https://git-scm.com/docs/githooks)


$ > cd repository.git/hooks/
$ > touch post-receive

## 3: assing post-receive hook execute permissions 
you may need to change the permissions on post-receive to allow it to be an executable.
```
/mnt/c/Users/Seth Dowden/Documents/GitHub/sethdowden.com main* ⇡
❯
$ > chmod +x post-receive
```
```{bibliography}
```

