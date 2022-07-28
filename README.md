# Before you proceed
This is a tool made in my journey to learn bash scripting, it is for **EDUCATIONAL PURPOSES ONLY** and I am **NOT** in any way responsible for your actions.

That being said, let's take a look at the tool:

# What is Mass Deauth
Mass Deauth is a bash script for Linux systems that automates the process of deauthenticating all wireless networks in an area utilizing the [Aircrack-ng](https://github.com/aircrack-ng/aircrack-ng) suite. It is a unique/one of its kind script and the only tool on GitHub, as far as I am concerned, to use aireplay-ng at a larger scale.

PS: If you are an author of a similar tool and wish to collaborate or share ideas, feel free to contact me using one of the ways mentioned at the end of the README.

# Why not use [Aircrack-ng](https://github.com/aircrack-ng/aircrack-ng) directly
[Aircrack-ng](https://github.com/aircrack-ng/aircrack-ng) is a great tool for various WiFi attacks and in my opinion aireplay-ng is one of the best tools when it comes to deauthenticating modern wireless networks. The problem is that it lacks in the area of automation. It's only good for targeted deauth attacks and the process can get repetetive when you need to deauth a larger number of APs.

# Features
**This is the first public version of Mass Deauth and since it is still in developement it isn't feature-rich so this is more of a "What I plan to add" list for now.**

 - [x] Deauthenticate all wireless access points in a nearby area
 - [x] Support for both 2.4Ghz and 5Ghz bands
 - [x] Automatically detect and change interface from managed to monitor mode
 - [ ] Headless Mode
 - [ ] Tmux suppot for gui in headless invironments
 - [ ] Other ways to perform dauth attacks
 - [ ] More interactive and pleasant UI (colors , better xterm window handling etc)
 - [ ] Ctrl+C trap for a better way of exiting the script

# Requirements
* A Linux bash shell (tested on bash version 5.1.16 but should work on earlier versions)
* The [Aircrack-ng](https://github.com/aircrack-ng/aircrack-ng) suite
* XTerm

You can grab all of the above from your distro's package manager.

# Notes

### Window Flooding
* As mentioned above there is no headless mode and the XTerm window handling is not very optimal at the moment, meaning that if you are in an area that has a lot of APs you'll be flooded with deauth windows (this could cause some performance issues on older systems). Rest assured, I'm working on a fix for this.

### Exiting with Ctrl+C breaks the script
* Quiting the script with Ctrl+C will leave .MassDeauthTemp folder and its contents on the system, which will cause airodump-ng to change the name of the output file if you run it again. So please do delete the folder yourself if you exit the tool. Alternatively, follow the on screen instractions when prompted to correctly exit the script.

# License
Released under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html)


# Finally
### Contribute
If you have any suggestions or want to contribute to the project, please do so on the GitHub repo or via email DENNISDGR@protonmail.com.
Also, if you have any questions, feel free to ask me on Discord (DENNISDGR#4419).

### Support
If you want to support the development of my projects, you can do so by donating in one of the following ways:

* XMR address: 89Rg5gxnuGpbKSCsXfmtnEYPubMP6HkKP9WYXNJNCVinVyvKeY5XGeRFJDK7fhNnSs14yXtGxFivNDSzeJaMaPbXVp4RzAy

* BTC address: bc1q8nsv46auuf8zfreznnp4turhd3weegv87kfxlk

* ETH address: 0x544fA9FBfb488894b1bb3071C0CF06d0B13913B3