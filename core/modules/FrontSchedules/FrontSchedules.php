<?php
//simpilotgroup addon module for phpVMS virtual airline system
//
//Creative Commons Attribution Non-commercial Share Alike (by-nc-sa)
//To view full license text visit http://creativecommons.org/licenses/by-nc-sa/3.0/
//
//@author David Clark (simpilot)
//@copyright Copyright (c) 2009-2012, David Clark
//@license http://creativecommons.org/licenses/by-nc-sa/3.0/

class FrontSchedules extends CodonModule
{
	public $title = 'Search';
	
	public function index() {
            if(isset($this->post->action))
            {
                if($this->post->action == 'findflight') {
                $this->findflight();
                }
            }
            else
            {
            $this->set('airports', OperationsData::GetAllAirports());
            $this->set('airlines', OperationsData::getAllAirlines());
            $this->set('aircrafts', FrontSchedulesData::findaircrafttypes());
            $this->set('countries', FrontSchedulesData::findcountries());
            $this->show('RSL/airport_search.tpl');
            }
        }

        public function findflight()
	{
		$arricao = DB::escape($this->post->arricao);
                $depicao = DB::escape($this->post->depicao);
                $airline = DB::escape($this->post->airline);
                $aircraft = DB::escape($this->post->aircraft);
                
                if(!$airline)
                    {
                        $airline = '%';
                    }
                if(!$arricao)
                    {
                        $arricao = '%';
                    }
                if(!$depicao)
                    {
                        $depicao = '%';
                    }
                if($aircraft == !'')
                {
                    $aircrafts = FrontSchedulesData::findaircraft($aircraft);
                    foreach($aircrafts as $aircraft)
                    {
                        $route = FrontSchedulesData::findschedules($arricao, $depicao, $airline, $aircraft->id);
                        if(!$route){$route=array();}
                        if(!$routes){$routes=array();}
                        $routes = array_merge($routes, $route);
                    }
                }
                else
                {
                $routes = FrontSchedulesData::findschedule($arricao, $depicao, $airline);
                }

		$this->set('allroutes', $routes);
		$this->show('RSL/schedule_results.tpl');
                
	}
}