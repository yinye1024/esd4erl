%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyes_helper).
-author("yinye").

-include_lib("yyutils/include/yyu_comm.hrl").

-export([to_search_bin/1]).
%% API functions defined

%% ===================================================================================
%% API functions implements
%% ===================================================================================

to_search_bin(SearchText)->
  erlang:iolist_to_binary(SearchText).


