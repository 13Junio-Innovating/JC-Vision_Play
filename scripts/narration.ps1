Add-Type -AssemblyName System.Speech
$s = New-Object System.Speech.Synthesis.SpeechSynthesizer
$voices = $s.GetInstalledVoices() | ForEach-Object { $_.VoiceInfo }
$ptbrMale = $voices | Where-Object { $_.Culture.Name -eq 'pt-BR' -and $_.Gender -eq [System.Speech.Synthesis.VoiceGender]::Male }
if ($ptbrMale.Count -gt 0) { $s.SelectVoice($ptbrMale[0].Name) }
else {
  $pt = $voices | Where-Object { $_.Culture.Name -like 'pt-*' }
  if ($pt.Count -gt 0) { $s.SelectVoice($pt[0].Name) }
}
$s.SetOutputToWaveFile("videos/narracao.wav")
$s.Rate = -2
$s.Volume = 100
$segments = @()
$listPath = Join-Path "videos" "files.txt"
if (Test-Path $listPath) {
  $lines = Get-Content $listPath | Where-Object { $_.Trim().Length -gt 0 }
  foreach ($l in $lines) {
    $parts = $l.Split('|')
    $speech = if ($parts.Length -ge 4 -and $parts[3].Trim().Length -gt 0) { $parts[3].Trim() } elseif ($parts.Length -ge 3 -and $parts[2].Trim().Length -gt 0) { $parts[2].Trim() } else { [System.IO.Path]::GetFileNameWithoutExtension($parts[0]) }
    $segments += $speech
  }
} else {
  $files = Get-ChildItem "videos" -File | Where-Object { $_.Extension -match '\.(png|jpg|jpeg|webp)$' } | Sort-Object Name
  foreach ($f in $files) { $segments += [System.IO.Path]::GetFileNameWithoutExtension($f.Name) }
}
$pb = New-Object System.Speech.Synthesis.PromptBuilder
foreach ($seg in $segments) {
  $pb.AppendText($seg)
  $pb.AppendBreak([System.Speech.Synthesis.PromptBreak]::Medium)
}
$s.Speak($pb)
$s.Dispose()