# GoogleVoice helper

a helper for signup a Google Voice number

## Install by one line

```bash
bash -c "`curl -sL git.io/gv`" -- -d
```

## Usage

1. clone or download this repository
2. run the `gv.sh` script
3. input curl command and gv number which you want
4. wait for submit post

```bash
  gv.sh [gv-number] [OPTION]...
```

Options:
  -t, --time=time       interval submit time, suffix same as sleep
  -d, --daemon          daemon mode, to omit SIGHUP, log is save to `gv-<number>.log`
  -h, --help            show this help message and exit

Example:

```bash
  gv.sh
  gv.sh -d
  gv.sh "(012) 345-6789" -t 1s -d
```

## note

curl command and gv number will save to file `gv-curl` and `gv-number`,
only if the file **NOT EXIST** that you need input curl or number,
but always you can use the number argument to override the `gv-number` file.

the way to get the curl command in Chrome: 
`voice.google.com` -> `Legacy Google Voice` -> `Settings` -> `DeveloperS Tools - Network` -> `POST: https://www.google.com/voice/b/0/service/post` -> `Copy as cURL (bash)`

