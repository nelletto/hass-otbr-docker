# Home Assistant: Docker OpenThread Border Router

Stand-alone Home Assistant OpenThread Border Router docker container. For containerized home
assistance setup without Yellow or HassOS.

This is a docker container based on the Home Assistant OpenThread Border Router add-on
(https://github.com/home-assistant/addons/tree/master/openthread_border_router) to get the patches
and quirks that the hass team has made. It is the same without the bashio stuff that communicates
with home assistance instance in some way. Just to make the container work stand-alone.

Tested with [Sonoff Dongle Max]([https://www.home-assistant.io/connectzbt1/](https://sonoff.tech/it-it/products/sonoff-dongle-max-zigbee-thread-poe-dongle-dongle-m)) with Thread RCP firmware. I use it personally every day with various Thread devices and have not noticed any malfunctions of any kind.


Disclaimer: I am completely new to IPv6 and Thread so I don't fully know what I am doing here. Just
read documentation and forum threads and eventually got it working using this setup.

## Prerequisite

1. Enable ipv6 support on local network.
2. Also enable mDNS and IGMP snooping on the Default network.
3. Configured the docker host with the following sysctl:

    ```
    net.ipv6.conf.all.disable_ipv6 = 0
    net.ipv4.conf.all.forwarding = 1
    net.ipv6.conf.all.forwarding = 1
    net.ipv6.conf.all.accept_ra_rt_info_max_plen = 64
    net.ipv6.conf.all.accept_ra = 2
    ```

## Setup

1. Start this `ghcr.io/nelletto/hass-otbr-docker` container, see the docker-compose file and modify the environment variables
   according to you environment. The env variables are mapped from the addon config to these env
   variables:

    | ENV VARIABLE       | Description                                            |
    |--------------------|--------------------------------------------------------|
    | DEVICE             | Serial port where the OpenThread RCP Radio is attached. Set to `/tmp/ttyOTBR` if using network-based RCP |
    | BAUDRATE           | Serial port baudrate (depends on firmware)   |
    | FLOW_CONTROL (1 or 0) | If hardware flow control should be enabled (depends on firmware) |
    | AUTOFLASH_FIRMWARE (1 or 0) | Automatically install/update firmware (Home Assistant SkyConnect/Yellow) |
    | OTBR_LOG_LEVEL     | Set the log level of the OpenThread BorderRouter Agent (debug,info,notice,warning,error,critical,alert,emergency)    |
    | OTBR_REST_PORT     | Port for REST API used by home assistant |
    | OTBR_WEB_PORT      | Port for WEB UI |
    | OTBR_WEB_INTERFACE | *empty* | (Optional) Interface to listen on (e.g. `eth0` or `127.0.0.1`). Default is all interfaces. |
    | OTBR_WEB (1 or 0)  | Enable or disable WEB UI |
    | FIREWALL (1 or 0)  | Enable OpenThread Border Router firewall to block unnecessary traffic |
    | NAT64 (1 or 0)     | Enable NAT64 to allow Thread devices accessing IPv4 addresses |
    | NETWORK_DEVICE     | IP address and port to connect to a network-based RCP (NOT RACCOMANDED) |
    | BACKBONE_IF        | Host network interface to use (e.g. eth0, wlan0, enp3s0) |
    | BETA               | Define (e.g. set to '1') to enable OpenThread beta |

2. Install the `Open Thread Border Router`, `Thread`, and `Matter` integrations in your Home Assistant instance.

3. Integrations -> Open Thread Border Router, and add your border router container that you just
   started. I used "http://<HOST_IP>:8081".

4. Go to Integrations -> Thread -> Configure and add the OTBR network, it should pop-up after the
   last step. Click "Make as preferred", "Reset Border router" and Enable Android/IOS commissioning.

5. You might have to go to https://<YOUR_HASS_URL>`/config/matter/dashboard` and "SET THREAD
   CREDENTIALS" to the dataset found with clicking the "i" in your Thread integration.

5. On you Android Phone, go to Settings -> App -> Troubleshooting and click on Sync Thread Auth.

6. Pair a Thread device by scanning the Matter QR-Code with Integrations -> Add Matter device -> New device.

7. The Android based commissioning/pairing took roughly 2-3 minutes but succeeded eventually.

Also see the following documentation for further information:

* https://openthread.io/guides/border-router/docker
* https://github.com/home-assistant/addons/tree/master/openthread_border_router
* https://www.home-assistant.io/integrations/matter
* https://www.home-assistant.io/integrations/thread


# Buy Ownbee a coffee

This project is based on the [work](https://github.com/ownbee/hass-otbr-docker/) done by Ownbee; I simply keep it aligned with the official Home Assistant repository in my free time. Buy him a [ko-fi.com/ownbee](https://ko-fi.com/ownbee) if you like.
