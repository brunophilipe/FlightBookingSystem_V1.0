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

class FrontSchedulesData extends CodonData
{
    public function findschedules($arricao, $depicao, $airline, $aircraft)   {
        $query = "SELECT phpvms_schedules.*, phpvms_aircraft.name AS aircraft, phpvms_aircraft.registration
               FROM phpvms_schedules, phpvms_aircraft
                WHERE phpvms_schedules.depicao LIKE '$depicao'
                AND phpvms_schedules.arricao LIKE '$arricao'
                AND phpvms_schedules.code LIKE '$airline'
                AND phpvms_schedules.aircraft LIKE '$aircraft'
                AND phpvms_aircraft.id LIKE '$aircraft'";

        return DB::get_results($query);
    }

      
     public function findschedule($arricao, $depicao, $airline)   {
        $query = "SELECT phpvms_schedules.*, phpvms_aircraft.name AS aircraft, phpvms_aircraft.registration
                FROM phpvms_schedules, phpvms_aircraft
                WHERE phpvms_schedules.depicao LIKE '$depicao'
                AND phpvms_schedules.arricao LIKE '$arricao'
                AND phpvms_schedules.code LIKE '$airline'
                AND phpvms_aircraft.id LIKE phpvms_schedules.aircraft";

        return DB::get_results($query);
    }
 
    public function findaircrafttypes() {
        $query = "SELECT DISTINCT icao
                FROM phpvms_aircraft";

        return DB::get_results($query);
    }

    public function findaircraft($aircraft) {
        $query = "SELECT id
                FROM phpvms_aircraft
                WHERE icao='$aircraft'";

        return DB::get_results($query);
    }

    public function findcountries() {
        $query = "SELECT DISTINCT country
                FROM phpvms_airports";

        return DB::get_results($query);
    }

}