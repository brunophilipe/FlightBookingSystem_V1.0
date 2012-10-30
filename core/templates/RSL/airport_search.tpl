<?php
//simpilotgroup addon module for phpVMS virtual airline system
//
//simpilotgroup addon modules are licenced under the following license:
//Creative Commons Attribution Non-commercial Share Alike (by-nc-sa)
//To view full icense text visit http://creativecommons.org/licenses/by-nc-sa/3.0/
//
//@author David Clark (simpilot)
//@copyright Copyright (c) 2009-2010, David Clark
//@license http://creativecommons.org/licenses/by-nc-sa/3.0/
$pilotid = Auth::$userinfo->pilotid;
$last_location = RealScheduleLiteData::get_pilot_location($pilotid, 1);
$last_name = OperationsData::getAirportInfo($last_location->arricao);
if(!$last_location)
{
echo RealScheduleLiteData::update_pilot_location(Auth::$userinfo->hub);
}

?>
<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script>
$(document).ready(function(){
	$("select").change(function () {
		var cost = "";
		$("select option:selected").each(function (){
			cost = $(this).attr("name");
                        airport = $(this).text();
		});
		$("input[name=cost]").val( cost );
                $("input[name=airport]").val( airport );
		}).trigger('change');
});
	</script>
<h3><b>Flight Dispatch</b></h3>

<form action="<?php echo url('/FrontSchedules');?>" method="post" enctype="multipart/form-data">
<ul>
	<li>Current Location: <input id="depicao" name="depicao" type="hidden" value="<?php echo $last_location->arricao?>"><font color="red"><?php echo $last_location->arricao?> - <?php echo $last_name->name?></font></li>
</ul>
    <table class="balancesheet" width="80%" align="center">

	<tr class="balancesheet_header">
		<td colspan="5">Schedule Search</td>
	</tr>
        
        <tr>
            <td>Select An Airline:</td>
            <td>
                <select class="search" name="airline">
                    <option value="">All</option>
                    <?php
                        foreach ($airlines as $airline)
                            {echo '<option value="'.$airline->code.'">'.$airline->name.'</option>';}
                    ?>
                </select>
            </td>
        </tr>
        <tr>
            <td>Select An Aircraft Type:</td>
            <td>
                <select class="search" name="aircraft">
                    <option value="">All</option>
                    <?php
						$airc = RealScheduleLiteData::routeaircraft($last_location->arricao);
						if(!$airc)
							{
								echo '<option>No Aircraft Available!</option>';
							}
						else
							{
								foreach ($airc as $air)
									{
									$ai = RealScheduleLiteData::getaircraftbyID($air->aircraft);
					?>
							<option value="<?php echo $ai->icao ;?>"><?php
							echo $ai->name ;?></option>
					<?php
									}
							}
                    ?>
                </select> <img src="http://www.parkho.ir/info.png" title="Available aircraft to search from your current location">
            </td>
        </tr>
        <tr>
            <td>Select Arrival Airfield:</td>
            <td>
                <select class="search" name="arricao">
                    <option value="">All</option>
                    <?php
						$airs = RealScheduleLiteData::arrivalairport($last_location->arricao);
						if(!$airs)
							{
								echo '<option>No Airports Available!</option>';
							}
						else
							{
								foreach ($airs as $air)
									{
										$nam = OperationsData::getAirportInfo($air->arricao);
										echo '<option value="'.$air->arricao.'">'.$air->arricao.' - '.$nam->name.'</option>';
									}
							}
                    ?>
                </select> <img src="http://www.parkho.ir/info.png" title="Available airports to search from your current location">
            </td>
        </tr>
		<tr>
		        
				<td align="center" colspan="2">
                <input type="hidden" name="action" value="findflight" />
                <input border="0" type="submit" name="submit" value="Search">
				<a href="<?php echo url('/schedules/bids') ;?>"><input type="button" value="Remove Bid"></a></td>			
		
            
        </tr>
        <br />
        
    </table>
</form>
<br />
<hr>
<br />
<h3><b>Pilot Transfer</b></h3>
<ul>
	<li>Your Bank limit is : <?php echo FinanceData::FormatMoney(Auth::$userinfo->totalpay) ;?></li>
</ul>
<br />
<form action="<?php echo url('/realschedulelite/jumpseat');?>" method="get">
	<table class="balancesheet" width="80%" align="center">
<thead>
	<tr class="balancesheet_header">
		<td colspan="5">Airport Selection</td>
	</tr>
    	<tr>
		<td align="center">Transfer to:</td>
            <td align="left">
                <select class="search" name="depicao" onchange="listSel(this,'cost')">
                    <option value="">--Select</option>
                    <?php
                        foreach ($airports as $airport){
                            $distance = round(SchedulesData::distanceBetweenPoints($last_name->lat, $last_name->lng, $airport->lat, $airport->lng), 0);
                            $permile = Config::Get('JUMPSEAT_COST');
                            $cost = ($permile * $distance);
                            $check = PIREPData::getLastReports(Auth::$userinfo->pilotid, 1,1);
                            if($cost >= Auth::$userinfo->totalpay)
                               {
                                continue;
                               }
                            elseif($check->accepted == PIREP_ACCEPTED || !$check)
							   {
								 echo "<option name='{$cost}' value='{$airport->icao}'>{$airport->icao} - {$airport->name}    /Cost - $ {$cost}</option>";
							   }
                                ?>
                               
                               <hr> 
                 <?php                   
                         }
                    ?> 
                    </select>
                 <?php
					if(Auth::$userinfo->totalpay == "0")
                        {
					?>
                            <INPUT TYPE="submit" VALUE="Go!" disabled="disabled"> 
					<?php
					    }
					else
                        {
					?>
							<INPUT TYPE="submit" VALUE="Go!">
					<?php
						}
					?>
            	     </td>
                </select>
            </td>
         </tr>
         </table>
         <input type="hidden" name="cost">
         <input type="hidden" name="airport">
</form>

	
	 