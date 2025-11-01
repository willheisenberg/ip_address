# Enhanced Public IP & VPN Info Widget for KDE Plasma 6

## Description

An advanced fork of the original *Public IP Address* widget for KDE Plasma 6.  
This version not only displays your **current public IP** and **geolocation**,  
but also detects **active WireGuard and VPN connections** in real time.

The widget automatically switches between your **local ISP location** and  
the **VPN endpoint location** when a WireGuard tunnel is activated.  
It uses [ipapi.co](https://ipapi.co/) for accurate IPv4/IPv6 geolocation data.

The expanded view includes:
- Detailed information about your connection (city, region, country, ISP)
- Live map showing your current IP location
- Copy-to-clipboard shortcuts for IP, region, and ISP
- Automatic refresh and VPN state monitoring

By default, the widget updates every 5 minutes, but you can change this in the settings.

> **Note:** [ipapi.co](https://ipapi.co/) allows up to 30,000 free requests per month  
> (1,000 per day). Updating more frequently may require an API key.

![tooltip screenshot](screenshots/screenshot_4.png)
![expanded screenshot](screenshots/screenshot_3.png)

---

## Features

- ✅ Detects **WireGuard** interfaces automatically (`wg show all endpoints`)
- ✅ Fallback to current **public exit IP** (works with OpenVPN, Mullvad, etc.)
- ✅ Handles both **IPv4 and IPv6**
- ✅ Shows live **VPN state** (active/inactive)
- ✅ Displays **country flags** using [flag-icon-css](https://github.com/lipis/flag-icon-css)
- ✅ Configurable **update interval** and **label color**
- ✅ Clickable **map view** with external browser support
- ✅ Optional desktop notification on IP change

---

### 🔍 Why this fork exists

Many VPN setups — especially **WireGuard site-to-site tunnels or split-routing configurations** —
do **not** route general Internet traffic through the VPN interface (`AllowedIPs` ≠ `0.0.0.0/0`).
In these cases, tools like `curl --interface wg0` cannot reach external IP lookup services,
because the VPN is only used for internal or peer-to-peer communication.

This widget solves that problem by using:

```bash
wg show all endpoints
```

to directly read the **public endpoint address** of your WireGuard peer.
That address is then queried via [ipapi.co](https://ipapi.co/) to show the **real geolocation**
of the VPN server — even if your internet traffic stays outside the tunnel.

This design ensures:

* accurate VPN geolocation **even with non-routed WireGuard tunnels**
* **no root password needed** (using `setcap` on `wg`)
* seamless switching between **local ISP** and **VPN endpoint** info

---


## Dependencies

| Dependency | Purpose |
|-------------|----------|
| `curl` | Retrieve data from [ipapi.co](https://ipapi.co/) |
| `jq` | Parse JSON responses from ipapi.co |
| `libnotify-bin` | Show desktop notifications |
| `nmcli` | Detect active VPN connections (non-WireGuard) |
| `wireguard-tools` | Read active WireGuard endpoint details |

Example installation (Debian/Ubuntu):

sudo apt install curl jq libnotify-bin network-manager wireguard-tools

---



## Installation (from Git)

This fork can be installed manually from source using `git`.  
The following steps will install and configure the widget for **KDE Plasma 6**.

---

### 1️⃣ Clone the repository

```bash
git clone https://github.com/<YOUR-USERNAME>/plasma-ip-address-enhanced.git
cd plasma-ip-address-enhanced
````

---

### 2️⃣ Install the widget

Use KDE’s Plasma package tool:

```bash
plasmapkg2 -i .
```

If you later update the repository, you can upgrade it with:

```bash
plasmapkg2 -u .
```

---

### 3️⃣ Ensure dependencies are installed

#### Debian / Ubuntu

```bash
sudo apt install curl jq libnotify-bin network-manager wireguard-tools
```

#### Arch / Manjaro

```bash
sudo pacman -S curl jq libnotify networkmanager wireguard-tools
```

These tools are required for fetching IP/geolocation data,
parsing JSON, showing notifications, and detecting VPN status.

---

### 4️⃣ Grant permissions for WireGuard access

By default, the `wg` command requires root privileges to read interface information.
To allow the widget to access this data **without** using `sudo`,
grant the necessary capabilities to the `wg` binary:

```bash
sudo setcap cap_net_admin,cap_net_raw+ep /usr/bin/wg
```

> 💡 If your system uses a custom WireGuard path
> (for example `/usr/local/bin/wg`), replace `/usr/bin/wg` accordingly.

---

### 5️⃣ Make the helper script executable

The widget uses an internal helper script to query your IP and VPN location.
Ensure it has execution permission:

```bash
chmod +x ~/.local/share/plasma/plasmoids/com.github.davide-sd.ip_address/contents/ui/wg-ipapi-json.sh
```

---

### 6️⃣ Restart Plasma Shell

Finally, restart your Plasma environment to reload the widget:

```bash
kquitapp6 plasmashell && kstart6 plasmashell
```

> If you are on Plasma 5, use:
>
> ```bash
> kquitapp5 plasmashell && kstart5 plasmashell
> ```

---

After completing these steps, the **Enhanced Public IP & VPN Info Widget**
will appear in your Plasma widget list under *“Public IP Address Enhanced”*.

Add it to your panel or desktop — it will now display your **current public IP**,
**geolocation**, and automatically switch to **WireGuard endpoint information**
when a VPN connection is active. 🌍🔐



## FAQ

### Where did the map go?

I tested the Plasma 6 version with Kubuntu 24.04 and 25.04. Even when
`libqt6positioning6 libqt6location6 qml6-module-qtlocation qml6-module-qtpositioning`
are installed on the system, the interactive map can't be shown and the logs
showed this error: *"The geoservices provider is not supported"*.

If you have any idea why this happens, let me know!


## How to contribute

Here are the recommended steps to contribute to this widget:

1. fork this repository.
2. download the repository: `git clone https://github.com/<YOUR-USERNAME>/ip_address.git`
3. enter the project directory: `cd ip_address`
4. create a new branch: `git branch -d YOUR-BRANCH-NAME`
5. do the necessary edits and commit them.
6. push the branch to your remote: `git push origin YOUR-BRANCH-NAME`
7. open the Pull Request.

PRs are welcomed. However, each PR should be concise and on point with its intended goal. If a PR claims to implement `feature A` but it also modifies other parts of the code unnecessarely, than it is doing too much and I won't merge it.


**<ins>NOTE about AI-LLM usage</ins>**: I have nothing against the use of these tools. However, many people are unable to properly control their outputs. In practice, these tools often modifies too much. With this in mind:

* If there is a comment in the code, it is very likely to be important to me (the maintainer). Equally important are variable names, function names etc. If the LLM is going to change variable names, remove comments or reorganize the code just for the sake of it, I'll close the PR immediately.
* I prefer that you code manually and understand exactly what you are doing. Remember that at this moment, testing is done manually after each edit, which is time consuming.

