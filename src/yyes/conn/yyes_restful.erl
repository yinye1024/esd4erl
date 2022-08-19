%%%-------------------------------------------------------------------
%%% @author yinye
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 四月 2021 19:45
%%%-------------------------------------------------------------------
-module(yyes_restful).
-author("yinye").
-include_lib("yyutils/include/yyu_comm.hrl").

%% API functions defined
-export([get/1]).
-export([delete/1]).
-export([post/2]).
-export([put/2]).
-export([bulk/2]).

-define(HTTP,http).
-define(HTTPS,https).
-define(HTTP_METHOD_GET,get).
-define(HTTP_METHOD_POST,post).
-define(HTTP_METHOD_PUT,put).
-define(HTTP_METHOD_DEL,delete).
-define(TIME_OUT_MS,20000).

%% ===================================================================================
%% API functions implements
%% ===================================================================================
get(Url)->
  Result = httpc:request(?HTTP_METHOD_GET, {Url,[]}, priv_get_http_options(), []),
  priv_handle_result(Result).


delete(Url) ->
  Result = httpc:request(?HTTP_METHOD_DEL, {Url,[],"application/json; charset=UTF-8",""}, priv_get_http_options(), []),
  priv_handle_result(Result).


post(Url, PostMap) when is_map(PostMap)->
  PostJson = yyu_json:map_to_json(PostMap),
  BinJson = yyu_misc:to_binary(PostJson),
  Result = httpc:request(?HTTP_METHOD_POST, {Url,[], "application/json;charset=UTF-8",BinJson}, priv_get_http_options(), []),
  priv_handle_result(Result).

put(Url, PostMap) when is_map(PostMap)->
  PostJson = yyu_json:map_to_json(PostMap),
  BinJson = yyu_misc:to_binary(PostJson),
  Result = httpc:request(?HTTP_METHOD_PUT, {Url,[], "application/json;charset=UTF-8",BinJson}, priv_get_http_options(), []),
  priv_handle_result(Result);
put(Url, PostJson) when is_list(PostJson)->
  BinJson = yyu_misc:to_binary(PostJson),
  Result = httpc:request(?HTTP_METHOD_PUT, {Url,[], "application/json;charset=UTF-8",BinJson}, priv_get_http_options(), []),
  priv_handle_result(Result).

bulk(Url, PostData) when is_list(PostData)->
  BinJson = yyu_misc:to_binary(PostData),
  Result = httpc:request(?HTTP_METHOD_PUT, {Url,[], "application/x-ndjson;charset=UTF-8",BinJson}, priv_get_http_options(), []),
  priv_handle_result(Result).




priv_get_http_options()->
  [{timeout,?TIME_OUT_MS}].

priv_handle_result(Result)->
  ?LOG_INFO({restresponse,Result}),
  case Result of
    {?OK,{{"HTTP/1.1",200,"OK"},_Header, Body} } -> {?OK,Body};
    {?OK,{{"HTTP/1.1",201,"Created"},_Header, Body} } -> {?OK,Body};
    {?OK,{{"HTTP/1.1",404,"Not Found"},_Header, Body} } -> {?OK,?NOT_FOUND};
    {?OK,{{"HTTP/1.1",_,Msg},_Header, _Body} } -> {?FAIL,Msg};
    {error,Msg} -> yyu_error:throw_error(http_error,Msg)
  end.

