# Signal Appimage
Buildscript using Docker to create an Appimage of Signal Desktop for use on Fedora.

# Prerequisite
- (Possibly) Fedora, might work for other Distros as well 
- Installed [Docker](https://docs.docker.com/engine/install/). 

# Run
If needed add the *executeable* permission to the included *.sh* scripts. 
```
chmod u+x build.sh buildsignal.sh run.sh
```

After that just execute 
```
./buildsignal.sh
```

After a very long time a current build of Signal Desktop should appear in ./release as Appimage and be readily executeable.

# Credits
Concrete build steps are taken from: 
[https://github.com/michelamarie/fedora-signal/wiki/How-to-compile-Signal-Desktop-for-Fedora](https://github.com/michelamarie/fedora-signal/wiki/How-to-compile-Signal-Desktop-for-Fedora)
