## 0.0.8

- fix uuid error

## 0.0.7

- use `blkid | grep 'TYPE="ext4"' | grep '^/dev/nvme'` to filter no need uuid

## 0.0.6

- use `blkid -n` to filter no need uuid

## 0.0.5

- remove upper case cause linux return lower case

## 0.0.4

- use upper case to return machine code

## 0.0.3

- fix linux get hard drive's uuid
- remove salt support

## 0.0.2

- generate machine code only by hard drive's uuid and salt

## 0.0.1

- init release
