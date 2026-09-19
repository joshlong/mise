# mise

## setup for a brand new machine 

git clone this repository, then run: `./bootstrap.sh`. it'll take care of everything from there. 

## packages

u can see which packages are missing with:

```
mise bootstrap packages status
```


## convergence: if u have manually removed a Homebrew dependency and want MISE to bring it back

```
mise bootstrap packages apply --yes
```

## convergence: if u have added dependencies via Homebrew and want MISE to incporate those...

```
mise bootstrap packages import --manager brew
```


## add a new encrypted secret

enter the following command once ur environment is setup. it'll write it to the closest mise.toml, including the one in the current directory. if none exists, it'll write it. this will read for ur input once u hit enter. this way, the raw value is never in ur console history.

```
mise set --age-encrypt --age-ssh-recipient ~/.ssh/mise_private_key.pub --prompt MY_KEY
```

