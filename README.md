# wachtmeister
[![Build Status](https://travis-ci.org/DonReeal/wachtmeister.svg?branch=master)](https://travis-ci.org/DonReeal/wachtmeister)

## run locally

### using gradle 
From main working directory run:

```bash
gradlew clean jar run
```

Open your browser at localhost:3300


### using eclipse

> Prerequisites
> * You will need to have eclipse xtend plugin installed
> * When using a windows pc: set text file encoding to UTF-8 
> e.g. Preferences > Workspace > Text file ecoding: UTF-8. 
> This is currently neccessary as Xtext gradle plugin seems to be using UTF-8 for encoding and not platform standard encoding as would be expected.

Launch SimpleLoginServer.xtend as Java application 
& Open your browser at localhost:3300
