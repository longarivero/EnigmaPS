# Enimga I simulator with user interface


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Generate rotor index array
$rotors = @('I','II','III','IV','V')
$alphabet = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
# Generate rotor wiring arrays for Enigma I (rotors 1..3) and M3 Army (rotors 4..5)  
$rot1out = @('E','K','M','F','L','G','D','Q','V','Z','N','T','O','W','Y','H','X','U','S','P','A','I','B','R','C','J')
$rot2out = @('A','J','D','K','S','I','R','U','X','B','L','H','W','T','M','C','Q','G','Z','N','P','Y','F','V','O','E')
$rot3out = @('B','D','F','H','J','L','C','P','R','T','X','V','Z','N','Y','E','I','W','G','A','K','M','U','S','Q','O')
$rot4out = @('E','S','O','V','P','Z','J','A','Y','Q','U','I','R','H','X','L','N','F','T','G','K','D','C','M','W','B')
$rot5out = @('V','Z','B','R','G','I','T','Y','U','P','S','D','N','H','L','X','A','W','M','J','Q','O','F','E','C','K')
# Generate reflector wiring arrays for Enigma I (reflectors B and C) 
$refBout = @('Y','R','U','H','Q','S','L','D','P','X','N','G','O','K','M','I','E','B','F','Z','C','W','V','J','A','T')		
$refCout = @('F','V','P','J','I','A','O','Y','E','D','R','Z','X','W','G','C','T','K','U','Q','S','B','N','M','H','L')
# Generate notch positions array (position in array corresponds to rotor number)
$notchPs = @('Q','E','V','J','Z')
# Notch letter indices for the corresponding rotor
$global:RRnot = [char]($notchPs[$global:RRn-1]) - 65  
$global:MRnot = [char]($notchPs[$global:MRn-1]) - 65
# Generate A..Z for the rotor entry array 
$Lin = @()     
65..90| ForEach-Object { $Lin += [char]$_ }
# Generate 01..26 ring position array
$ringposn = @()
1..26 | ForEach-Object { $ringposn += $_.ToString("00") }
$global:PBpairsSet = @()
# Rotor selecton defaults (3=III)
$global:RRn = 1   # Right rotor number
$global:MRn = 2   # Middle rotor number
$global:LRn = 3   # Left rotor number
# Ring settings defaults (1=A)
$global:RRr = 1   # Right rotor ring position
$global:MRr = 1   # Middle rotor ring position
$global:LRr = 1   # Left rotor ring position
# Rotor position defaults (0=A)
$global:LRof = 0  # Right rotor starting position
$global:MRof = 0  # Middle rotor starting position
$global:RRof = 0  # Left rotor starting position
# Reflector type default
$rd = "B"

function IsAlpha ($Value) {
    return $Value -match "^[A-Z]+$"
}

function IsAlphaS ($Value) {
    return $Value -match "^[A-Z ]+$"
}


# Create form object
$form = New-Object System.Windows.Forms.Form
$form.Text = ' Enigma I Simulator '
$form.Size = New-Object System.Drawing.Size(750,610)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedSingle' # Prevents form resizing
$form.MaximizeBox = $false;
$rslx = 40     # Rotor system location, x-axis
$rsly = 20     # Rotor system location, y-axis
$pblx = 40     # Plugboard location, x-axis
$pbly = 175    # Plugboard location, y-axis

# RIGHT ROTOR ##################################################################

$P1L1  = New-Object system.Windows.Forms.ComboBox
$P1L1.width = 80
$P1L1.height = 20
$P1L1.DropDownStyle = 'DropDownList'
$rotors | ForEach-Object {[void] $P1L1.Items.Add("   $_")}
$P1L1.text = $P1L1.Items[($global:RRn-1)]
$P1L1.location = New-Object System.Drawing.Point(20,30)
$P1L1.Font = 'Lucida Sans,11'

$P1L2  = New-Object system.Windows.Forms.ComboBox
$P1L2.width = 80
$P1L2.height = 20
$P1L2.DropDownStyle = 'DropDownList'
$ringposn | ForEach-Object {[void] $P1L2.Items.Add("   $_")}
$P1L2.text = $P1L2.Items[($global:RRr-1)]
$P1L2.location = New-Object System.Drawing.Point(20,65)
$P1L2.Font = 'Lucida Sans,11'

$P1L3  = New-Object system.Windows.Forms.ComboBox
$P1L3.width = 80
$P1L3.height = 20
$P1L3.DropDownStyle = 'DropDownList'
$alphabet | ForEach-Object {[void] $P1L3.Items.Add("   $_")}
$P1L3.text = $P1L3.Items[$global:RRof]
$P1L3.location = New-Object System.Drawing.Point(20,100)
$P1L3.Font = 'Lucida Sans,11'

$P1 = New-Object system.Windows.Forms.Groupbox
$P1.height = 140
$P1.width = 120
$P1.text = "  Right rotor"
$P1.location = New-Object System.Drawing.Point(($rslx+400),$rsly)
$P1.controls.AddRange(@($P1L1, $P1L2, $P1L3))

# MIDDLE ROTOR #################################################################

$P2L1  = New-Object system.Windows.Forms.ComboBox
$P2L1.width = 80
$P2L1.height = 20
$P2L1.DropDownStyle = 'DropDownList'
$rotors | ForEach-Object {[void] $P2L1.Items.Add("   $_")}
$P2L1.text = $P2L1.Items[($global:MRn-1)]
$P2L1.location = New-Object System.Drawing.Point(20,30)
$P2L1.Font = 'Lucida Sans,11'

$P2L2  = New-Object system.Windows.Forms.ComboBox
$P2L2.width = 80
$P2L2.height = 20
$P2L2.DropDownStyle = 'DropDownList'
$ringposn | ForEach-Object {[void] $P2L2.Items.Add("   $_")}
$P2L2.text = $P2L2.Items[($global:MRr-1)]
$P2L2.location = New-Object System.Drawing.Point(20,65)
$P2L2.Font = 'Lucida Sans,11'

$P2L3  = New-Object system.Windows.Forms.ComboBox
$P2L3.width = 80
$P2L3.height = 20
$P2L3.DropDownStyle = 'DropDownList'
$alphabet | ForEach-Object {[void] $P2L3.Items.Add("   $_")}
$P2L3.text = $P2L3.Items[$global:MRof]
$P2L3.location = New-Object System.Drawing.Point(20,100)
$P2L3.Font = 'Lucida Sans,11'

$P2 = New-Object system.Windows.Forms.Groupbox
$P2.height = 140
$P2.width = 120
$P2.text  = " Middle rotor"
$P2.location = New-Object System.Drawing.Point(($rslx+265),$rsly)
$P2.controls.AddRange(@($P2L1, $P2L2, $P2L3))

# LEFT ROTOR ###################################################################

$P3L1  = New-Object system.Windows.Forms.ComboBox
$P3L1.width = 80
$P3L1.height = 20
$P3L1.DropDownStyle = 'DropDownList'
$rotors | ForEach-Object {[void] $P3L1.Items.Add("   $_")}
$P3L1.text = $P3L1.Items[($global:LRn-1)]
$P3L1.location = New-Object System.Drawing.Point(20,30)
$P3L1.Font = 'Lucida Sans,11'

$P3L2  = New-Object system.Windows.Forms.ComboBox
$P3L2.width = 80
$P3L2.height = 20
$P3L2.DropDownStyle = 'DropDownList'
$ringposn | ForEach-Object {[void] $P3L2.Items.Add("   $_")}
$P3L2.text = $P3L2.Items[($global:LRr-1)]
$P3L2.location = New-Object System.Drawing.Point(20,65)
$P3L2.Font = 'Lucida Sans,11'

$P3L3  = New-Object system.Windows.Forms.ComboBox
$P3L3.width = 80
$P3L3.height = 20
$P3L3.DropDownStyle = 'DropDownList'
$alphabet | ForEach-Object {[void] $P3L3.Items.Add("   $_")}
$P3L3.text = $P3L3.Items[$global:LRof]
$P3L3.location = New-Object System.Drawing.Point(20,100)
$P3L3.Font = 'Lucida Sans,11'

$P3  = New-Object system.Windows.Forms.Groupbox
$P3.height = 140
$P3.width = 120
$P3.text = "   Left rotor"
$P3.location = New-Object System.Drawing.Point(($rslx+130),$rsly)
$P3.controls.AddRange(@($P3L1, $P3L2, $P3L3))

# Rotor settings labels ########################################################

$Pr1 = New-Object System.Windows.Forms.TextBox
$Pr1.Multiline = $false;
$Pr1.Location = New-Object System.Drawing.Point($rslx,($rsly+29))
$Pr1.Size = New-Object System.Drawing.Size(530,40)
$Pr1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",12,[System.Drawing.FontStyle]::Regular)
$Pr1.Enabled= $false;
$Pr1.AppendText("Rotor selection")

$Pr2 = New-Object System.Windows.Forms.TextBox
$Pr2.Multiline = $false;
$Pr2.Location = New-Object System.Drawing.Point($rslx,($rsly+64))
$Pr2.Size = New-Object System.Drawing.Size(530,40)
$Pr2.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",12,[System.Drawing.FontStyle]::Regular)
$Pr2.Enabled= $false;
$Pr2.AppendText("Ring setting")

$Pr3 = New-Object System.Windows.Forms.TextBox
$Pr3.Multiline = $false;
$Pr3.Location = New-Object System.Drawing.Point($rslx,($rsly+99))
$Pr3.Size = New-Object System.Drawing.Size(530,40)
$Pr3.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",12,[System.Drawing.FontStyle]::Regular)
$Pr3.Enabled= $false;
$Pr3.AppendText("Rotor position")

$Form.controls.AddRange(@($P1, $P2, $P3, $Pr1, $Pr2, $Pr3))

# Rotor selection verifications ################################################

function RotorsSet {
    if ($P1L1.SelectedIndex -ne -1 -and $P2L1.SelectedIndex -ne -1 -and $P3L1.SelectedIndex -ne -1) {
    $global:RRnot = [char]($notchPs[$global:RRn-1]) - 65
    $global:MRnot = [char]($notchPs[$global:MRn-1]) - 65
    $InBox.Enabled = $true;
    $IMlab.Text = 'Type your message below:'
    }
}

function RotorsNotSet {
    $InBox.Enabled = $false;
    $IMlab.Text = 'Please, select the rotors first...'
}

$P1L1_SelectedIndexChanged = { 
    if ($P1L1.text -eq $P2L1.text) { $P2L1.SelectedIndex = -1; RotorsNotSet } 
    if ($P1L1.text -eq $P3L1.text) { $P3L1.SelectedIndex = -1; RotorsNotSet }
    if ($P1L1.SelectedIndex -ne -1) { $global:RRn = $P1L1.SelectedIndex + 1 }
    RotorsSet
}
$P1L1.add_SelectedIndexChanged($P1L1_SelectedIndexChanged)

$P2L1_SelectedIndexChanged = { 
    if ($P2L1.text -eq $P1L1.text) { $P1L1.SelectedIndex = -1; RotorsNotSet } 
    if ($P2L1.text -eq $P3L1.text) { $P3L1.SelectedIndex = -1; RotorsNotSet } 
    if ($P2L1.SelectedIndex -ne -1) { $global:MRn = $P2L1.SelectedIndex + 1 }
    RotorsSet
}
$P2L1.add_SelectedIndexChanged($P2L1_SelectedIndexChanged)

$P3L1_SelectedIndexChanged = { 
    if ($P3L1.text -eq $P1L1.text) { $P1L1.SelectedIndex = -1; RotorsNotSet } 
    if ($P3L1.text -eq $P2L1.text) { $P2L1.SelectedIndex = -1; RotorsNotSet } 
    if ($P3L1.SelectedIndex -ne -1) { $global:LRn = $P3L1.SelectedIndex + 1 }
    RotorsSet
}
$P3L1.add_SelectedIndexChanged($P3L1_SelectedIndexChanged)

# Ring setting selection #######################################################

$P1L2_SelectedIndexChanged = { 
    $global:RRr = $P1L2.SelectedIndex + 1
}
$P1L2.add_SelectedIndexChanged($P1L2_SelectedIndexChanged)

$P2L2_SelectedIndexChanged = { 
    $global:MRr = $P2L2.SelectedIndex + 1
}
$P2L2.add_SelectedIndexChanged($P2L2_SelectedIndexChanged)

$P3L2_SelectedIndexChanged = { 
    $global:LRr = $P3L2.SelectedIndex + 1
}
$P3L2.add_SelectedIndexChanged($P3L2_SelectedIndexChanged)

# Rotor rotation selection  ####################################################

$P1L3_SelectedIndexChanged = { 
    $global:RRof = $P1L3.SelectedIndex
}
$P1L3.add_SelectedIndexChanged($P1L3_SelectedIndexChanged)

$P2L3_SelectedIndexChanged = { 
    $global:MRof = $P2L3.SelectedIndex
}
$P2L3.add_SelectedIndexChanged($P2L3_SelectedIndexChanged)

$P3L3_SelectedIndexChanged = { 
    $global:LRof = $P3L3.SelectedIndex
}
$P3L3.add_SelectedIndexChanged($P3L3_SelectedIndexChanged)


# PLUGBOARD ####################################################################

$PBcomDefault = 'Insert up to 10 letter pairs:'
$PBcom = New-Object System.Windows.Forms.Label
$PBcom.Location = New-Object System.Drawing.Point(($pblx+130),$pbly)
$PBcom.Size = New-Object System.Drawing.Size(420,20)
$PBcom.Text = $PBcomDefault
$form.Controls.Add($PBcom)

$TempBox = New-Object System.Windows.Forms.TextBox
$Stecker = New-Object System.Windows.Forms.TextBox
$Stecker.Multiline = $False;
$Stecker.Location = New-Object System.Drawing.Point(($pblx+130),($pbly+25))
$Stecker.Size = New-Object System.Drawing.Size(390,100)
$Stecker.Font = New-Object System.Drawing.Font("Lucida Sans Typewriter",13,[System.Drawing.FontStyle]::Regular)
$Stecker.CharacterCasing = 'Upper'
$Stecker.ShortcutsEnabled = $False;     # Prevents copy-pasting
$form.Controls.Add($Stecker)
$oldText = ""

$PBlab = New-Object System.Windows.Forms.TextBox
$PBlab.Multiline = $false;
$PBlab.Location = New-Object System.Drawing.Point($pblx,($pbly+26))
$PBlab.Size = New-Object System.Drawing.Size(530,40)
$PBlab.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",12,[System.Drawing.FontStyle]::Regular)
$PBlab.Enabled= $false;
$PBlab.AppendText("Plugboard")
$form.Controls.Add($PBlab)

# Plugboard input control ######################################################

$Stecker.Add_TextChanged( {
  $stcText = $Stecker.Text
  if ( $Stecker.Text.Length -eq 0) { $PBcom.Text = $PBcomDefault }
  if ($Stecker.Text.Length -gt $TempBox.Text.Length) { 
    $addSTClen = $Stecker.Text.Length - $TempBox.Text.Length
    $lastSTCtxt = $stcText.SubString($Stecker.Text.Length - $addSTClen, $addSTClen)
    $oldText = $TempBox.Text
    # Prohibit characters that are not A-Z, are previously present or result in excessive length
    if( -not (IsAlphaS($lastSTCtxt)) -or $oldText.contains($lastSTCtxt) -or ($Stecker.Text.Length -gt 29) ) {
      $Stecker.Text = $Stecker.Text.SubString(0, $Stecker.Text.Length-$lastSTCtxt.length)   # Removes text if not alpha
      $Stecker.Select($Stecker.Text.Length,0)     # Puts cursor to the end
      $Stecker.ScrollToCaret()                    # Puts cursor to the end
      $stcText = $Stecker.Text
      $lastSTCtxt = ""
      }
    else {
      $stcText = $stcText -replace ' ', ''
      $pairs = [math]::floor([decimal]($stcText.Length / 2))
      $stcText = $stcText -replace '([A-Z]{2})', '$1 '
      if ($stcText.Length -gt 29) { $stcText = $stcText.Trim() }
      $Stecker.Text = $stcText
      $Stecker.Select($Stecker.Text.Length,0)
      $Stecker.ScrollToCaret()
      $TempBox.Text = $stcText
      if ($pairs -eq 10) { $PBcom.Text = "You have defined all $pairs possible pairs." }
      else { $PBcom.Text = "You have defined $pairs pairs." }
      # Write-Host "tempbox.text.lenght =" $TempBox.Text.Length
      if ($stcText.SubString(0, ($stcText.Length - 1)) -eq $stcText.Trim()) {
        $global:PBpairsSet = PBarray $stcText
        }
      }
  }
  elseif ($Stecker.TextLength -eq 0) { 
    $TempBox.Text = ""
    $lastSTCtxt = ""
    $global:PBpairsSet = PBarray $stcText
    }
  elseif ($Stecker.Text.Length -eq $TempBox.Text.Length) { $lastSTCtxt = "" }
  else { 
    $TempBox.Text = $TempBox.Text.SubString(0, $Stecker.Text.Length)
    $lastSTCtxt = ""
    $shortText = $stcText -replace ' ', '' 
    $pairs = [math]::floor([decimal]($shortText.Length / 2))
    if ($pairs -gt 0) { 
      $PBcom.Text = "You have defined $pairs pairs." 
      $global:PBpairsSet = PBarray $stcText.SubString(0, ($pairs * 3)-1)
      }
    else { 
      $PBcom.Text = $PBcomDefault 
      $global:PBpairsSet = PBarray ""
      }
    }
  # Write-Host "Stecker.Text =" $Stecker.Text
} )


# Enigma logo ##################################################################

$pic =  New-Object System.Windows.Forms.PictureBox
$pic.Location = New-object System.Drawing.Size(610,30)
$pic.Width = 100
$pic.Height = 50
$pic.BackColor = [System.Drawing.Color]::Transparent
$pic.ImageLocation = "$PSScriptRoot\Images\Enigma_Logo-gray.png"
$pic.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
$form.Controls.Add($pic)


# INPUT MESSAGE BOX ############################################################

$IMlab = New-Object System.Windows.Forms.Label
$IMlab.Location = New-Object System.Drawing.Point(80,405)
$IMlab.Size = New-Object System.Drawing.Size(400,20)
$IMlab.Text = 'Type your message below:'
$form.Controls.Add($IMlab)

$InBox = New-Object System.Windows.Forms.TextBox
$InBox.Multiline = $True;
$InBox.Location = New-Object System.Drawing.Point(80,430)
$InBox.Size = New-Object System.Drawing.Size(590,100)
$InBox.Font = New-Object System.Drawing.Font("Courier New",16,[System.Drawing.FontStyle]::Regular)
$InBox.CharacterCasing = 'Upper'
$InBox.Scrollbars = "Vertical"
$form.Controls.Add($InBox)


$InBox.Add_TextChanged( {
  $theText = $InBox.Text
  if ($theText.Length -gt $OutBox.TextLength) { 
    $addedlen = $theText.Length - $OutBox.TextLength
    $lastText = $theText.SubString($theText.length - $addedlen, $addedlen)
    # Prohibit characters that are not A-Z
    if( -not (IsAlpha($lastText)) ) {
      $InBox.Text = $InBox.Text.SubString(0, $theText.length-$lastText.length)   # Removes text if not alpha
      $InBox.Select($InBox.Text.Length,0)                                        # Puts cursor to the end
      $InBox.ScrollToCaret()                                                     # Puts cursor to the end
      $theText = $InBox.Text
      $lastText = ""
      }
    else {
      # Write-Host "last text =" $lastText
      }
    $OutBox.AppendText((Encryption $lastText))
    }
  elseif ($InBox.TextLength -eq 0) { 
    $OutBox.Text = ""
    $lastText = ""
    UndoInput(-1)
    }
  elseif ($theText.Length -eq $OutBox.TextLength) { $lastText = "" }
  else { 
    $eraseLen = $OutBox.Text.Length - $InBox.Text.length
    $OutBox.Text = $OutBox.Text.SubString(0, $theText.length)
    $lastText = "" 
    UndoInput($eraseLen)
    }
  # Write-Host "last text =" $lastText
} )


# OUTPUT MESSAGE BOX ###########################################################

$OMlab = New-Object System.Windows.Forms.Label
$OMlab.Location = New-Object System.Drawing.Point(80,265)
$OMlab.Size = New-Object System.Drawing.Size(400,20)
$OMlab.Text = 'Encrypted message:'
$form.Controls.Add($OMlab)

$OutBox = New-Object System.Windows.Forms.TextBox
$OutBox.Multiline = $True;
$OutBox.Location = New-Object System.Drawing.Point(80,290)
$OutBox.Size = New-Object System.Drawing.Size(590,100)
$OutBox.Font = New-Object System.Drawing.Font("Courier New",16,[System.Drawing.FontStyle]::Regular)
$OutBox.Scrollbars = "Vertical"
$OutBox.ReadOnly = $true;
$form.Controls.Add($OutBox)



# ENCODING PROCESS #############################################################


function RotorEncodeF([int]$rn, [int]$rs, [int]$offs, [char]$InputL) {
# Forward Encode: $rn = rotor number, $rs = ring setting, $offs = rotor offset, $InputL = input letter
  # Get wiring rule for the selected rotor
  $rotwir = Get-Variable -Name "rot$($rn)out" -ValueOnly
  # Join rotor wiring arrays
  $WheelTab = for ( $i = 0; $i -lt 26; $i++ ) {
    [PSCustomObject]@{ LetterIn = $Lin[$i]; LetterOut = $rotwir[$i] }
  }
  # Get through which letter input should enter the wheel before rotations (after rings are set)
  $L0txt = [char]((([byte][char]$InputL - 89 - $rs) % 26) + 90)
  # Get position of the letter that is offset for $offs from $L0txt
  $L1pos = (([byte][char]$L0txt - 65 + $offs) % 26)
  # Get which letter on the same position in LetterOut
  $L2txt = $WheelTab.LetterOut[$L1pos]
  # Get which letter is on the ring at the output contact
  $L3txt = [char]((([byte][char]$L2txt - 66 + $rs) % 26) + 65)
  # Get which letter is offset for $offs from above letter
  $OutputL = [char]((([byte][char]$L3txt - 90 - $offs) % 26) + 90)
  # Return the result of the function
  return $OutputL
}


function RotorEncodeB([int]$rn, [int]$rs, [int]$offs, [char]$InputL) {
# Backward Encode: $rn = rotor number, $rs = ring setting, $offs = rotor offset, $InputL = input letter
  # Get wiring rule for the selected rotor
  $rotwir = Get-Variable -Name "rot$($rn)out" -ValueOnly
  # Join rotor wiring arrays
  $WheelTab = for ( $i = 0; $i -lt 26; $i++ ) {
    [PSCustomObject]@{ LetterIn = $Lin[$i]; LetterOut = $rotwir[$i] }
  }
  # Get index of the letter through which input should enter the wheel
  $L0pos = (([byte][char]$InputL - 65 + $offs) % 26)
  # Get index of the corresponding letter on the rotor (left side)
  $L1pos = (($L0pos + 27 - $rs) % 26)
  # Get the corresponding letter on the right side of the rotor
  $L2txt = ($WheelTab | Sort-Object -Property LetterOut).LetterIn[$L1pos]
  # Get for how much is rottor offset disregarding the ring
  $L3pos = (([byte][char]$L2txt - 66 - $offs) % 26)
  # Get which letter was offset for $rs from above position
  $OutputL = [char]((($L3pos + 26 + $rs) % 26) + 65)
  # Return the result of the function
  return $OutputL
}


function Reflector([char]$rf, [char]$InputL) {
# Reflector Encode: $rf = reflector version, $InputL = input letter
  # Get wiring rule for the selected reflector
  $refwir = Get-Variable -Name "ref$($rf)out" -ValueOnly
  # Join rotor wiring arrays
  $RefTab = for ( $i = 0; $i -lt 26; $i++ ) {
    [PSCustomObject]@{ LetterIn = $Lin[$i]; LetterOut = $refwir[$i] }
  }
  # Get position of the letter through which the signal enters
  $L0pos = (([byte][char]$InputL - 65) % 26)
  # Get the corresponding connected letter in the reflector
  $OutputL = ($RefTab | Sort-Object -Property LetterOut).LetterIn[$L0pos]
  # Return the result of the function
  return $OutputL
}


function PBarray([string]$PBstring) {
# Generate an array simulating plugboard connections 
  $PBpairs = @()
  $PBstring = $PBstring.Trim()
  if ([string]::IsNullOrEmpty($PBstring) -or $PBstring.Length -lt 2 ) {
    $PBpairs = for ( $i = 0; $i -lt 26; $i++ ) {
    [PSCustomObject]@{ LetterIn = $Lin[$i]; LetterOut = $Lin[$i] }
    }
  }
  else {
    # Convert the string of letter pairs into two dimensional array of inputs and outputs
    $PBsetup = $PBstring.Split(" ")
    $PBpairs = for ( $i = 0; $i -lt $PBsetup.Length; $i++ ) {
    [PSCustomObject]@{ LetterIn = [char]$PBsetup[$i].substring(0,1); LetterOut = [char]$PBsetup[$i].substring(1,1) }
    [PSCustomObject]@{ LetterIn = [char]$PBsetup[$i].substring(1,1); LetterOut = [char]$PBsetup[$i].substring(0,1) }
    }
    # Compare the array with full alphabet and add the non-used letters as the self-mirroring pairs
    Compare-Object $Lin $PBpairs.LetterIn | 
    Where-Object { $_.SideIndicator -eq '<=' } | 
    Foreach-Object { $PBpairs += [PSCustomObject]@{ LetterIn = $_.InputObject; LetterOut = $_.InputObject } }
    $PBpairs = $PBpairs | Sort-Object -Property LetterIn
  }
  return $PBpairs
}


function Plugboard($InputL) {
# Plugboard Encode: $InputL = input letter
  $L1pos = [array]::indexof($global:PBpairsSet.LetterIn, $InputL)
  $OutputL = $global:PBpairsSet.LetterOut[$L1pos]
  return $OutputL
}


function Save-Settings {
  $lastPos = $global:InLog.Length - 1 
  # Right rotor
  $global:InLog[$lastPos].rrT = $global:RRn
  $global:InLog[$lastPos].rrS = $global:RRr
  $global:InLog[$lastPos].rrP = $global:RRof
  # Middle rotor
  $global:InLog[$lastPos].mrT = $global:MRn
  $global:InLog[$lastPos].mrS = $global:MRr
  $global:InLog[$lastPos].mrP = $global:MRof
  # Left rotor
  $global:InLog[$lastPos].lrT = $global:LRn
  $global:InLog[$lastPos].lrS = $global:LRr
  $global:InLog[$lastPos].lrP = $global:LRof
  # Plugboard
  $global:InLog[$lastPos].pb = $Stecker.Text
}


function UndoInput([int]$cl) {
  if ($cl -eq -1) { $newPos = 0; }
  else { $newPos = $global:InLog.Length - $cl - 1 }
  # Right rotor
  $P1L1.SelectedIndex = $global:InLog[$newPos].rrT - 1
  $P1L2.SelectedIndex = $global:InLog[$newPos].rrS - 1
  $P1L3.SelectedIndex = $global:InLog[$newPos].rrP
  # Middle rotor
  $P2L1.SelectedIndex = $global:InLog[$newPos].mrT - 1
  $P2L2.SelectedIndex = $global:InLog[$newPos].mrS - 1
  $P2L3.SelectedIndex = $global:InLog[$newPos].mrP
  # Left rotor
  $P3L1.SelectedIndex = $global:InLog[$newPos].lrT - 1
  $P3L2.SelectedIndex = $global:InLog[$newPos].lrS - 1
  $P3L3.SelectedIndex = $global:InLog[$newPos].lrP
  # Plugboard
  $Stecker.Text = $global:InLog[$newPos].pb
  $global:InLog = $global:InLog[0..$newPos]
}



# Define initial plugboard setting
$global:PBpairsSet = PBarray ""
# Set the settings and input-output logger
$global:InLog = @( @{Kid=0; In=""; Out=""; lrT=$global:LRn; lrS=$global:LRr; lrP=$global:LRof; mrT=$global:MRn; 
  mrS=$global:MRr; mrP=$global:MRof; rrT=$global:RRn; rrS=$global:RRr; rrP=$global:RRof; pb=$Stecker.Text} )


function Encryption([string]$message) {
# Combined encryption function
  $encrypted = ""
  foreach ($char in [char[]]$message) {
    Save-Settings
    # Notch setting rules (if statement sequence must be obeyed)
    if ($global:MRof -eq $global:MRnot) { $global:MRof = $global:MRof + 1; $global:LRof = $global:LRof + 1 } 
    if ($global:RRof -eq $global:RRnot) { $global:MRof = $global:MRof + 1 }
    $global:RRof = $global:RRof + 1
                                               # Write-Host "Right rottor offset =" $global:RRof
    $P1L3.SelectedIndex = $global:RRof % 26
    $P2L3.SelectedIndex = $global:MRof % 26
    $P3L3.SelectedIndex = $global:LRof % 26
                                               # Write-Host "Middle rottor letter =" $alphabet[$P2L3.SelectedIndex]
    # Rotor and reflector encoding routines
    $PBstart = Plugboard $char
    $RighRotF = RotorEncodeF $RRn $RRr $RRof $PBstart
    $MiddRotF = RotorEncodeF $MRn $MRr $MRof $RighRotF
    $LeftRotF = RotorEncodeF $LRn $LRr $LRof $MiddRotF
    $ReflectL = Reflector $rd $LeftRotF
    $LeftRotB = RotorEncodeB $LRn $LRr $LRof $ReflectL
    $MiddRotB = RotorEncodeB $MRn $MRr $MRof $LeftRotB
    $RighRotB = RotorEncodeB $RRn $RRr $RRof $MiddRotB
    $PBend = Plugboard $RighRotB
    $encrypted = $encrypted + $PBend
    $global:InLog += @{Kid=$global:InLog.Length; In=$char; Out=$PBend; 
      lrT=$global:LRn; lrS=$global:LRr; lrP=$global:LRof;  
      mrT=$global:MRn; mrS=$global:MRr; mrP=$global:MRof; 
      rrT=$global:RRn; rrS=$global:RRr; rrP=$global:RRof; pb=$Stecker.Text}
  }
  # Write-Host "Encrypted =" $encrypted
  return $encrypted
}


# Program icon #################################################################

$iconBase64 = "`
iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAB3RJTUUH5gEDFQIK6xI+ZgAAAAlwSFlzAAALEgAACxIB`
0t1+/AAAAARnQU1BAACxjwv8YQUAAAJPUExURf////7+/vHx8dbW1vf3993d3XV1dcHBwfLy8szMzM/Pz/r6+vX19fDw`
8Ht7ewAAAE1NTRkZGTAwMBAQEMDAwNvb29TU1JiYmDs7Oz4+PhEREQoKChMTE8jIyA4ODjw8PD09PRgYGAICAlVVVaqq`
qsrKysbGxgsLCw0NDTExMa2traCgoLW1tdXV1ZycnHR0dFxcXCoqKo+PjxYWFmBgYKWlpby8vPPz8/b29pSUlO3t7Vtb`
W0RERBUVFeTk5BsbG6mpqfj4+O7u7urq6svLy+vr6+zs7M3NzQMDAxQUFDU1NeLi4pOTkxoaGoODg9ra2unp6fT09O/v`
79nZ2d/f397e3uPj47Ozs3BwcNfX152dnfn5+dzc3M7OztHR0cTExJCQkPz8/Lq6uisrKx8fHzg4ONjY2IiIiDQ0NB0d`
HXNzc+bm5igoKCUlJScnJ8fHx+Hh4ejo6Ofn5+Dg4FNTU2ZmZikpKTc3N5eXl76+vuXl5QgICHd3d0hISExMTNLS0re3`
t8XFxdDQ0CwsLHl5eSYmJj8/P6GhocnJya+vr7+/v8PDwzMzM42NjaioqCIiIn5+frGxsb29vVdXVwwMDCEhITk5OWFh`
YcLCwq6urm5ubru7u6ysrB4eHrKyspaWli4uLmRkZFJSUjY2Ni8vL1ZWVpKSkmVlZSMjIyAgIPv7+2dnZ4SEhAUFBdPT`
04mJiYKCgi0tLQkJCX9/f6Ojo21tbWtra/39/QYGBlRUVKampoGBgQQEBJGRkba2tjo6Og8PDyQkJH19fbm5uUZGRiva`
wkMAAAABdFJOUwBA5thmAAADE0lEQVR42n2TaVPTUBSGS9pqhNSj1AYUEUUFQYuySGrECA0JYsSmaRKEhiqKFYzUQgQ0`
LlC0WhfEDXcR96LivuGKyw8zIC6DjufLnbnPM+fOJO9rMk0Y2fSfOXrSs/jbDKpa+xd83f81D4z5DEOw0iOSfwnlBozG`
R5qj2VWfRwC+TMC5pxp744byCbZsBajsba8q9bn+4EgONL2HtrYPwRWRj4dSBqFwAKD49/NSz5zQm+EDPp30l+chBPu2`
Z9geh3f1PwURIB/SzBzidSGq1UYQGFYL0Dv0qm5cCMLTZ89foBZC93XjAbxGZjEBfwkh2P2D6/v6miHgspBSudnnc+KP`
YmF3mfAY4plPxvj9BzBQ8lBLEqSAzkkVMUkTu60IQfY3tA9d948a6wqjRTSKaU5eplSnmZJ1LaAQli4IxQcZg7su59++`
E/bTVpVRWxWfR6JaaFFzE9TdeU336scWdNzEURdttSFujzMS0RQGYTtbCffmWznJnYZw9VrGiRjh1SgMo4LpV3OVFp4g`
OVXvvz5wPnrDazJJfecvXBRQnsS8mniakYtpxiZwKnVJudxov2JsONmbcQov4EWVIGTpdCxynGdQtzXcwp8523EuaDKV`
HYrOPHwkxtAUaXNPzso9eiyA2lhZp+njjSdm9RgbWvcnH6iwYHqYxDv1uq4Iziga7aRIpnvaQSg1hKS29o7djF+VpD2J`
pI2nbWw17gjrglYU2rsvwRBU2NEc2ulHwpyDpVsYlm/VgprCMvKuQpg6+iHrN29p2FrMuuggV0OJiiwrokMUUM+2xibY`
njT2NwpgFdR6/YziM5vrlAAnSrSAbYRFsGk8VOugCtZ7eK/A+TyiJDlkFkGrN0Ah1IzngUqxr4a0UlcZ4abLrTTDokzF`
GqiEtdyv0BUYetHyYsKFrDBjCImvLMlcBQuI36HNyjZehJzcxVn4Emfe0mWjBcnH/kh1ApI+ByANIGMupBpwXub8BQsn`
NCMldSbMglHLPts4rH81KwmzTYVp0wGSwT7Dgf+zu4jZYp00GZ2S+L+CJ0y8+A5sXNIOmC6/xwAAAABJRU5ErkJggg=="
$iconBytes = [Convert]::FromBase64String($iconBase64)
# initialize a Memory stream holding the bytes
$stream = [System.IO.MemoryStream]::new($iconBytes, 0, $iconBytes.Length)
$Form.Icon = [System.Drawing.Icon]::FromHandle(([System.Drawing.Bitmap]::new($stream).GetHIcon()))
# PowerShell versions older than 5.0 use this:
# $stream  = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
# $Form.Icon = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())


# View the input-output and settings log #######################################

$logOut = $global:InLog | ForEach {[PSCustomObject]$_} | 
  Format-Table Kid,In,Out,lrT,lrS,lrP,mrT,mrS,mrP,rrT,rrS,rrp,pb -AutoSize


# Form activation and exit procedures ##########################################

$form.Topmost = $true
$form.Add_Shown({$InBox.Select()})
[void]$form.ShowDialog()

$stream.Dispose()
$form.Dispose()
[System.GC]::Collect()

