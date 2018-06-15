# Docker of OSS CVC IEEE P1364 Verilog simulator

## What's this

This container is open-source-software version of CVC verilog
simulater, released from [Tachyon-DA](http://www.tachyon-da.com/).

Documents of CVC are exist at
[Tachyon-DA's website](http://www.tachyon-da.com/).

## Usage

Working directory of this container is `/work`.
Generally, you can use the simulate such as:

``` sh
docker run --rm -it amura/open-src-cvc show-cvc_cmd > cvc
chmod +x cvc
./cvc TB.v design.v
```

## Thanks

* [Tachyon Design Automation Corp.](http://www.tachyon-da.com/).
  They disclosed their excellent simulator.

* Source code of CVC is downloaded from
  https://github.com/cambridgehackers/open-src-cvc .
