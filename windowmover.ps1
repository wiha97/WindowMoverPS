Import-Module ./set-window.ps1

$content = Get-Content "config.txt"
# Reads through config file
foreach($item in $content)
{
	$row = $item.Split(",")

    $app = $row[0]
    $x = $row[1]
    $y = $row[2]
    $w = $row[3]
    $h = $row[4]

    $arr
    if($app.Contains("["))
    {
        $fullApp = $app
        $app = $app.Substring(1,$app.IndexOf(" ")-1)
        echo $fullApp.IndexOf(" ")
        $idx1 = $fullApp.IndexOf(" ")
        $idx2 = $fullApp.IndexOf("]")-1
        $arguments = $fullApp.Substring($idx1+1, $idx2 - $idx1 -1)

        $arr = $arguments.Split(" ")

        $argList
        foreach($arg in $arr)
        {
            $argList = $argList+" "+$arg
            echo "adding $arg to list"
        }

        # Starts app with a parameter (e.g firefox -P profile1)
        $procid = Start-Process $app -ArgumentList $argList
        echo "Arguments: $argList"
    }

    $procid = Get-Process $app | select -expand id -last 1

    Set-Window -ProcessName $app -X $x -Y $y -width $w -height $h -Passthru
    echo "Moving $app [$procid] to $x,$y w$w h$h"
    $argList = $null
}
echo "Press any key to exit..."
[Console]::ReadKey($true)