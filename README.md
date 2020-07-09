[![HitCount](http://hits.dwyl.com/fluential/bash-script-template.svg)](http://hits.dwyl.com/fluential/bash-script-template)
# bash-script-template
A bash script template / boilerplate to start your script with.

It should cover all basic needs to create robust bash scripts - this is mostly around error handling + links to some guide documents, it will:
 - Gracefully cleanup() after itself by trapping SIGHUP SIGINT SIGQUIT SIGTERM signals - very usefull when you work on some resources and you want to release them even when the script is interrupted
 - Set shopt -s nullglob dotglob for better handling bash file expansions - becasue you should NOT parse ls output
 - Set -o pipefail to surface any failed commands torugh the pipe-line

There is no main function which the primary purpose is to make script sourceable by other scripts for function re-use.
Bash requires extra work to surface errors when you source scripts and if you really need more than this template you should consider a different language.

Feel free to contribute.
