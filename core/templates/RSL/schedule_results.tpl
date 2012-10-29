<?php
$pilotid = Auth::$userinfo->pilotid;
$last_location = RealScheduleLiteData::get_pilot_location($pilotid, 1);
$last_name = OperationsData::getAirportInfo($last_location->arricao);
?>
<h3><b>Flight Dispatch</b></h3>
<br />
<ul>
	<li>Available flights from <?php echo $last_location->arricao.' ( '.$last_name->name.')' ;?>.</li>
</ul>
<br />
<table class="balancesheet" width="80%" align="center">
	<tr class="balancesheet_header">
		<td colspan="5">Schedule Booking</td>
	</tr>
<?php
if(!$allroutes)
{
?>
	<tr><td align="center">No flights from <?php echo $last_location->arricao.' ( '.$last_name->name.')' ;?>!</td></tr>
	
<?php
}
else
{
?>
<script src="http://skyvector.com/linkchart.js"></script>


<tr style="height:12px; font-size:14px; font-weight:normal">
    <th width="20%" align="center">Flight ID</th>
    <th width="20%" align="center">Origin</th>
    <th width="20%" align="center">Destination</th>
    <th width="20%" align="center">Aircraft</th>
    <th width="20%" colspan="2" align="center">Options</th>
</tr>
<tr>
    <td width="20%" align="center">------------</td>
    <td width="20%" align="center">------------</td>
    <td width="20%" align="center">------------</td>
    <td width="20%" align="center">------------</td>
    <td width="20%" colspan="2" align="center">------------</td>
</tr>
<?php
foreach($allroutes as $route)
{
	if(Config::Get('DISABLE_SCHED_ON_BID') == true && $route->bidid != 0)
	{
		continue;
	}
	if(Config::Get('RESTRICT_AIRCRAFT_RANKS') === true && Auth::LoggedIn())
	{
		if($route->aircraftlevel > Auth::$userinfo->ranklevel)
		{
			continue;
		}
	}
?>

<tr style="height:12px; font-size:14px; font-weight:normal;">
	<td width="20%" align="center" valign="middle"><?php echo $route->code . $route->flightnum?></td>
	<td width="20%" align="center" valign="middle"><?php echo $route->depicao ;?></td>
	<td width="20%" align="center" valign="middle"><?php echo $route->arricao ;?></td>
	<td width="20%" align="center" valign="middle"><?php echo $route->aircraft ;?></td>
    <td width="20%" align="center" valign="middle"><a class="{button:{icons:{primary:'ui-icon-arrowthick-1-s'}}}" href="#" onclick="$('#details_dialog_<?php echo $route->flightnum;?>').toggle()"><input type="button" value="Details"></a>
         
	   <?php 
		if($route->bidid != 0)
	    {
        ?>
        <img src="http://alvandair.com/lib/skins/aqua/images/BookingButt/SwissBook.png" border="0">
        <?php
		}
        else
		{
		?>
	    <a id="<?php echo $route->id; ?>" class="addbid" href="<?php echo url('/schedules/addbid');?>"><input type="button" value="Book"></a>
        <?php                    
        }
        ?>
    </td>
</tr>

        <td colspan="5">
		
		<table cellspacing="0" cellpadding="0" border="1" id="details_dialog_<?php echo $route->flightnum;?>" style="display:none" width="100%">
		   
			<tr>
			<th align="center" bgcolor="black" colspan="4"><font color="white">Flight Brefing</font></th>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspDeaprture:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php
			$name = OperationsData::getAirportInfo($route->depicao);
			echo "{$name->name}"?></b></td>
			<td align="left">&nbsp&nbspArrival:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php 
			$name = OperationsData::getAirportInfo($route->arricao);
			echo "{$name->name}"?></b></td>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspAircraft</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php 
			$plane = OperationsData::getAircraftByName($route->aircraft);
			echo $plane->fullname ; ?></b></td>
			<td align="left">&nbsp&nbspDistance:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php echo $route->distance . Config::Get('UNITS') ;?></b></td>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspDep Time:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<font color="red"><?php echo $route->deptime?> GMT</font></b></td>
			<td align="left">&nbsp&nbspArr Time:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<font color="red"><?php echo $route->arrtime?> GMT</font></b></td>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspAltitude:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php echo $route->flightlevel; ?> ft</b></td>
			<td align="left">&nbsp&nbspDuration:</td>
			<td colspan="0" align="left" ><font color="red"><b>&nbsp
			<?php 
			
			$dist = $route->distance;
			$speed = 440;
			$app = $speed / 60 ;
			$flttime = round($dist / $app,0)+ 20;
			$hours = intval($flttime / 60);
            $minutes = (($flttime / 60) - $hours) * 60;
			if($hours > "9" AND $minutes > "9")
			{
			echo $hours.':'.$minutes ;
			}
			else
			{
			echo '0'.$hours.':0'.$minutes ;
			}
			?> Hrs</b></font></td>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspDays</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php echo Util::GetDaysLong($route->daysofweek) ;?></b></td>
			<td align="left">&nbsp&nbspPrice:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp$<?php echo $route->price ;?>.00</b></td>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspFlight Type:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php
			if($route->flighttype == "P")
			{
			echo'Passenger' ;
			}
			if($route->flighttype == "C")
			{
			echo'Cargo' ;
			}
			if($route->flighttype == "H")
			{
			echo'Charter' ;
			}
			?></b></td>
			<td align="left">&nbsp&nbspFlown</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php echo $route->timesflown ;?></b></td>
			</tr>
			<tr>
			<th align="center" bgcolor="black" colspan="4"><font color="white">Fuel Calculation for <?php 
			$plane = OperationsData::getAircraftByName($route->aircraft);
			echo $plane->fullname ; ?>
			</font></th>
			</tr>
			<?php
            $fuelflowB722 = 3800;
			$fuelhrB722 = 3000;
		    $fuelflowB738 = 1045;
            $fuelhrB738 = 3970;
			$fuelflowB744 = 1845;
			$fuelhrB744 = 7671;
			$fuelflowB763 = 1405;
			$fuelhrB763 = 4780;
            $fuelflowB772 = 2200;
			$fuelhrB772 = 6400;
			$fuelflowA30B = 1526;
			$fuelhrA30B = 8065;
		    $fuelflowA320 = 790;
			$fuelhrA320 = 3000;
		    $fuelflowA332 = 1433;
			$fuelhrA332 = 6375;
            $fuelflowA343 = 1829;
			$fuelhrA343 = 8300;
			$fuelflowF100 = 744;
			$fuelhrF100 = 2136;
			
			
            
                   
        if($route->aircraft == 'B737-800')
         {
         	$fuelflow = $fuelflowB738;
            $fuelhr = $fuelhrB738;
         }
         elseif($route->aircraft == 'B747-400')
         {
         	$fuelflow = $fuelflowB744;
            $fuelhr = $fuelhrB744;
         }
         elseif($route->aircraft == 'B767-300')
         {
         	$fuelflow = $fuelflowB763;
            $fuelhr = $fuelhrB744;
         }
		 elseif($route->aircraft == 'B777-200')
         {
         	$fuelflow = $fuelflowB772;
            $fuelhr = $fuelhrB772;
         }
         elseif($route->aircraft == 'B727-200')
         {
         	$fuelflow = $fuelflowB727;
            $fuelhr = $fuelhrB727;
         }
         elseif($route->aircraft == 'A300B2')
         {
         	$fuelflow = $fuelflowA30B;
            $fuelhr = $fuelhrA30B;
         }
         elseif($route->aircraft == 'A320-200')
         {
         	$fuelflow = $fuelflowA320;
            $fuelhr = $fuelhrA320;
         }
		 elseif($route->aircraft == 'A330-200')
         {
         	$fuelflow = $fuelflowA332;
            $fuelhr = $fuelhrA332;
         }
		 elseif($route->aircraft == 'A340-300')
         {
         	$fuelflow = $fuelflowA343;
            $fuelhr = $fuelhrA343;
         }
		 elseif($route->aircraft == 'F100')
         {
         	$fuelflow = $fuelflowF100;
            $fuelhr = $fuelhrF100;
         }
         
        $fldis = $route->distance / 100;
		$fuelnm = $fuelflow * $fldis;
        $fltaxi = 200;
		$flndg = $fuelhr * 3/4;
		$result = $fuelnm + $flndg + $fltaxi;
        ?> 	
						 <tr>
			             <td align="left" colspan="2">&nbsp&nbspAverage Cruise Speed:</td>
						 <td align="left" colspan="2">&nbsp&nbsp<b>430 kt/h - 800 km/h</b></td>
						 </tr>
						 <tr>
			             <td align="left" colspan="2">&nbsp&nbspFuel Per 1 Hour:</td>
						 <td align="left" colspan="2">&nbsp&nbsp<b><?php	echo $fuelhr ;?> kg - <?php echo ($fuelhr *2.2) ;?> lbs</b></td>
						 </tr>
						 <tr>
						 <td align="left" colspan="2">&nbsp&nbspFuel Per 100 NM:</td>
						 <td align="left" colspan="2"><b>&nbsp&nbsp<?php echo $fuelflow ;?> kg - <?php echo ($fuelflow *2.2) ;?> lbs</b></td>
						 </tr>
						 <tr>
						 <td align="left" colspan="2">&nbsp&nbspTaxi Fuel:</td>
						 <td align="left" colspan="2"><b>&nbsp&nbsp<?php echo $fltaxi ;?> kg - <?php echo ($fltaxi *2.2) ;?> lbs</b></td>
						 <tr>
						 <td align="left" colspan="2">&nbsp&nbspMinimum Fuel Requiered At Destination:</td>
						 <td align="left" colspan="2"><b>&nbsp&nbsp<?php echo $flndg ;?> kg - <?php echo ($flndg *2.2) ;?> lbs</b></td>
						 </tr>
						 <tr>
						 <td align="center" colspan="4"><font color="blue" size="4">Total Estimated Fuel Requiered For This Route:&nbsp;&nbsp;&nbsp;<?php echo round($result, 1) ;?> kg - <?php echo round(($result *2.2), 1) ;?> lbs</font></td>
						 </tr>
                         <tr>
						 <td align="center" colspan="4"><font size="3" color="red"><b>TO PREVENT ANY MISCALCULATION ADD 500 KG EXTRA!</b></font></td>                                  
                         </tr>
			</td>
			</tr>
			<tr>
			<th align="center" bgcolor="black" colspan="4"><font color="white">Flight Map</font></th>
			</tr>
			<tr>
			<td width="100%" colspan="4">
			<?php
			$string = "";
                        $string = $string.$route->depicao.'+-+'.$route->arricao.',+';
                        ?>

                        <img width="100%" src="http://www.gcmap.com/map?P=<?php echo $string ?>&amp;MS=bm&amp;MR=240&amp;MX=680x200&amp;PM=pemr:diamond7:red%2b%22%25I%22:red&amp;PC=%230000ff" />
</tr>
</td>
		 </table>	
        </td>
</tr>
			
<?php
}
}
?>
</table>
<br />
<hr>
<br />
<center><a href="<?php echo url('/FrontSchedules') ;?>"><input type="submit" name="submit" value="Back to Flight Booking System" ></a></center>
			
