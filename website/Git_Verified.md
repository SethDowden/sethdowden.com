# Git Verified
## How to sign all your git commits with gpg and pinentry

```` sh
❯ brew install gpg
❯ brew install pinentry-mac
````

## Generate GPG Key

````sh 
❯ gpg --full-generate-key

RSA
4096 bits 
Key is valid for? (0) 
Real Name: <Your Real Name>
Email: <email used for GitHub>
Commnent: <what ever you want>
Secrit:

````

## Import GPG Key



## Git Config

````sh
❯ where gpg
/opt/homebrew/bin/gpg
````

````sh
[user]
        name = <>
        email = <>
        signingkey = <>
[gpg]
        program = <path/to/gpg>
[commit]
        gpgsign = true
[tag]
        gpgsign = true

````


## GPG Config

````sh
❯ where pinentry-mac
/opt/homebrew/bin/pinentry-mac
````

````sh
default-cache-ttl 604800
max-cache-ttl 604800

pinentry-program /opt/homebrew/bin/pinentry-mac
````