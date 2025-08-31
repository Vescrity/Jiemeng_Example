#include <lauxlib.h> 
#include <lua.h>
#include <lualib.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct {
     char* orig;
     char* cf;
     char* code;
     bool valid;
}Entry;

static Entry* entries = NULL;
static int max_entries = 0;

#define MAX_CODE 210000
static int load_data(lua_State* L)
{
    const char* filename = luaL_checkstring(L, 1);
    FILE* file = fopen(filename, "r");
    if (!file) {
        return luaL_error(L, "无法打开文件");
    }

    if (entries) {
        for(unsigned i=0; i<MAX_CODE; i++)
        {
            if(entries[i].valid) {
                free(entries[i].orig);
                free(entries[i].cf  );
                free(entries[i].code);
            }
        }
        free(entries);
    }

    max_entries = 0;
    entries = (Entry*)calloc(sizeof(Entry) , MAX_CODE);
    if (!entries) {
        fclose(file);
        return luaL_error(L, "内存分配失败");
    }

    char line[MAX_CODE];
    while (fgets(line, sizeof(line), file)) {
        int number;
        Entry entry={NULL ,NULL /*,NULL*/};
        if (sscanf(line, "%d %ms %ms", &number, &entry.orig, &entry.cf/*, &entry.code*/) ==/*4 */3) {
            if (number >= 0 && number < MAX_CODE) { 
                entries[number] = entry;
                max_entries = (number > max_entries) ? number : max_entries;
                entries[number].valid=1;
            }
        }
    }

    fclose(file);
    return 0;
}

static int get_data(lua_State* L)
{
    int number = luaL_checkinteger(L, 1);
    if (number >= 0 && number <= max_entries) {
        Entry entry = entries[number];
        if (entry.orig) {
            lua_newtable(L);
            lua_pushstring(L, entry.orig);
            lua_setfield(L, -2, "orig");
            lua_pushstring(L, entry.cf);
            lua_setfield(L, -2, "cf");
            lua_pushstring(L, entry.code);
            lua_setfield(L, -2, "code");
            return 1;
        }
    }
    lua_pushnil(L); // 如果没有找到，返回 nil
    return 1;
}
// 注册函数到 Lua
static const struct luaL_Reg hu_cf[] = {
    { "load", load_data },
    { "get", get_data },
    { NULL, NULL } // 结束标志
};
// 注册模块
int luaopen_hu_cf(lua_State* L)
{
    luaL_newlib(L, hu_cf);
    return 1;
}
