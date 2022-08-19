# Git Verified

## How to sign your commits with GPG and pinentry

When setting up my new development environment, I ran into a few issues figuring out how to automatically sign my git commits and tags with GitHub Desktop. This blog post is intended to be a self-referential guide to aid me in setting up my git and GPG environment to work seamlessly with GitHub Desktop; hopefully, it can help you too.

## Install Dependencies

```` sh
❯ brew install git gpg pinentry-mac
❯ brew install --cask github
````

## Generate GPG Key

If you don't already have a GPG key, you first need to generate one; you can do so by running the command below and following the prompts. 

````sh
❯ gpg --full-generate-key
````

Additonal documentation on GPG key generation can be found [here](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)


## Import GPG Key

If you already have a GPG Key that you want to migrate to a new system, you can export your private keys and import them to a different computer.

Backup:

```sh
❯ gpg --export-secret-keys --armor YOUR_GPG_KEY_EMAIL > PATH_TO_BACKUP_DIRECTORY
❯ gpg --export-ownertrust > PATH_TO_BACKUP_DIRECTORY
```

Restore:

```sh
❯ gpg --export-secret-keys --armor YOUR_GPG_KEY_EMAIL > PATH_TO_SECRET_KEYS
❯ gpg --export-ownertrust > PATH_TO_BACKUP_DIRECTORY
```

## Git Config

Configuring git to sign all commits and tags.

Identify where GPG is installed.

````sh
❯ where gpg
/opt/homebrew/bin/gpg
````

Add the following lines to your .gitconfig.

````sh
# ~/.gitconfig
[user]
        # name and email must be the same as yoru GPG key
        name = YOUR_NAME
        email = YOUR_EMAIL
        signingkey = YOUR_GPG_KEY
[gpg]
        program = PATH_TO_GPG
[commit]
        gpgsign = true
[tag]
        gpgsign = true

````

## GPG Config

set penentry-mac as 

In your gpg-agent config file, define penentry-mac as your pinentry program.

Based on your risk tolerance, you can cashe your GPG key pair to avoid repeatedly typing your passphrase when performing multiple commits.

````sh
# ~/.gnupg/gpg-agent.conf

pinentry-program PATH_TO_PINENTRY

default-cache-ttl CASHE_TIME_IN_SECONDS
max-cache-ttl CASHE_TIME_IN_SECONDS
````

Restart the GPG agent to load the config file

````sh
❯ gpgconf --kill gpg-agent
````

## Add your GPG key to GitHub

In order to get that sweet, sweet, green verified check mark beside your commits on GitHub. You need to export your public key and add it to your keychain in <b>[GitHub Settings](https://github.com/settings/keys)</b>.

you can copy your public key to your clipboard with the following command on macs.

```sh
❯ gpg --armor --export YOUR_GPG_EMAIL | pbcopy
```

```{warning}
GitHub will not let you use a GPG key which dose not have the same email as your GitHub account!
```

## Aditional Resources

* [The GNU Privacy Handbook](https://www.gnupg.org/gph/en/manual.html)
* [Github Docs](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification)