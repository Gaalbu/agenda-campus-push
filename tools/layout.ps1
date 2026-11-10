# Organiza as janelas para a gravação: Firefox (Console) à esquerda, emulador à direita; minimiza o resto.
# Janelas são localizadas pelo TÍTULO (o Firefox tem várias janelas no mesmo processo).
# Uso: powershell -ExecutionPolicy Bypass -File tools\layout.ps1 [-Restore]
param([switch]$Restore)
Add-Type @"
using System; using System.Collections.Generic; using System.Runtime.InteropServices; using System.Text;
public class Win {
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc p, IntPtr l);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll")] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr a, int x, int y, int w, int hh, uint f);
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
  public struct RECT { public int L, T, R, B; }
  public static List<KeyValuePair<IntPtr,string>> All() {
    var l = new List<KeyValuePair<IntPtr,string>>();
    EnumWindows((h, p) => { if (IsWindowVisible(h)) { var sb = new StringBuilder(200); GetWindowText(h, sb, 200); if (sb.Length > 0) l.Add(new KeyValuePair<IntPtr,string>(h, sb.ToString())); } return true; }, IntPtr.Zero);
    return l;
  }
}
"@
[Win]::SetProcessDPIAware() | Out-Null
$wins = [Win]::All()
function Match($pattern) { $wins | Where-Object { $_.Value -match $pattern } }
$TOP = [IntPtr](-1); $NOTOP = [IntPtr](-2)

if ($Restore) {
  foreach ($w in (Match 'Console do Firebase|Android Emulator')) { [Win]::SetWindowPos($w.Key, $NOTOP, 0, 0, 0, 0, 0x0003) | Out-Null }
  foreach ($w in (Match '^Claude$')) { [Win]::ShowWindow($w.Key, 9) | Out-Null }
  return
}
# "Mostrar área de trabalho" via shell: minimiza inclusive janelas elevadas (PowerShell do administrador),
# que um processo sem elevação não consegue minimizar diretamente.
(New-Object -ComObject Shell.Application).MinimizeAll()
Start-Sleep -Milliseconds 1200
# Minimiza o que poderia aparecer no vídeo (janelas elevadas, como o PowerShell do administrador, não aceitam).
foreach ($w in (Match '^Claude$|Windows PowerShell|^Configurações$|Git Credential Manager')) { [Win]::ShowWindow($w.Key, 6) | Out-Null }

$ff = Match 'Console do Firebase' | Select-Object -First 1
if ($ff) { [Win]::ShowWindow($ff.Key, 9) | Out-Null; [Win]::SetWindowPos($ff.Key, $TOP, 0, 0, 1180, 1040, 0x0040) | Out-Null }
$em = Match '^Android Emulator' | Select-Object -First 1
if ($em) {
  [Win]::ShowWindow($em.Key, 9) | Out-Null
  $r = New-Object Win+RECT; [Win]::GetWindowRect($em.Key, [ref]$r) | Out-Null
  [Win]::SetWindowPos($em.Key, $TOP, 1230, 0, ($r.R - $r.L), ($r.B - $r.T), 0x0040) | Out-Null
  [Win]::GetWindowRect($em.Key, [ref]$r) | Out-Null
  "emulador: $($r.L),$($r.T) -> $($r.R),$($r.B)"
}
"firefox: " + [bool]$ff
