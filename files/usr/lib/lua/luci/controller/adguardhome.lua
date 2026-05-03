module("luci.controller.adguardhome", package.seeall)

function index()
    entry({"admin", "services", "adguardhome"}, template("adguardhome"), _("AdGuard Home"), 80)
    entry({"admin", "services", "adguardhome", "status"}, call("action_status"), nil)
    entry({"admin", "services", "adguardhome", "toggle"}, call("action_toggle"), nil)
end

function action_status()
    local http = require "luci.http"
    local sys = require "luci.sys"

    local running = sys.call("pidof AdGuardHome >/dev/null 2>&1") == 0
    local enabled = sys.call("[ -f /etc/rc.d/S99adguardhome ]") == 0

    http.prepare_content("application/json")
    http.write_json({
        running = running,
        enabled = enabled
    })
end

function action_toggle()
    local http = require "luci.http"
    local sys = require "luci.sys"
    local action = http.formvalue("action")

    if action == "start" then
        sys.call("/etc/init.d/adguardhome start >/dev/null 2>&1")
    elseif action == "stop" then
        sys.call("/etc/init.d/adguardhome stop >/dev/null 2>&1")
        sys.call("killall AdGuardHome >/dev/null 2>&1")
    elseif action == "enable" then
        sys.call("/etc/init.d/adguardhome enable >/dev/null 2>&1")
    elseif action == "disable" then
        sys.call("/etc/init.d/adguardhome disable >/dev/null 2>&1")
    end

    http.prepare_content("application/json")
    http.write_json({ result = "ok" })
end
