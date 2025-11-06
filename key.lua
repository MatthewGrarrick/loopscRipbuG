-- 🔑 LOOPSC HUB - Key System 24h (Auto Expire)
-- Cấu trúc: mỗi dòng 1 key|timestamp_hết_hạn

local keys = [[
LOOPSC-20251106-445204|1762493857
]]

local now = os.time()
local validKeys = {}

for line in keys:gmatch("[^\r\n]+") do
    local key, expiry = line:match("(.+)|(%d+)")
    if key and expiry then
        if now <= tonumber(expiry) then
            table.insert(validKeys, key)
        end
    end
end

return validKeys
