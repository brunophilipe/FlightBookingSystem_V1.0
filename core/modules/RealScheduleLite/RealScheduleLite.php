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

class RealScheduleLite extends CodonModule {

    public $title = 'Real Schedule Lite';

    public function index() {
        $this->set('airports', OperationsData::getAllAirports());
        $this->set('aircrafts', OperationsData::getAllAircraft('true'));
        $this->show('realschedulelite/realschedulelite_index.tpl');
    }

    public function get_airport() {

        $icao = $_GET['icao'];
        $this->set('aircrafts', OperationsData::getAllAircraft('true'));
        $this->set('name', OperationsData::getAirportInfo($icao));
        $this->show('realschedulelite/realschedulelite_airport_details.tpl');
    }

    public function get_aircraft() {
        $id = $_GET['id'];
        $this->set('aircraft', OperationsData::getAircraftInfo($id));
        $this->set('route', RealScheduleLiteData::get_aircraft_route($id));
        $this->set('current', RealScheduleLiteData::get_aircraft_location($id));
        $this->show('realschedulelite/realschedulelite_airroute.tpl');
    }

    public function jumpseat()  {
        $icao = DB::escape($_GET['depicao']);
        $this->set('airport', OperationsData::getAirportInfo($icao));
        $this->set('cost', DB::escape($_GET['cost']));
        $this->show('RSL/realschedulelite_jumpseatconfirm.tpl');
    }

    public function purchase()  {
       
               $id = DB::escape($_GET['id']);
               $cost = $_GET['cost'];
               $curmoney = Auth::$userinfo->totalpay;
               $total = ($curmoney - $cost);
               RealScheduleLiteData::purchase_ticket(Auth::$userinfo->pilotid, $total);
               RealScheduleLiteData::update_pilot_location($id);
               header('Location: '.url('/FrontSchedules'));
            
    }
}