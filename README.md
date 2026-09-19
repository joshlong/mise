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
mise use -g bitwarden-cli
bw login
export BW_SESSION=$(bw unlock --raw)
mkdir -p ~/.config/mise
bw get notes "mise-bootstrap-private-ssh-key" > ~/.ssh/id_ed25519
mise bootstrap --adopt https://github.com/joshlong/mise.git

```

<!-- 
curl https://mise.run | sh
mise use -g bitwarden-cli
bw login
export BW_SESSION=$(bw unlock --raw)

mkdir -p ~/.config/mise
bw get notes "mise age identity" > ~/.config/mise/age.txt
chmod 600 ~/.config/mise/age.txt

bw get notes "github ssh key" > ~/.ssh/id_ed25519   # or clone over HTTPS with a PAT
chmod 600 ~/.ssh/id_ed25519

git clone git@github.com:joshlong/josh-env.gi
cd ~/josh-env && mise trust && mise bootstrap

I'd store both as secure notes rather than Bitwarden's SSH-key item type — bw get notes is explicitly a supported object in the CLI, so the retrieval path is o no JSON parsing.

 -->