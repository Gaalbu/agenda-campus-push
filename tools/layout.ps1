# Organiza as janelas para a gravação: Firefox (Console) à esquerda, emulador à direita; minimiza o resto.
# Uso: powershell -ExecutionPolicy Bypass -File tools\layout.ps1 [-Restore]
param([switch]$Restore)
Add-Type @"
using System; using System.Runtime.InteropServices;
public class Win {
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr a, int x, int y, int w, int hh, uint f);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  public struct RECT { public int L, T, R, B; }
}
"@
[Win]::SetProcessDPIAware() | Out-Null
function Find($name, $title) { Get-Process $name -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -like $title } | Select-Object -First 1 }

if ($Restore) {
  $NOTOP = [IntPtr](-2)
  foreach ($n in 'firefox', 'qemu-system-x86_64') { foreach ($p in (Get-Process $n -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 })) { [Win]::SetWindowPos($p.MainWindowHandle, $NOTOP, 0, 0, 0, 0, 0x0003) | Out-Null } }
  foreach ($p in (Get-Process claude -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 })) { [Win]::ShowWindow($p.MainWindowHandle, 9) | Out-Null }
  return
}
foreach ($p in (Get-Process claude, powershell, SystemSettings, ApplicationFrameHost -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 })) { [Win]::ShowWindow($p.MainWindowHandle, 6) | Out-Null }
$ff = Find 'firefox' '*Console do Firebase*'
if (-not $ff) { $ff = Find 'firefox' '*Firebase*' }
# Outras janelas do Firefox (ex.: Git Credential Manager) ficam minimizadas para não aparecerem no vídeo.
foreach ($p in (Get-Process firefox -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 -and (-not $ff -or $_.Id -ne $ff.Id) })) { [Win]::ShowWindow($p.MainWindowHandle, 6) | Out-Null }
# HWND_TOPMOST (-1): fica acima de janelas elevadas (ex.: PowerShell do administrador) que não podem ser minimizadas daqui.
$TOP = [IntPtr](-1)
if ($ff) { [Win]::ShowWindow($ff.MainWindowHandle, 9) | Out-Null; [Win]::SetWindowPos($ff.MainWindowHandle, $TOP, 0, 0, 1180, 1040, 0x0040) | Out-Null }
$em = Find 'qemu-system-x86_64' '*Android Emulator*'
if ($em) {
  [Win]::ShowWindow($em.MainWindowHandle, 9) | Out-Null
  $r = New-Object Win+RECT; [Win]::GetWindowRect($em.MainWindowHandle, [ref]$r) | Out-Null
  [Win]::SetWindowPos($em.MainWindowHandle, $TOP, 1230, 0, ($r.R - $r.L), ($r.B - $r.T), 0x0040) | Out-Null
  [Win]::GetWindowRect($em.MainWindowHandle, [ref]$r) | Out-Null
  "emulador: $($r.L),$($r.T) -> $($r.R),$($r.B)"
}
"firefox: " + [bool]$ff
