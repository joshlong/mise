# mise

## setup for a brand new machine 

- `git clone https://github.com/joshlong/mise.git`
- `curl https://mise.run | sh`
- `echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc`
- 

```
curl https://mise.run | sh
echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
git clone https://github.com/joshlong/mise.git ~/josh-mise
cd ~/josh-mise && mise trust && mise bootstrap
```