#!/usr/bin/env python3
import sys

def hex_to_bin(hexstr, outfile, load_addr):
    hexstr = hexstr.replace(" ", "").replace("\n", "")
    if len(hexstr) % 2:
        raise ValueError("odd number of hex chars — transcription error")
    data = bytes.fromhex(hexstr)
    with open(outfile, "wb") as f:
        f.write(data)
    print(f"{outfile}: {len(data)} bytes, load addr {load_addr} (0x{load_addr:04X})")

# Line 9982/9983 -> POKE 65040+n, 24 bytes
routine1 = "F321F8FC01100136F7230B78B120F83EFDED47ED5EFBC9000000"
hex_to_bin(routine1, "routine1_65040.bin", 65040)

# Line 9985/9984 -> POKE 63479+n, 187 bytes
routine2 = ("DDE5F5C5D5E53AB2F83D32B2F8C246F83E3232B2F83AB5F8A7CE0"
            "12732B5F8FE60C246F8AF32B5F83AB4F8A7CE012732B4F8FE60C246F8AF32B4F"
            "83AB3F8A7CE012732B3F8FE13C246F83E0132B3F8DD2118403AB3F8CD79F83E0"
            "ACD8CF83AB4F8CD79F83E0ACD8CF83AB5F8CD79F8211858060836C72310FBE1D"
            "1C1F1DDE1C33800F5CB3FCB3FCB3FCB3FCD8CF8F1E60FCD8CF8C9DDE52A365C1"
            "1800119EB6F260029292919110001060"
            "87EEEFFDD770023DD1910F5DDE1DD23C9")
hex_to_bin(routine2, "routine2_63479.bin", 63479)