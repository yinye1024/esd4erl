%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyes_result_aggs).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").

-export([from_json/2]).
-export([get_list/1]).


%% ===================================================================================
%% API functions implements
%% ===================================================================================

from_json(AggName,BodyJson)->
  BodyMap = yyu_json:json_to_map(BodyJson),
  AggMap = yyu_map:get_value(aggregations,BodyMap),

  AggNameMap = yyu_map:get_value(AggName,AggMap),
  AggList = yyu_map:get_value(buckets,AggNameMap),
  #{
    list => AggList
  }.


get_list(ItemMap) ->
  yyu_map:get_value(list, ItemMap).

