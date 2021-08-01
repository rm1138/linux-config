 #!/bin/sh

(swaymsg -t get_tree | jq -r '..|try select(.focused == true)' | jq 'select(.name|test("Firefox"))' -e && swaymsg '[con_mark="last_focus"] focus') || \
(swaymsg -q 'mark --replace last_focus'; (swaymsg '[class="firefoxdeveloperedition"] focus' || firefox-developer-edition))



