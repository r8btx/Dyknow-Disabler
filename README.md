# Dyknow Off Switch
The goal is to create a batch script that can turn Dyknow monitoring service on and off from the non-administrative environment (Windows).

## Features
* Simple Setup
  * Automatic setup that does not require any user input
* On / Off switch
  * Can simply toggle the Dyknow service on and off by just running
* Overwrite log data
  * Automatically overwrites specific log data that is located in "C:\ProgramData\DyKnow\data" with Null
* No Leftovers
  * Makes changes only on Dyknow related files and service
  * Easy to reset

## How to use
* Only for initial setup, the script requires an administrator privilege.
* The script will automatically toggle the Dyknow service by just executing.
* To re-setup the script, users can open the script file with a text editor and take out the service name(s) from the bottom of the file.
