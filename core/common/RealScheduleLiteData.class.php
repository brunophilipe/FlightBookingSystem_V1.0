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

class RealScheduleLiteData extends codondata
{

    public function get_aircraft_location($aircraft)
    {
        $query = "SELECT arricao, aircraft FROM ".TABLE_PREFIX."pireps WHERE aircraft='$aircraft'
                ORDER BY submitdate DESC LIMIT 1";

        return DB::get_row($query);
    }

    public function get_next_flight($aircraft, $location)
    {
        $query = "SELECT * FROM ".TABLE_PREFIX."schedules WHERE aircraft='$aircraft' AND depicao='$location'";

        return DB::get_row($query);
    }

    public function get_aircraft_start($id)
    {
        $query = "SELECT * FROM ".TABLE_PREFIX."schedules
                    WHERE aircraft='$id'
                    ORDER BY id ASC
                    LIMIT 1";

        return DB::get_row($query);
    }

    public function get_aircraft_route($id)
    {
        $query = "SELECT * FROM ".TABLE_PREFIX."schedules
                    WHERE aircraft='$id'
                    ORDER BY id ASC";

        return DB::get_results($query);
    }

    public function get_pilot_location($pilot)
    {
        $query = "SELECT * FROM realschedulelite_location WHERE pilot_id='$pilot'";

        $real_location = DB::get_row($query);

        $pirep_location = PIREPData::getLastReports(Auth::$userinfo->pilotid, 1, '');

        if($real_location->last_update > $pirep_location->submitdate)
        {
            return $real_location;
        }
        else
        {
            return $pirep_location;
        }
    }

    public function update_pilot_location($icao)
    {
        $pilot = Auth::$userinfo->pilotid;//wont work for listener

        $query = "SELECT * FROM realschedulelite_location WHERE pilot_id='$pilot'";

        $check = DB::get_row($query);

        if(!$check)
        {
            $query1 = "INSERT INTO realschedulelite_location (pilot_id, arricao, jumpseats, last_update)
                    VALUES ('$pilot', '$icao', '1', NOW())";
        }
        else
        {
            $jumpseats = $check->jumpseats + 1;
            $query1 = "UPDATE realschedulelite_location SET arricao='$icao', jumpseats='$jumpseats', last_update=NOW() WHERE pilot_id='$pilot'";
        }

        DB::query($query1);
    }

    public function purchase_ticket($pilot_id, $total)
    {
        $query = 'UPDATE '.TABLE_PREFIX.'pilots
					SET totalpay='.$total.'
					WHERE pilotid='.$pilot_id;
        DB::query($query);
    }
	
	public function arrivalairport($icao)
	{
		$sql = "SELECT DISTINCT arricao FROM phpvms_schedules WHERE depicao = '$icao'";
		
		return DB::get_results($sql);
	}
	
	public function routeaircraft($icao)
	{
		$sql = "SELECT DISTINCT aircraft FROM phpvms_schedules WHERE depicao = '$icao'";
		
		return DB::get_results($sql);
	}
	
	public static function getAircraftByIcao($icao)
	{
		$sql = "SELECT * FROM phpvms_aircraft WHERE icao ='$icao'";
		return DB::get_row($sql);
	}
	
	public static function getAircraftByID($id)
	{
		$sql = "SELECT * FROM phpvms_aircraft WHERE id ='$id'";
		return DB::get_row($sql);
	}
}