-- ARCFOUR implementation in pure Lua
-- Copyright 2008 Rob Kendrick <rjek@rjek.com>
-- Distributed under the MIT licence

-- To create a new context;
--  rc4_context = arcfour.new(optional_key_string)
--
-- To schedule a key
--  rc4_context:schedule(key_string)
--
-- To generate a string of bytes of "random" data from the generator
--  bytes = rc4_context:generate(number_of_bytes)
--
-- To encrypt/decrypt a string
--  ciphertext = rc4_context:cipher(plaintext)
--
-- Example usage;
--  enc_state = arcfour.new "My Encryption Key"
--  enc_state:generate(3072)
--  ciphertext = enc_state:cipher "Hello, world!"
--
--  dec_state = arcfour.new "My Encryption Key"
--  dec_state:generate(3072)
--  plaintext = dec_state:cipher(ciphertext)
--
-- Best practise says to discard the first 3072 bytes from the generated
-- stream to avoid leaking information about the key.  Additionally, if using
-- a nonce, you should hash your key and nonce together, rather than
-- concatenating them.

-- Given a binary boolean function b(x,y) defined by a table
-- of four bits { b(0,0), b(0,1), b(1,0), b(1,1) },
-- return a 2D lookup table f[][] where f[x][y] is b() applied
-- bitwise to the lower eight bits of x and y.

local arcfour = {}

local function make_byte_table(bits)
  local f = { }
  for i = 0, 255 do
    f[i] = { }
  end
  
  f[0][0] = bits[1] * 255

  local m = 1
  
  for k = 0, 7 do
    for i = 0, m - 1 do
      for j = 0, m - 1 do
        local fij = f[i][j] - bits[1] * m
        f[i  ][j+m] = fij + bits[2] * m
        f[i+m][j  ] = fij + bits[3] * m
        f[i+m][j+m] = fij + bits[4] * m
      end
    end
    m = m * 2
  end
  
  return f
end

local byte_xor = make_byte_table { 0, 1, 1, 0 }

local function generate(self, count)
  local S, i, j = self.S, self.i, self.j
  local o = { }
  local char = string.char
  
  for z = 1, count do
    i = (i + 1) % 256
    j = (j + S[i]) % 256
    S[i], S[j] = S[j], S[i]
    o[z] = char(S[(S[i] + S[j]) % 256])
  end
  
  self.i, self.j = i, j
  return table.concat(o)
end

local function cipher(self, plaintext)
  local pad = generate(self, #plaintext)
  local r = { }
  local byte = string.byte
  local char = string.char
  
  for i = 1, #plaintext do
    r[i] = char(byte_xor[byte(plaintext, i)][byte(pad, i)])
  end
  
  return table.concat(r)
end

local function schedule(self, key)
  local S = self.S
  local j, kz = 0, #key
  local byte = string.byte
  
  for i = 0, 255 do
    j = (j + S[i] + byte(key, (i % kz) + 1)) % 256;
    S[i], S[j] = S[j], S[i]
  end
end

function arcfour.new(key)
  local S = { }
  local r = {
    S = S, i = 0, j = 0,
    generate = generate,
    cipher = cipher,
    schedule = schedule 
  }
  
  for i = 0, 255 do
    S[i] = i
  end
  
  if key then
    r:schedule(key)
  end
  
  return r  
end

return arcfour