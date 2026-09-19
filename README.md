# mise

## setup for a brand new machine 

install everything:

```
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
```

launch a new shell and run: 

```
mise doctor
```

this will make sure everything's working.

then run:

```
mise bootstrap --adopt https://github.com/joshlong/mise.git 
```


## notes from claude i should look into 

```

curl https://mise.run | sh
mise use -g bitwarden-cli                  # no auth needed for either step
bw login                                   # ← master password + 2FA; the only thing from your head
export BW_SESSION=$(bw unlock --raw)

mkdir -p ~/.config/mise
bw get notes "mise age identity" > ~/.config/mise/age.txt
chmod 600 ~/.config/mise/age.txt

bw get notes "github ssh key" > ~/.ssh/id_ed2PS with a PAT
```