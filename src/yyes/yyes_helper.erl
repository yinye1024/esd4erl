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

-export([to_str_list/1]).
%% API functions defined

%% ===================================================================================
%% API functions implements
%% ===================================================================================
to_str_list(CuserIdList)when is_list(CuserIdList)->
  priv_to_str_list(CuserIdList,[]).
priv_to_str_list([CuserId|Less],AccList)->
  priv_to_str_list(Less,[yyu_misc:to_list(CuserId)|AccList]);
priv_to_str_list([],AccList)->
  AccList.



