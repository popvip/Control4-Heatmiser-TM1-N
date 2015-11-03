HMV2_ID = 2
HMV3_ID = 3
BYTEMASK = 0xff
DONT_CARE_LENGTH = 1
-- Master must be in range [0x81,0xa0] = [129,160]
MASTER_ADDR_MIN = 0x81
MASTER_ADDR_MAX = 0xa0

-- Define magic numbers used in messages
FUNC_READ  = 0
FUNC_WRITE = 1
BROADCAST_ADDR = 0xff

RW_LENGTH_ALL = 0xffff

HOT_WATER_ADDR_VAL = 42

HOT_WATER_ON_VAL = 01
HOT_WATER_AUTO_VAL = 00

MY_MASTER_ADDR = 0x81
  -- ===================================
  --              GLOBALS
  -- ===================================
g_SerialData = ""

local hex2bin = {
  ["0"] = "0000",
  ["1"] = "0001",
  ["2"] = "0010",
  ["3"] = "0011",
  ["4"] = "0100",
  ["5"] = "0101",
  ["6"] = "0110",
  ["7"] = "0111",
  ["8"] = "1000",
  ["9"] = "1001",
  ["a"] = "1010",
        ["b"] = "1011",
        ["c"] = "1100",
        ["d"] = "1101",
        ["e"] = "1110",
        ["f"] = "1111"
  }



local bin2hex = {
  ["0000"] = "0",
  ["0001"] = "1",
  ["0010"] = "2",
  ["0011"] = "3",
  ["0100"] = "4",
  ["0101"] = "5",
  ["0110"] = "6",
  ["0111"] = "7",
  ["1000"] = "8",
  ["1001"] = "9",
  ["1010"] = "A",
        ["1011"] = "B",
        ["1100"] = "C",
        ["1101"] = "D",
        ["1110"] = "E",
        ["1111"] = "F"
  }

--[[
local dec2hex = {
  ["0"] = "0",
  ["1"] = "1",
  ["2"] = "2",
  ["3"] = "3",
  ["4"] = "4",
  ["5"] = "5",
  ["6"] = "6",
  ["7"] = "7",
  ["8"] = "8",
  ["9"] = "9",
  ["10"] = "A",
  ["11"] = "B",
  ["12"] = "C",
  ["13"] = "D",
  ["14"] = "E",
  ["15"] = "F"
  }
--]]


-- These functions are big-endian and take up to 32 bits

-- Hex2Bin
-- Bin2Hex
-- Hex2Dec
-- Dec2Hex
-- Bin2Dec
-- Dec2Bin


function Hex2Bin(s)

-- s  -> hexadecimal string

local ret = ""
local i = 0


  for i in string.gfind(s, ".") do
    i = string.lower(i)

    ret = ret..hex2bin[i]

  end

  return ret
end


function Bin2Hex(s)

-- s  -> binary string

local l = 0
local h = ""
local b = ""
local rem

l = string.len(s)
rem = l % 4
l = l-1
h = ""

  -- need to prepend zeros to eliminate mod 4
  if (rem > 0) then
    s = string.rep("0", 4 - rem)..s
  end

  for i = 1, l, 4 do
    b = string.sub(s, i, i+3)
    h = h..bin2hex[b]
  end

  return h

end


function Bin2Dec(s)

-- s  -> binary string

local num = 0
local ex = string.len(s) - 1
local l = 0

  l = ex + 1
  for i = 1, l do
    b = string.sub(s, i, i)
    if b == "1" then
      num = num + 2^ex
    end
    ex = ex - 1
  end

  return string.format("%u", num)

end



function Dec2Bin(s, num)

-- s  -> Base10 string
-- num  -> string length to extend to

local n

  if (num == nil) then
    n = 0
  else
    n = num
  end

  s = string.format("%x", s)

  s = Hex2Bin(s)

  while string.len(s) < n do
    s = "0"..s
  end

  return s

end




function Hex2Dec(s)

-- s  -> hexadecimal string

local s = Hex2Bin(s)

  return Bin2Dec(s)

end



function Dec2Hex(s)

-- s  -> Base10 string

  s = string.format("%x", s)

  return s

end




-- These functions are big-endian and will extend to 32 bits

-- BMAnd
-- BMNAnd
-- BMOr
-- BMXOr
-- BMNot


function BMAnd(v, m)

-- v  -> hex string to be masked
-- m  -> hex string mask

-- s  -> hex string as masked

-- bv -> binary string of v
-- bm -> binary string mask

local bv = Hex2Bin(v)
local bm = Hex2Bin(m)

local i = 0
local s = ""

  while (string.len(bv) < 32) do
    bv = "0000"..bv
  end

  while (string.len(bm) < 32) do
    bm = "0000"..bm
  end


  for i = 1, 32 do
    cv = string.sub(bv, i, i)
    cm = string.sub(bm, i, i)
    if cv == cm then
      if cv == "1" then
        s = s.."1"
      else
        s = s.."0"
      end
    else
      s = s.."0"

    end
  end

  return Bin2Hex(s)

end


function BMNAnd(v, m)

-- v  -> hex string to be masked
-- m  -> hex string mask

-- s  -> hex string as masked

-- bv -> binary string of v
-- bm -> binary string mask

local bv = Hex2Bin(v)
local bm = Hex2Bin(m)

local i = 0
local s = ""

  while (string.len(bv) < 32) do
    bv = "0000"..bv
  end

  while (string.len(bm) < 32) do
    bm = "0000"..bm
  end


  for i = 1, 32 do
    cv = string.sub(bv, i, i)
    cm = string.sub(bm, i, i)
    if cv == cm then
      if cv == "1" then
        s = s.."0"
      else
        s = s.."1"
      end
    else
      s = s.."1"

    end
  end

  return Bin2Hex(s)

end



function BMOr(v, m)

-- v  -> hex string to be masked
-- m  -> hex string mask

-- s  -> hex string as masked

-- bv -> binary string of v
-- bm -> binary string mask

local bv = Hex2Bin(v)
local bm = Hex2Bin(m)

local i = 0
local s = ""

  while (string.len(bv) < 32) do
    bv = "0000"..bv
  end

  while (string.len(bm) < 32) do
    bm = "0000"..bm
  end


  for i = 1, 32 do
    cv = string.sub(bv, i, i)
    cm = string.sub(bm, i, i)
    if cv == "1" then
        s = s.."1"
    elseif cm == "1" then
        s = s.."1"
    else
      s = s.."0"
    end
  end

  return Bin2Hex(s)

end

function BMXOr(v, m)

-- v  -> hex string to be masked
-- m  -> hex string mask

-- s  -> hex string as masked

-- bv -> binary string of v
-- bm -> binary string mask

local bv = Hex2Bin(v)
local bm = Hex2Bin(m)

local i = 0
local s = ""

  while (string.len(bv) < 32) do
    bv = "0000"..bv
  end

  while (string.len(bm) < 32) do
    bm = "0000"..bm
  end


  for i = 1, 32 do
    cv = string.sub(bv, i, i)
    cm = string.sub(bm, i, i)
    if cv == "1" then
      if cm == "0" then
        s = s.."1"
      else
        s = s.."0"
      end
    elseif cm == "1" then
      if cv == "0" then
        s = s.."1"
      else
        s = s.."0"
      end
    else
      -- cv and cm == "0"
      s = s.."0"
    end
  end

  return Bin2Hex(s)

end


function BMNot(v, m)

-- v  -> hex string to be masked
-- m  -> hex string mask

-- s  -> hex string as masked

-- bv -> binary string of v
-- bm -> binary string mask

local bv = Hex2Bin(v)
local bm = Hex2Bin(m)

local i = 0
local s = ""

  while (string.len(bv) < 32) do
    bv = "0000"..bv
  end

  while (string.len(bm) < 32) do
    bm = "0000"..bm
  end


  for i = 1, 32 do
    cv = string.sub(bv, i, i)
    cm = string.sub(bm, i, i)
    if cm == "1" then
      if cv == "1" then
        -- turn off
        s = s.."0"
      else
        -- turn on
        s = s.."1"
      end
    else
      -- leave untouched
      s = s..cv

    end
  end

  return Bin2Hex(s)

end


-- these functions shift right and left, adding zeros to lost or gained bits
-- returned values are 32 bits long

-- BShRight(v, nb)
-- BShLeft(v, nb)


function BShRight(v, nb)

-- v  -> hexstring value to be shifted
-- nb -> number of bits to shift to the right

-- s  -> binary string of v

local s = Hex2Bin(v)

  while (string.len(s) < 32) do
    s = "0000"..s
  end

  s = string.sub(s, 1, 32 - nb)

  while (string.len(s) < 32) do
    s = "0"..s
  end

  return Bin2Hex(s)

end

function BShLeft(v, nb)

-- v  -> hexstring value to be shifted
-- nb -> number of bits to shift to the right

-- s  -> binary string of v

local s = Hex2Bin(v)

  while (string.len(s) < 32) do
    s = "0000"..s
  end

  s = string.sub(s, nb + 1, 32)

  while (string.len(s) < 32) do
    s = s.."0"
  end

  return Bin2Hex(s)

end

function lsh(value,shift)
    return (value*(2^shift)) % 2^24
end

function rsh(value,shift)
    return math.floor(value/2^shift) % 2^24
end

function bitand(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
      if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
          result = result + bitval      -- set the current bit
      end
      bitval = bitval * 2 -- shift left
      a = math.floor(a/2) -- shift right
      b = math.floor(b/2)
    end
    return result
end

function bitor(x, y)
  local p = 1
  while p < x do p = p + p end
  while p < y do p = p + p end
  local z = 0
  repeat
    if p <= x or p <= y then
      z = z + p
      if p <= x then x = x - p end
      if p <= y then y = y - p end
    end
    p = p * 0.5
  until p < 1
  return z
end

function xor(a,b)
  local r = 0
  local f = math.floor
  for i = 0, 31 do
    local x = a / 2 + b / 2
    if x ~= f(x) then
      r = r + 2^i
    end
    a = f(a / 2)
    b = f(b / 2)
  end
  return r
end

function DEC_HEX(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end

function hex_dump (str)
    local len = string.len( str )
    local dump = ""
    local hex = ""
    local asc = ""
    
    for i = 1, len do
        if 1 == i % 8 then
            dump = dump .. hex .. asc .. "\n"
            hex = string.format( "%04x: ", i - 1 )
            asc = ""
        end
        
        local ord = string.byte( str, i )
        hex = hex .. string.format( "%02x ", ord )
        if ord >= 32 and ord <= 126 then
            asc = asc .. string.char( ord )
        else
            asc = asc .. "."
        end
    end

    
    return dump .. hex
            .. string.rep( "   ", 8 - len % 8 ) .. asc
end

crc16 = {}
crc16.__index = crc16

function crc16.new(LookupHigh,LookupLow,High,Low)
  local o = {}
  o.LookupHigh = { 0x00, 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 0x81, 0x91, 0xa1, 0xb1, 0xc1, 0xd1, 0xe1, 0xf1 }
  o.LookupLow = { 0x00, 0x21, 0x42, 0x63, 0x84, 0xa5, 0xc6, 0xe7, 0x08, 0x29, 0x4a, 0x6b, 0x8c, 0xad, 0xce, 0xef }
  o.High = 0xff
  o.Low = BYTEMASK
  setmetatable(o,crc16)
  return o
end

function crc16:Update4Bits(val)
  --Step one, extract the Most significant 4 bits of the CRC register
  --print(self.High)
  t = rsh(self.High,4)
  --print("t is: " .. t)
  
  --XOR in the Message Data into the extracted bits
  t = xor(t,val)  
  --print("t is now: " .. t)
  
  --Shift the CRC Register left 4 bits
  self.High = bitor(lsh(self.High,4),rsh(self.Low,4))
  --print(self.High)
  self.High = bitand(self.High,BYTEMASK)
  --print(self.High)
  self.Low = lsh(self.Low,4)
  --print(self.Low)
  self.Low = bitand(self.Low,BYTEMASK)
  --print(self.Low)

  --print("Low",self.Low)
  --print("High",self.High)

  --Do the table lookups and XOR the results into the CRC tables
  self.High = xor(self.High,self.LookupHigh[t+1])
  --print(self.High)
  self.High = bitand(self.High,BYTEMASK)
  --print (self.High)
  self.Low = xor(self.Low,self.LookupLow[t+1])
  --print(self.Low)
  self.Low = bitand(self.Low,BYTEMASK)
  --print(self.Low)
  
  --print("FLow:",self.Low)
  --print("FHigh:",self.High)


end

function crc16:CRC16_Update(val)
  --print("Value:",val)
  self:Update4Bits(rsh(val,4))
  self:Update4Bits(bitand(val,0x0f))
end

function crc16:run(message)
  -- Calculates a crc
  --print "Fuck off"
  print(message)
  --print(string.len(message))  
  for k,value in ipairs(message) do
    --print(v)
    self:CRC16_Update(value)
    --print(self.Low)
   -- print(self.High)
  end
  table.insert(msg,self.Low)
  table.insert(msg,self.High)
  return msg
end

-- Testing the functionality below:
--crc = crc16.new()
--andy = crc:run(1212121121212)
--print(andy[1],andy[2])

crc = crc16.new()


function hmFormMsg(destination,source,functioncall,start,payload)
  --print("hmFormMsg:            ",destination,source,functioncall,start,payload)
  start_low = bitand(start,BYTEMASK)
  start_high = bitand(rsh(start,8),BYTEMASK)
  payloadstring = tostring(payload)
  payloadLength = #payloadstring
  last_low = bitand(payloadLength,BYTEMASK)
  last_high = bitand(rsh(payloadLength,8),BYTEMASK)
  --print(destination,source,functioncall,start,payload)
  if functioncall == FUNC_READ then 
    print("Read")
    payloadLength = 0x00
    length_low = BMAnd(RW_LENGTH_ALL,BYTEMASK)
    length_high = BMAnd(rsh(RW_LENGTH_ALL,8),BYTEMASK)
    msg = {destination,10+payloadLength, source, functioncall, start_low, start_high, length_low, length_high}
    return msg
  end
  if functioncall == FUNC_WRITE then
    msg = {destination, 10+payloadLength, source, functioncall, start_low, start_high, last_low, last_high}
    table.insert(msg,payload)
    --print("destination:\t",msg[1],"\npayload:\t",msg[2],"\nsource:\t\t",msg[3],"\nfunction\t",msg[4],"\nsl\t\t",msg[5],"\nsh\t\t",msg[6],"\nfl\t\t",msg[7],"\nfh\t\t",msg[8])
    return msg
  end

end

function hmFormMsgCRC(destination, source, functioncall, start, payload)
  --Forms a message payload, including CRC"""
  --print("hmFormMsgCRC:         ", destination,source, functioncall, start, payload)
  data = hmFormMsg(destination, source, functioncall, start, payload)
  --print("Payload data: ", data)
  newdata = crc:run(data)
  --crc:run(data)
  return data
end

function hmVerifyMsgCRCOK(source, expectedFunction, expectedLength, datal)
  --print(datal)
  --expectedchecksum = crc:run(rxmsg)
  if expectedchecksum == checksum then
    print("CRC is correct")
  else
    print("Incorrect CRC")
  end
end

function hmSendMsg(message)
  --print(message)
  data2 = {}
  for k,v in ipairs(message) do
    --ord = string.byte(v,k)
    --hex = hex .. string.format( "%02x ", ord )

    -- Need to insert the value as a hex value ( think)
    v = string.char(v)
    table.insert(data2,v)
    --print(DEC_HEX(v))
  end
  --print("Final",table.concat(data2))
  --print("hex:",hex_dump(table.concat(data2)))
  C4:SendToSerial(1, data2)
  --byteread = ReceivedFromSerial(1, strData)
  return 1
end

function hotWaterSwitch(destination,payload)
  --print("hotWaterSwitch: ",destination,MY_MASTER_ADDR,FUNC_WRITE,HOT_WATER_ADDR_VAL,payload)
  msg = hmFormMsgCRC(destination,MY_MASTER_ADDR,FUNC_WRITE,HOT_WATER_ADDR_VAL,payload)
  if hmSendMsg(msg) == 1 then
    C4:UpdateProperty('State', 'On')
  else
    print("Error updating hot water status")
  end
end

function OnPropertyChanged(strProperty)
  if (strProperty == 'State') then
    if (Properties[strProperty]=='SwitchOn') then
      print("Turning Hot Water On")
      hotWaterSwitch(Properties['ThermostatID'],HOT_WATER_ON_VAL)
    elseif (Properties[strProperty]=='SwitchOff') then
      print("Turning Hot Water to Auto")
      hotWaterSwitch(Properties['ThermostatID'],HOT_WATER_OFF_VAL)
    end
  else
    print("Status is: ",Propertises['State'],".  Contact andy")
  end
end

--function LUA_ACTION.hotWaterOnPlease()
--  print("Hot water turning on")
--  hotWaterSwitch(Properties['Thermostat ID'],HOT_WATER_ON_VAL)
--end

--function LUA_ACTION.hotWaterTimedPlease()
--  print("Hot water timed mode")
--  hotWaterSwitch(Properties['Thermostat ID'],HOT_WATER_AUTO_VAL)
--end

--print(hotWaterSwitch(5,HOT_WATER_ON_VAL))
  