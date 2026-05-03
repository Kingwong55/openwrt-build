module("luci.controller.adguardhome", package.seeall)
function index()
    entry({"admin", "services", "adguardhome"}, template("adguardhome"), _("AdGuard Home"), 80)
end
