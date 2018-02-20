Workflow in this directory is created for development and testing of the docker image.  All
scripts run on host.  Testing is done with the Strelka test dataset

*Also note that the Dockerfile has passwords associated with it, so it is not for distribution until 
somatic_wrapper is public*


Stuff below is old; see SomaticWrapper.workflow for ways to call SomaticWrapper docker image

# old

TODO: Split the development stuff (Docker, etc) from things which need to be run to initialize the
image on the host.

MGI stuff:
On your Mac, you'll need to run `docker login registry.gsc.wustl.edu`
Once you've updated the Dockerfile (or helpers) as desired, then you can `docker build .` from the directory, take the hash it produces,
run `docker tag <HASH> registry.gsc.wustl.edu/fdu/mgibio-cle-test`, and `docker push registry.gsc.wustl.edu/fdu/mgibio-cle-test`
That'll send it to our private repo; then you can use `docker(registry.gsc.wustl.edu/fdu/mgibio-cle-test)` in LSF 

But first need to get certificate: https://confluence.gsc.wustl.edu/pages/viewpage.action?spaceKey=IT&title=Docker+Private+Registry

-> this probably isn't worthwhile

TODO:

Ultimately we need to rebuild somaticwrapper so it does not use BreakpointSurveyor image as starting point.
This is unnecessary, and leads to weirdness like the github repository being cloned on container exit