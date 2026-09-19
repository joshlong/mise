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