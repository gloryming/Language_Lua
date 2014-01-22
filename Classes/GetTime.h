//
//  GetTime.h
//  Language_Lua
//
//  Created by 郭 一鸣 on 14-1-17.
//
//

#ifndef __Language_Lua__GetTime__
#define __Language_Lua__GetTime__

extern "C"
{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

#include <iostream>

class GetTime
{
public:
    GetTime();
    ~GetTime();
    unsigned long getCurrentTime();
};

int lua_GetTime_constructor(lua_State* l);

GetTime * lua_checkGetTime(lua_State* l, int n);

int lua_getCurrentTime(lua_State* l);

int lua_GetTime_destructor(lua_State* l);

void RegisterGetTime(lua_State* l);


#endif /* defined(__Language_Lua__GetTime__) */
