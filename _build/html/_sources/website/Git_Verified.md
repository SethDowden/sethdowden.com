# Git Verified

# Signing Git Commits and Tags with GPG and Pinentry

When setting up my new development environment, I ran into a few issues figuring out how to automatically sign my git commits and tags with GitHub Desktop. This blog post is intended to be a self-referential guide to aid me in setting up my git and GPG environment to work seamlessly with GitHub Desktop; hopefully, it can help you too.

## Introduction

By signing your Git commits and tags with GPG, you add an extra layer of security to your work, allowing anyone who sees your code to verify that it indeed is yours.

In this guide, I'll walk you through the steps involved, from installing the necessary dependencies, generating a GPG key, configuring both Git and GPG, to finally adding your GPG key to GitHub. By the end of it, you'll have a development environment that automatically signs your Git commits and tags, providing a 'Verified' badge on GitHub commits.

## Install Dependencies

To get started, you'll need to install a few dependencies on your system. On macOS, you can install these dependencies using the brew package manager. If you're using a different operating system, you'll need to install the dependencies using your system's package manager.

``` sh
❯ brew install git gpg pinentry-mac
❯ brew install --cask github
```

## Generate GPG Key

If you don’t already have a GPG key, you first need to generate one; you can do so by running the command below and following the prompts.

````sh
❯ gpg --full-generate-key
````

Once you have completed these steps, your GPG key will be generated. You can view your key by running the gpg --list-keys command.

For more information on GPG key generation, see the [GitHub documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key).

## Import GPG Key

If you already have a GPG key that you want to use on a different system, you can export your private key from the original system and import it onto the new system.

To export your GPG key and ownertrust data from the original system, execute the following commands:

```{warning}
Warning: The files you'll generate contain your private GPG keys. Never share them with anyone as they can be used to impersonate your identity.
```

````sh
❯ gpg --export-secret-keys --armor YOUR_GPG_KEY_EMAIL > PATH_TO_BACKUP_DIRECTORY
❯ gpg --export-ownertrust > PATH_TO_BACKUP_DIRECTORY
````

Securely transfer the exported private key and ownertrust file to the new system, using a USB drive or other secure method. Once transferred, import the key and ownertrust data onto the new system with the following commands:

````sh
❯ gpg --import PATH_TO_SECRET_KEYS
❯ gpg --import-ownertrust PATH_TO_BACKUP_OWNERTRUST
````

Your GPG key and ownertrust data will now be imported into the new system. You can verify that your key has been successfully added to your new system by running the 'gpg --list-keys' command. 

For more information on exporting and importing GPG keys, see the [GitHub documentation](https://docs.github.com/en/authentication/managing-commit-signature-verification).

## Git Config

Now lets configure git to sign all commits and tags with your GPG key. first Identify the location of the GPG executable on your system by running the following command:

````sh
❯ where gpg
/opt/homebrew/bin/gpg # example output for macOS using brew
````

Keep a note of this path, you'll need it later.

Then, open your .gitconfig file. Typically, it's located in your home directory like so: ~/.gitconfig

Modify your .gitconfig file by adding the following lines:

````sh
# ~/.gitconfig
[user]
        # name and email must be the same as your GPG key
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

Replace YOUR_NAME and YOUR_EMAIL with the name and email associated with your GPG key, and YOUR_GPG_KEY with the ID of your GPG key (e.g. BC9FFB93381CECC1). Replace PATH_TO_GPG with the path to the gpg executable that you identified earlier.

With these changes, git will now sign all commits and tags with your GPG key.

## GPG Config

To set pinentry-mac as the default pinentry program, make the necessary changes in your gpg-agent config file. Depending on your needs, you may also choose to cache your GPG key pair to avoid repeated passphrase input for multiple commits.

Update your gpg-agent config file as shown below:

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

To export your public key, run the following command:

```sh
❯ gpg --armor --export YOUR_GPG_EMAIL
```

Then, navigate to your [GitHub Settings](https://github.com/settings/keys) click on "New GPG key", paste your public key into the "GPG key" field, and hit "Add GPG key".

```{warning}
Note: GitHub will not allow you to use a GPG key with an email that does not match the email associated with your GitHub account.
```
## Congratulations!!

You've successfully configured your development environment to automatically sign your Git commits and tags with GPG. Now, whenever you commit or tag your code, you'll see a 'Verified' badge on GitHub.

## Aditional Resources

If you get stuck or want to learn more, check out the following resources:

* [The GNU Privacy Handbook](https://www.gnupg.org/gph/en/manual.html)
* [Github Docs](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification)