<div id="contenttext">
<?php
//simpilotgroup addon module for phpVMS virtual airline system
//
//simpilotgroup addon modules are licenced under the following license:
//Creative Commons Attribution Non-commercial Share Alike (by-nc-sa)
//To view full license text visit http://creativecommons.org/licenses/by-nc-sa/3.0/
//
//@author David Clark (simpilot)
//@copyright Copyright (c) 2009-2010, David Clark
//@license http://creativecommons.org/licenses/by-nc-sa/3.0/
?>
<h3>Jumpseat Ticket Purchase</h3>

 <table class="balancesheet" width="80%" align="center">

	<tr class="balancesheet_header">
		<td colspan="1">Jumpseat Confirmation</td>
	</tr>
    <tr>
        <td>Destination:<b> <?php echo $airport->name; ?></b></td>
    </tr>
    <tr>
        <td>Departure Date:<b> <?php echo date('m/d/Y') ?></b></td>
    </tr>
    <tr>
        <td>Travel Class:<b> Employee (Best Available)</b></td>
    </tr>
    <tr>
        <td>Total Cost:<b> $<?php echo $cost; ?></b></td>
    </tr>
</table>
<br />
<center>
    <a href="<?php echo url('/frontschedules'); ?>"><input type="button" value="Cancel Purchase"></a>
    <?php
        echo '<a href="'.url('/RealScheduleLite/purchase').'?id='.$airport->icao.'&cost='.$cost.'"><input type="button" value="Purchase Ticket"></a>';
    ?>
</center>
</div>