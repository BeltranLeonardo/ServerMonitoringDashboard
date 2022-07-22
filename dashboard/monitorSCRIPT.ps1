PowerShell -NoProfile -ExecutionPolicy Unrestricted -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Unrestricted -File ""C:\monitorSCRIPT.ps1""' -Verb RunAs}";

While($true)
{ 
    $i++


## FICHERO CON LISTA DE SERVIDORES
$ServerListFile = "C:\listaservidores.txt"  
$ServerList = Get-Content $ServerListFile -ErrorAction SilentlyContinue 

$Outputreport | out-file C:\web.html

$Outputreport = "<!DOCTYPE html>
<html>
<head>
<meta http-equiv=""refresh"" content=""8"" >
<style>
.titulo {
            font-family: Verdana;
            font-weight: bold;
            font-size: 25px;
            text-align: center;
            background-color: #0584F1;
            color: white;
        }
        
.tabla {
    font-family: Verdana;
    font-size: 20px;
        ext-align: center;
}
.fecha {
            font-family: Verdana;
            font-weight: bold;
            font-size: 20px;
            text-align: center;
            background-color: #0584F1;
            color: white;
}
table {
    border-collapse: collapse;
    width: 100%;
}

th, td {
    text-align: left;
    padding: 10px;
    font-weight: bold;
}

tr:nth-child(even){background-color: #f2f2f2}

th {
    background-color: #053F71;
    color: white;
    font-size: 20px;
}
</style>
</head>
<body>

<div class=""titulo"">ALERTA SERVIDORES</div>

<div class = ""fecha"" id = ""date""> fecha </div>

<div class=""tabla"">
            <table style=""width:20%; float:left"">
                <tr>
                    <th>Servidor</th>
                </tr>
                <tr>
                    <td>Shared Folders</td>
                </tr>
                <tr>
                    <td>FTPC Prod Server</td>
                </tr>
                <tr>
                    <td>FTPC SQL Server</td>
                </tr>
                <tr>
                    <td>FTP Getter ANOVA</td>
                </tr>
                <tr>
                    <td>TRESS Server</td>
                </tr>
                <tr>
                    <td>Active Directory</td>
                </tr>
                <tr>
                    <td>Rachio Server</td>
                </tr>
                <tr>
                    <td>HyperV1</td>
                </tr>
                <tr>
                    <td>HyperV2</td>
                </tr>
                <tr>
                    <td>TJ SQL(Circuit CAM)</td>
                </tr>
                <tr>
                    <td>CONTPAQ</td>
                </tr>
                <tr>
                    <td>NAS</td>
                </tr>
            </table>" 
$Outputreport += "<table id=""table1"" style=""width:80%; float:left"">
                    <tr>
                    <th>IP</th>
                    <th>%CPU</th>
                    <th>Ram Libre</th>
                    <th>%C: Libre</th>
                    <th>%D: Libre</th>
                    <th>%E: Libre</th>
                    <th>%F: Libre</th>
                    <th>%G: Libre</th>
                </tr>"



  Remove-Job -name * -Force


ForEach($computername in $ServerList) 
{
    Start-Job -name ($computername+".UsoCPU") -ScriptBlock {((Get-Counter -ComputerName $using:computername "\Processor(_total)\% Processor Time").CounterSamples.CookedValue)} -ArgumentList $computername 
    Start-Job -name ($computername+".UsoMEMORIA") -ScriptBlock {((Get-Counter -ComputerName $using:computername "\memory\available mbytes").CounterSamples.CookedValue)} -ArgumentList $computername
    Start-Job -name ($computername+".UsoC") -ScriptBlock {((Get-Counter -ComputerName $using:computername "\LogicalDisk(C:)\% Free Space").CounterSamples.CookedValue)} -ArgumentList $computername
    Start-Job -name ($computername+".UsoD") -ScriptBlock {((Get-Counter -ComputerName $using:computername "\LogicalDisk(D:)\% Free Space").CounterSamples.CookedValue)} -ArgumentList $computername
    Start-Job -name ($computername+".UsoE") -ScriptBlock {((Get-Counter -ComputerName $using:computername "\LogicalDisk(E:)\% Free Space").CounterSamples.CookedValue)} -ArgumentList $computername
    Start-Job -name ($computername+".UsoF") -ScriptBlock {((Get-Counter -ComputerName $using:computername "\LogicalDisk(F:)\% Free Space").CounterSamples.CookedValue)} -ArgumentList $computername
    Start-Job -name ($computername+".UsoG") -ScriptBlock {((Get-Counter -ComputerName $using:computername "\LogicalDisk(G:)\% Free Space").CounterSamples.CookedValue)} -ArgumentList $computername

}

ForEach($computername in $ServerList) 
{

## ESPERAMOS RESULTADO DE JOB CPU

try { Wait-Job -name ($computername+".UsoCpu")
$UsoCPUfinal = [math]::Round((Receive-Job -Name ($computername+".UsoCpu") -ErrorAction Stop)) }
catch { $UsoCPUfinal = "" }
Remove-Job -name ($computername+".UsoCpu") -Force

## ESPERAMOS RESULTADO DE JOB USO MEMORIA

try{ Wait-Job -name ($computername+".UsoMEMORIA")
$MemoriaUsadaFinal = [math]::Round((Receive-Job -Name ($computername+".UsoMEMORIA") -ErrorAction Stop)) } 
catch { $MemoriaUsadaFinal = "" }
Remove-Job -name ($computername+".UsoMEMORIA") -Force

## ESPERAMOS RESULTADO DE JOB USO C

try{ Wait-Job -name ($computername+".UsoC")
$DiscoClibreFinal = [math]::Round((Receive-Job -Name ($computername+".UsoC") -ErrorAction Stop)) } 
catch { $DiscoClibreFinal = "" }
Remove-Job -name ($computername+".UsoC") -Force

## ESPERAMOS RESULTADO DE JOB USO D

try{ Wait-Job -name ($computername+".UsoD")
$DiscoDlibreFinal = [math]::Round((Receive-Job -Name ($computername+".UsoD") -ErrorAction Stop)) } 
catch { $DiscoDlibreFinal = "" }
Remove-Job -name ($computername+".UsoD") -Force

## ESPERAMOS RESULTADO DE JOB USO E

try{ Wait-Job -name ($computername+".UsoE")
$DiscoElibreFinal = [math]::Round((Receive-Job -Name ($computername+".UsoE") -ErrorAction Stop)) } 
catch { $DiscoElibreFinal = "" }
Remove-Job -name ($computername+".UsoE") -Force

## ESPERAMOS RESULTADO DE JOB USO F

try{ Wait-Job -name ($computername+".UsoF")
$DiscoFlibreFinal = [math]::Round((Receive-Job -Name ($computername+".UsoF") -ErrorAction Stop)) } 
catch { $DiscoFlibreFinal = "" }
Remove-Job -name ($computername+".UsoF") -Force

## ESPERAMOS RESULTADO DE JOB USO G

try{ Wait-Job -name ($computername+".UsoG")
$DiscoGlibreFinal = [math]::Round((Receive-Job -Name ($computername+".UsoG") -ErrorAction Stop)) } 
catch { $DiscoGlibreFinal = "" }
Remove-Job -name ($computername+".UsoG") -Force



$Outputreport += "<tr>"
$Outputreport += "<td>$($computername)</td>"
$Outputreport += "<td>$($UsoCPUfinal)&nbsp</td>"
$Outputreport += "<td>$($MemoriaUsadaFinal)</td>"
$Outputreport += "<td>$($DiscoClibreFinal)</td>"
$Outputreport += "<td>$($DiscoDlibreFinal)</td>"
$Outputreport += "<td>$($DiscoElibreFinal)</td>"
$Outputreport += "<td>$($DiscoFlibreFinal)</td>"
$Outputreport += "<td>$($DiscoGlibreFinal)</td>"
$Outputreport += "</tr>"


         }

$Outputreport += "</table>"
$Outputreport += "</div>"
$Outputreport += "</body>"
$Outputreport += "<script>
            
                        n =  new Date();
                        y = n.getFullYear();
                        m = n.getMonth() + 1;
                        d = n.getDate();
                        h = n.getHours();
                        min = n.getMinutes();
                        sec = n.getSeconds();
                        document.getElementById(""date"").innerHTML = m + ""/"" + d + ""/"" + y + "" "" + h + "":"" + min + "":"" + sec;
                        
                    
                        var table = document.getElementById(""table1"");
                        var max = table.rows.length;

                        var cpu = table.rows[0].cells[1];
                        var ram = table.rows[0].cells[2];
                        var clibre = table.rows[0].cells[3];
                        var dlibre = table.rows[0].cells[4];
                        var elibre = table.rows[0].cells[5];
                        var flibre = table.rows[0].cells[6];
                        var glibre = table.rows[0].cells[7];
                        var celda = 0;

                        for(var i = 1; i < max; i++) {
                        
                            cpu = table.rows[i].cells[1];
                            ram = table.rows[i].cells[2];
                            clibre = table.rows[i].cells[3];
                            dlibre = table.rows[i].cells[4];
                            elibre = table.rows[i].cells[5];
                            flibre = table.rows[i].cells[6];
                            glibre = table.rows[i].cells[7];

                            //CPU
                            celda = parseInt(cpu.innerHTML);
                            if (celda >= 20 && celda <= 44)
                            {
                                cpu.style.backgroundColor = ""yellow"";
                            }
                            else if (celda >= 45 && celda <= 87)
                            {
                                cpu.style.backgroundColor = ""orange"";
                            }
                            else if (celda >= 88 && celda <= 100)
                            {
                                cpu.style.backgroundColor = ""red"";
                            }
                            
                            //Disco C Libre 
                            celda = parseFloat(clibre.innerHTML)
                            if (celda <= 10 && celda >=0)
                            {
                                clibre.bgColor = ""red"";
                            }
                            else if (celda >=11 && celda <= 18)
                            {
                                clibre.bgColor = ""orange"";
                            }

                            //Disco D Libre
                            celda = parseFloat(dlibre.innerHTML)
                            if (celda <= 10 && celda >=0)
                            {
                                dlibre.bgColor = ""red"";
                            }
                            else if (celda >=11 && celda <= 18)
                            {
                                dlibre.bgColor = ""orange"";
                            }

                            //Disco E Libre
                            celda = parseFloat(elibre.innerHTML)
                            if (celda <= 10 && celda >=0)
                            {
                                elibre.bgColor = ""red"";
                            }
                            else if (celda >=11 && celda <= 18)
                            {
                                elibre.bgColor = ""orange"";
                            }

                            //Disco F Libre
                            celda = parseFloat(flibre.innerHTML)
                            if (celda <= 10 && celda >=0)
                            {
                                flibre.bgColor = ""red"";
                            }
                            else if (celda >=11 && celda <= 18)
                            {
                                flibre.bgColor = ""orange"";
                            }

                            //Disco G Libre
                            celda = parseFloat(glibre.innerHTML)
                            if (celda <= 10 && celda >=0)
                            {
                                glibre.bgColor = ""red"";
                            }
                            else if (celda >=11 && celda <= 18)
                            {
                                glibre.bgColor = ""orange"";
                            }

                            //convertir MB a GB
                            var l=0, celdaRAM = parseFloat(ram.innerHTML);
                            while(celdaRAM >= 1024 && ++l){
      						    celdaRAM = celdaRAM/1024;
                                ram.innerHTML = celdaRAM.toFixed(2) + ""gb"";
                          
  							}

                        }

                        var maxC = document.getElementById('table1').rows[0].cells.length;
                        var cll;
                        for (var i = 1; i < max; i++)
                        {
                    	    for (var j = 1; j < maxC; j++)
                            {
                                if (j == 2)
                      		        continue;
                      	        cll = table.rows[i].cells[j];
                                celda = parseInt(cll.innerHTML);
                                if (isNaN(celda))
                       	            cll.innerHTML = ""-""
                                else
                       	            cll.innerHTML = celda + ""%""
                            }
                        }
                    
</script>"

$Outputreport += "</html>"


Remove-Job -name * -Force

 }