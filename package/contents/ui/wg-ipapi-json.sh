#!/usr/bin/env bash
# liefert Standortdaten des WireGuard-Endpoints (wenn aktiv)
# oder des lokalen ISP (wenn VPN down ist)
# sudo setcap cap_net_admin,cap_net_raw+ep /usr/bin/wg

# Versuche IPv6/IPv4 Endpoint aus aktivem WG-Interface zu holen
ip=$(wg show all endpoints 2>/dev/null | awk '{print $3}' | sed -E 's/^\[?([^]]+)\]?.*/\1/' | head -n1)

# Wenn kein Endpoint gefunden → Fallback auf lokale IP
if [[ -z "$ip" ]]; then
    # kein WireGuard aktiv → lokale IPv4-Adresse verwenden
    curl -4 -fsS --max-time 5 "https://ipapi.co/json" 2>/dev/null |
    jq '{ip:.ip, city:.city, region:.region,
         country:(.country // .country_code),
         country_name:(.country_name // .country),
         postal:.postal,
         loc:( (.latitude|tostring)+","+(.longitude|tostring) ),
         org:.org}'
else
    # Endpoint-IP → Standort des VPN-Servers
    curl -fsS --max-time 5 "https://ipapi.co/${ip}/json" 2>/dev/null |
    jq '{ip:.ip, city:.city, region:.region,
         country:(.country // .country_code),
         country_name:(.country_name // .country),
         postal:.postal,
         loc:( (.latitude|tostring)+","+(.longitude|tostring) ),
         org:.org}'
fi