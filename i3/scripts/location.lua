T = dofile("/home/maddy/.config/scripts/maddy_tools.lua")

local region = T.Run("curl https://ipapi.co/region_code")
local city = T.Run("curl https://ipapi.co/city")

print(" " .. city .. ", " .. region)
