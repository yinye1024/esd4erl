%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyes_result_hits).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").

-export([from_json/1]).
-export([get_total/1,get_hits/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================

from_json(BodyJson)->
  BodyMap = yyu_json:json_to_map(BodyJson),
  HitsMap = yyu_map:get_value(hits,BodyMap),
  Total = priv_get_total(HitsMap),
  HitMapList = yyu_map:get_value(hits,HitsMap),
  #{
    total => Total,
    hits => HitMapList
  }.
priv_get_total(HitsMap)->
  MapTmp = yyu_map:get_value(total,HitsMap),
  yyu_map:get_value(value,MapTmp).

get_total(ItemMap) ->
  yyu_map:get_value(total, ItemMap).

get_hits(ItemMap) ->
  yyu_map:get_value(hits, ItemMap).

