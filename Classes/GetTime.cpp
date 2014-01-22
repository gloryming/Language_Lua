//
//  GetTime.cpp
//  Language_Lua
//
//  Created by 郭 一鸣 on 14-1-17.
//
//


#include "GetTime.h"
#include <sys/time.h>

GetTime::GetTime()
{
    std::cout << "GetTime called" << std::endl;
}

GetTime::~GetTime()
{
}

unsigned long GetTime::getCurrentTime()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

int lua_GetTime_constructor(lua_State* l)
{    
    GetTime ** userData = (GetTime **)lua_newuserdata(l, sizeof(GetTime *));
    
    *userData = new GetTime();
    
    luaL_getmetatable(l, "luaL_GetTime");
    
    lua_setmetatable(l, -2);
    
    return 1;
}

GetTime * lua_checkGetTime(lua_State* l, int n)
{
    return *(GetTime **)luaL_checkudata(l, n, "luaL_GetTime");
}

int lua_getCurrentTime(lua_State* l)
{
    GetTime * getTime = lua_checkGetTime(l, 1);
    
    unsigned long time = getTime->getCurrentTime();
    
    lua_pushnumber(l, time);
    
    return 1;
}

int lua_GetTime_destructor(lua_State* l)
{
    GetTime * getTime = lua_checkGetTime(l, 1);
    
    delete getTime;
    
    return 0;
}

void RegisterGetTime(lua_State* l)
{
    luaL_Reg sGetTimeRegs[] =
    {
        {"new", lua_GetTime_constructor },
        {"getCurrentTime", lua_getCurrentTime},
        {"__gc", lua_GetTime_destructor},
        { NULL, NULL }
    };

    luaL_newmetatable(l, "luaL_GetTime");
    
    luaL_register(l, NULL, sGetTimeRegs);
    
    lua_pushvalue(l, -1);
    
    lua_setfield(l, -1, "__index");
    
    lua_setglobal(l, "GetTime");
}

