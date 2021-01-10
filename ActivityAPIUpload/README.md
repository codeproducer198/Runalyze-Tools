# ActivityAPIUpload

Linux scripts for uploading all (activitiy) files in the specified folder to your own Runalyze via the upload API.

Command example for a connected "Garmin Fenix 6" is: `./runalyzeUpload.sh user /run/user/$UID/gvfs/mtp*/Primary/GARMIN/Activity localhost:8022`.

The `user` is your runalyze user account. The script will ask you for the password.

This script only works with the [codeproducer198s Runalyze fork](https://github.com/codeproducer198/Runalyze).
