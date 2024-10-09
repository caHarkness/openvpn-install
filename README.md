###### openvpn-install

Forked from [openvpn-install](https://github.com/Nyr/openvpn-install), broken apart, and heavily modified to make the individual components easier to understand. Tested and verified to work with Debian 12 only.

---

###### Procedure

1. Run `./install.sh` to install OpenVPN and the system configuration changes

2. Run `./new-client.sh mynewclient` to create a profile

3. Copy `clients/mynewclient.ovpn` and give to a single, trusted device

---

###### Static Client IPs

1. Have `mynewclient.ovpn` connect once

2. Stop OpenVPN via `systemctl stop openvpn`

3. Open `/etc/openvpn/ipp.txt` in nano

4. Modify the file to contain the client and its ip, e.g.

        mynewclient,10.8.0.100

5. Start OpenVPN via `systemctl start openvpn`

6. Have `mynewclient` connect again
