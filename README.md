# meta-mender-zynq

## The Repository

Welcome to the meta-mender-zynq Repo. This layer contains [mender](https://mender.io/) specific integrations for Xilinx Zynq 7000 hardware, for Over The Air (OTA) software update support of Xilinx Petalinux (Yocto) based Zynq 7000 builds.

See integration details in the [Mender Hub Page](https://hub.mender.io/t/incomplete-xilinx-zynq-7000/)

## Supported Boards

- Trenz TE0715-04 Module with Trenz TE0706-02 Carrier

## Dependencies

- Xilinx Petalinux 2023.2
- Mender
  - Golang
- hdf file (Likely generated by Xilinx Vivado 2018.3)

### Configuration

- Create user layer directory
  - `mkdir <projectdir>/project-spec/`
  - `cd <projectdir>/project-spec/`
- Download this layer
  - `git clone --branch=petalinux_2023.2 https://github.com/reachBAM/meta-mender-zynq.git`
- Download mender layer
  - `git clone --branch=kirkstone https://github.com/mendersoftware/meta-mender.git`
    - TODO: kirstone close enough to langdale???
- Run `petalinux-config`
  - cd `<projectdir>`
  - Add mender layers
    - Yocto Settings --->
    - User Layers --->
    - `${PROOT}/project-spec/meta-mender/meta-mender-core`
    - `${PROOT}/project-spec/meta-mender-zynq`
    - Exit
    - Exit
  - Disable automatic u-boot environmental settings
    - Subsystem AUTO Hardware Settings --->
    - Advanced bootable images storage Settings --->
    - u-boot env partition settings --->
    - image storage media --->
    - set to manual
    - Exit
    - Exit
    - Exit
  - Exit
- Enable Mender in root filesystem
  - `echo "CONFIG_mender=y" >> project-spec/configs/rootfs_config`
- Enable Mender in petalinux-build
  - `echo "CONFIG_mender" >> project-spec/meta-user/conf/user-rootfsconfig`
- Modify bootargs in `project-spec/meta-user/recipes-bsp/device-tree/files/system-user.dtsi`
  - Change `bootargs = "... root=XXX ...` to `bootargs = "... root=${mender_kernel_root} ...`
  - Note this only applies if you are overriding the boot args in the device tree
  - Alternatively, Petalinux may be defining it in `components/plnx_workspace/device-tree/device-tree/system-user.dtsi`
  - TODO: Provide example when not using device tree
- Add golang recipe
  - TBD
- Apply `petalinuxbsp.conf.append`
  - Copy and paste file contents to bottom of `project-spec/meta-user/conf/petalinuxbsp.conf`
- Configure project to generate hardware boot file and place on boot partition
  - Set path to hdf file in `project-spec/meta-user/conf/petalinuxbsp.conf`
    - Needs to be full path to hdf file generated by Xilinx Vivado tools
    - `HDF_PATH = "/home/<user>/.../<filename>.hdf"`
- (OPTIONAL) Configure project to place FPGA programming file in `<rootfs>/boot/` folder
  - `echo "CONFIG_fpgabin=y" >> project-spec/configs/rootfs_config`
  - `echo "IMAGE_INSTALL_append = " fpgabin"" >> project-spec/meta-user/recipes-core/images/petalinux-image-full.bbappend`
- Set [artifact name](https://docs.mender.io/2.0/artifacts/yocto-project/variables#mender_artifact_name) in project-spec/meta-user/conf/petalinuxbsp.conf
  - `MENDER_ARTIFACT_NAME="Example"`
- Set [SDCard Size](https://docs.mender.io/2.0/devices/yocto-project/partition-configuration#configuring-storage) in `project-spec/meta-user/conf/petalinuxbsp.conf`
  - `MENDER_STORAGE_TOTAL_SIZE_MB="30436"`

## Building

- `petalinux-build`

## Deployment

- `sudo dd bs=4M if=build/tmp/deploy/images/<machine_name>/<image_name>.sdimg of=/dev/sdX status=progress`
  - where `sdX` is the SDCard
