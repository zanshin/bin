#!/bin/bash
# Script to install open_ports.sh
# 2011-05-05 / Peter Mˆller, Datavetenskap, LTH
# Location: 
# http://fileadmin.cs.lth.se/cs/Personal/Peter_Moller/scripts/open_ports_install.sh


# Make sure the user is "root"
if [ ! "$USER" = "root" ] ; then
    echo "Must be run by root!"
      echo "Exiting..."
        exit 1
      fi

      # BINDIR points to the "binary"
      BINDIR="/usr/bin"
      # PREFIX points to where all the datafiles are stored
      PREFIX="/Library/cs.lth.se/OpenPorts"
      # IP_CACHE is a growing list of IP-addresses and their geo location. 
      # Since this is being used by other scripts, it's not in the OpenPorts directory
      IP_CACHE="/Library/cs.lth.se/ip_cache.txt"
      # EXTERN stores the computers "external" address. Checked hourly
      EXTERN="$PREFIX/ExternIP.txt"
      # FILE4 stores current IPv4-ESTABLISHED connections. Generated every two minutes!
      FILE4="$PREFIX/ip4.txt"
      # FILE6 stores current IPv6-ESTABLISHED connections. Generated every two minutes!
      FILE6="$PREFIX/ip6.txt"
      # FILE_LISTEN stores current LISTEN connections. Generated every two minutes!
      FILE_LISTEN="$PREFIX/listen.txt"
      # CHECKSUM stores a sha1-checksum for the lsof-binary. Cheched every two houres
      CHECKSUM="$PREFIX/Checksum.txt"
      # IP_LOCATE_CACHE is a temporary file that stores the geo location of the computers external address
      IP_LOCATE_CACHE="$PREFIX"/ip_locate_cache.txt


      # Fetch and launch the launchd-component
      echo "Fetching launchd-component"
      curl -o /Library/LaunchDaemons/se.lth.cs.open_ports.plist http://fileadmin.cs.lth.se/cs/Personal/Peter_Moller/scripts/se.lth.cs.open_ports.plist
      chmod 644 /Library/LaunchDaemons/se.lth.cs.open_ports.plist
      launchctl load /Library/LaunchDaemons/se.lth.cs.open_ports.plist
      launchctl start se.lth.cs.open_ports
      echo
      echo

      # fetch the script
      echo "Fetching main script"
      ScriptName="open_ports.sh"
      curl -o /tmp/${ScriptName} http://fileadmin.cs.lth.se/cs/Personal/Peter_Moller/scripts/${ScriptName}
      curl -o /tmp/${ScriptName}.sha1 http://fileadmin.cs.lth.se/cs/Personal/Peter_Moller/scripts/${ScriptName}.sha1
      if [ "$(openssl sha1 /tmp/${ScriptName} | awk '{ print $2 }')" = "$(less /tmp/${ScriptName}.sha1)" ]; then
          mv /tmp/${ScriptName} ${BINDIR}/${ScriptName}
            chmod 755 ${BINDIR}/${ScriptName}
          else
              echo "Checksum does NOT match!! Installation aborted!"
                exit 1
              fi
              echo
              echo

              # Create the directory for the files and set the access rights
              mkdir -p "$PREFIX"
              chmod 755 "$PREFIX"
              touch "$FILE4" "$FILE6" "$IP_CACHE" "$IP_LOCATE_CACHE"
              chmod 666 "$FILE4" "$FILE6" "$IP_CACHE" "$IP_LOCATE_CACHE"

              echo "Done installing base parts of \"open_ports.sh\". Now proceeding to install GeekTool"
              echo

              echo "Fetching GeekTool"
              # Get GeekTook
              curl -o /tmp/GeekTool.dmg http://update.tynsoe.org/geektool3/Public/GeekTool%203.0.dmg
              hdiutil mount /tmp/GeekTool.dmg
              open /Volumes/GeekTool\ 3/
              say "Done installing base parts of open ports. Now you will have to install GeekTool yourself"

              exit 0

