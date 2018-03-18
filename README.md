# somaticwrapper
Detect somatic variants from tumor and normal exome data

SomaticWrapper pipeline is a fully automated and modular software package
designed for detection of somatic variants from tumor and normal exome data. 
It was developed from GenomeVIP. Multiple standard
variant callings are included in the pipeline such as varscan, strelka and
pindel. 

## Installation

See [SomaticWrapper.CPTAC3.b1](https://github.com/ding-lab/SomaticWrapper.CPTAC3.b1) for details
about installation and usage of SomaticWrapper

## Implementation

![Somatic Wrapper Overview](docs/SomaticWrapper.v2.Overview.png)
![Somatic Wrapper Pindel Details](docs/SomaticWrapper.v2.Pindel.png)
![Somatic Wrapper Strelka Details](docs/SomaticWrapper.v2.Strelka.png)
![Somatic Wrapper Varscan Details](docs/SomaticWrapper.v2.Varscan.png)

## Branches

`docker` branch has work on version of SomaticWrapper which runs in dockerized container at 
MGI or DC2 (uses SomaticWrapper.Workflow for help)

`cwl` branch makes changes to make SomaticWrapper operate in CWL environment. Specific changes:
  * all arguments are passed on command line, rather than configuraiton file
  * Output directory is passed as an argument explicitly, so that directry structure is not
    dependent on run name
  * inputs and outputs are more explicitly defined

## Authors

* Song Cao
* Matthew Wyczalkowski
