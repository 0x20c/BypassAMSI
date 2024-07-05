# BypassAMSI

<br/>

作为其他项目的拓展使用(Bypass AV/EDR 等)

<br/>

代码参考来源：

- [AmsiBypass.cs](https://github.com/rasta-mouse/AmsiScanBufferBypass/blob/main/AmsiBypass.cs)
- [OffensiveNim](https://github.com/byt3bl33d3r/OffensiveNim)

<br/>

编译：

```bash
nimble build --verbosity:0 -d=mingw --app=console --cpu=amd64 -d:danger -d:strip --opt:size --passc=-flto --passl=-flto
```
