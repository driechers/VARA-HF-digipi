# VARA-HF-digipi
This is my crude attempt at documenting what I did to get VARA HF working in a raspberry pi using KM6LYW digipi as my starting platform. This is all sortof hacked together and not particularly polished. It would be very nice to have this all as a reproducible built image such as buildroot but it is not.
Ultimately I wanted to use VARA HF because there are more nodes available than there are for ARDOP and its my understanding that VARA HF is less susceptible to noise. I have no intention of purchasing a license for this junk software. I intent to use it as a way to send messages to non hams when there is no power or cell and I don't need to send short text messages faster. I just need a robust protocol to access networks over the horizon.

## Hardware
 - HF station with Xiegu G90 + CE-19 breakout
 - Raspberry Pi 5
 - [Digipi Hat](https://elekitsorparts.com/product/new-digipi-hat-ham-radio-digi-modes-aprs-ft8-ft4-winlink-from-raspberry-pi-km6lyw-digipi-image/)
 - [Buck Converter](https://www.amazon.com/dp/B0CRVW7N2J?ref=ppx_yo2ov_dt_b_fed_asin_title&th=1)

Construction of the cables and digpi was fairly straight forward. The main challenge I had is that my radio was not responding to line audio. Ultimately this ended up being an issue with the radio itself and I lucked out in that I caught it the very last month of my warranty. The other issue I ran into was brown outs when using various USB-C chargers from around the house. Ultimately I got a 5A buck converter that did the trick and allows me to run from battery power.
## Digipi Setup
This was quite straight forward as well. I followed KM6LYW's instructions on https://digipi.org/ for the most part. I used digipi 1.9-1 sd card image and resized the rootfs to the full card size.
## Configuration
### fstab
VARA HF and Varanny need the rootfs to be rw so I updated fstab to mount rw by default. Additionally the automated installer for varahf in wine downloads files to /tmp. The default tmpfs in digip is quite small so I slightly increased the tmpfs size to fix installation issues. I never did reduce it back down but I'm sure I could to reclaim some RAM.
### ALSA
By default ALSA was configured replay everything it heard on the mic which causes a lot of issues with digital modes of course. The fix is simple. Simply run `alsamixer` and in Playback devices go to the Mic and hit m on the keyboard. It's rather unintuitive but the Mic is in Playback and Capture devices and we only care about it as a Capture device. Once I had the Mic muted and the levels roughly where I wanted them I ran `sudo alsactl store`
## VARA HF install
KI7POL has created an automated installer to get around all the WINE setup bs that is never fun. https://github.com/WheezyE/Winelink. I love the name of it BTW. It will setup winlink express and varafm, I started down this route but was running into some complications with 64bit vs 32bit software so I abandoned installing all of it and just installed what I needed. I followed the instructions he had to install varahf via pi-apps and it worked perfectly the first time.
## Varanny
I wanted to use RadioMail on my IOS device to send and receive emails through my digipi. Vara sofware, being terrible in more ways than one makes this difficult. Thankfully the people who created RadioMail made a free and open source service to baby sit this junk software. I won't go into the details, there is a gorgeous ASCII art diagram on their github that makes it perfectly clear.
 
https://github.com/islandmagic/varanny

To install I simply cloned and built it with go following the instruction in their project. This part was probably the least painful.
## Scripting
I wanted to use this for my communication setup when there is no power or cell network. Automation specific to simplifying this was the point. There is certainly some cleanup here. I copied scripts from KM6LYW and modified them only slightly and I guarantee it will conflict with WSJTX, scripts, and the other systemd services will not stop varrany, but I didn't particularly care for my specific customization.

All of my scripts are in this repo. varanny.sh launches varanny and starts a vnc session X display in which to run VARA HF. This can be nice to debug the setup and view the application as it runs. digibuttons.py is just a modified version of the original script to launch varanny instead of whatever the default service was.
## Mini Rant
Ham radio is awesome. As amateur radio operators we have a space in the airwaves to tinker and play. These frequencies are granted for a reason: emergency communication and innovation. In modern times, emergency communication is a much harder sell. Innovation is far more important to demonstrate to the powers that be. We must remain relevant if we wish to keep our bands. Innovation is a lot harder with anti collaborative practices such as closed source software. I struggle to think of a single good reason to make free, or nearly free software for a niche market and have it closed source. All amateur radio software should be open source so we can all collaborate freely. This stuff cant be a major money maker. Sell your open source hardware as a kit, sell bundles of open source software for the convenience, have a donate button, etc. Let's be honest here. The only good way to make a small fortune in ham radio is to start with a big one.
