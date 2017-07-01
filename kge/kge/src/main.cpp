#include <iostream>

#include<windows.h>

extern "C"
{
#include "lua/lua.h"
#include "lua/lualib.h"
#include "lua/lauxlib.h"
}

/* 指向Lua解释器的指针 */
lua_State* L;

typedef signed char     int8;
typedef unsigned char   uint8;
typedef short           int16;
typedef unsigned short  uint16;
typedef int             int32;
typedef unsigned int    uint32;

HINSTANCE g_hInst;                                // 当前实例
HWND g_hWnd;

int screen_w, screen_h = 0;

static HDC screen_dc = NULL;			// 配套的 HDC
static HBITMAP screen_hb = NULL;		// DIB
static HBITMAP screen_ob = NULL;		// 老的 BITMAP
unsigned char *screen_fb = NULL;		// frame buffer
uint32** framebuffer;


static int bit_lshit(lua_State* L)
{
	int n = lua_gettop(L);

	if (n != 2)
		return 0;

	int num = lua_tointeger(L, 1);
	int count = lua_tointeger(L, 2);

	int r = num << count;

	lua_pushinteger(L, r);

	return 1;
}

static int bit_rshit(lua_State* L)
{
	int n = lua_gettop(L);

	if (n != 2)
		return 0;

	int num = lua_tointeger(L, 1);
	int count = lua_tointeger(L, 2);

	int r = num << count;

	lua_pushinteger(L, r);

	return 1;
}

static int bit_and(lua_State* L)
{
	int n = lua_gettop(L);

	if (n != 2)
		return 0;

	int num = lua_tointeger(L, 1);
	int count = lua_tointeger(L, 2);

	int r = num & count;

	lua_pushinteger(L, r);

	return 1;
}

#pragma region Color
namespace BitMask
{
	const uint32 HH = 0xff << 24;
	const uint32 HL = 0xff << 16;
	const uint32 LH = 0xff << 8;
	const uint32 LL = 0xff << 0;
	const float Inv255 = 1.0f / 255.0f;
}

uint32 rgba2hex(float r, float g, float b, float a)
{
	return (uint32(r * 255) << 16)
		+ (uint32(g * 255) << 8)
		+ uint32(b * 255)
		+ (uint32(a * 255) << 24);
}

void hex2rgba(const uint32 rc, float& r, float& g, float& b, float& a)
{
	r = ((rc >> 16) & 0xff) * BitMask::Inv255;
	g = ((rc >> 8) & 0xff) * BitMask::Inv255;
	b = ((rc >> 0) & 0xff) * BitMask::Inv255;
	a = ((rc >> 16) & 0xff) * BitMask::Inv255;
}

static int color_rgba2hex(lua_State* L)
{
	int n = lua_gettop(L);

	if (n != 4)
		return 0;

	float r = (float)lua_tonumber(L, 1);
	float g = (float)lua_tonumber(L, 2);
	float b = (float)lua_tonumber(L, 3);
	float a = (float)lua_tonumber(L, 4);

	uint32 rc = rgba2hex(r, g, b, a);

	lua_pushnumber(L, rc);

	return 1;
}

static int color_hex2rgba(lua_State* L)
{
	int n = lua_gettop(L);

	if (n != 1)
		return 0;

	uint32 rc = (uint32)lua_tonumber(L, 1);

	float r = 0;
	float g = 0;
	float b = 0;
	float a = 0;

	hex2rgba(rc, r, g, b, a);

	lua_pushnumber(L, r);
	lua_pushnumber(L, g);
	lua_pushnumber(L, b);
	lua_pushnumber(L, a);

	return 4;
}

#pragma endregion

#pragma region Device

static int draw_pixel(lua_State *L)
{
	int n = lua_gettop(L);

	if (n != 3)
		return 0;

	uint32 x = (uint32)lua_tonumber(L, 1);
	uint32 y = (uint32)lua_tonumber(L, 2);
	uint32 cr = (uint32)lua_tonumber(L, 3);

	if (((uint32)x) < (uint32)screen_w && ((uint32)y) < (uint32)screen_h)
	{
		framebuffer[y][x] = cr;
	}

	return 0;
}

#pragma endregion


LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
	case WM_PAINT:
	{
		PAINTSTRUCT ps;
		HDC hdc = BeginPaint(hWnd, &ps);
		// TODO: 在此处添加使用 hdc 的任何绘图代码...

		EndPaint(hWnd, &ps);
	}
	break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

ATOM MyRegisterClass(HINSTANCE hInstance, const char* win_title)
{
	WNDCLASSEXW wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);

	wcex.style = CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc = WndProc;
	wcex.cbClsExtra = 0;
	wcex.cbWndExtra = 0;
	wcex.hInstance = hInstance;
	wcex.hIcon = LoadIcon(hInstance, nullptr);
	wcex.hCursor = LoadCursor(nullptr, IDC_ARROW);
	wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wcex.lpszMenuName = nullptr;


	WCHAR wszClassName[256];
	memset(wszClassName, 0, sizeof(wszClassName));
	::MultiByteToWideChar(CP_ACP, 0, win_title, strlen(win_title) + 1, wszClassName, sizeof(wszClassName) / sizeof(wszClassName[0]));

	wcex.lpszClassName = wszClassName;
	wcex.hIconSm = LoadIcon(wcex.hInstance, nullptr);

	return RegisterClassExW(&wcex);
}

BOOL InitInstance(HINSTANCE hInstance, int nCmdShow, const char* win_title, int width, int height)
{
	g_hInst = hInstance; // 将实例句柄存储在全局变量中

	WCHAR wszClassName[256];
	memset(wszClassName, 0, sizeof(wszClassName));
	::MultiByteToWideChar(CP_ACP, 0, win_title, strlen(win_title) + 1, wszClassName, sizeof(wszClassName) / sizeof(wszClassName[0]));

	g_hWnd = CreateWindowW(wszClassName, wszClassName, WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, 0, width, height, nullptr, nullptr, hInstance, nullptr);

	if (!g_hWnd)
	{
		return FALSE;
	}

	ShowWindow(g_hWnd, SW_SHOW);
	UpdateWindow(g_hWnd);

	return TRUE;
}

void device_init(int width, int height, void *fb)
{
	int need = sizeof(void*) * (height * 2 + 1024) + width * height * 8;
	char *ptr = (char*)malloc(need + 64);

	char *framebuf;
	framebuffer = (uint32**)ptr;

	ptr += sizeof(void*) * height * 2;
	ptr += sizeof(void*) * 1024;
	framebuf = (char*)ptr;
	if (fb != NULL)
		framebuf = (char*)fb;

	for (int j = 0; j < height; j++)
	{
		framebuffer[j] = (uint32*)(framebuf + width * 4 * j);
	}
}

void screen_update(void)
{
	HDC hDC = GetDC(g_hWnd);
	BitBlt(hDC, 0, 0, screen_w, screen_h, screen_dc, 0, 0, SRCCOPY);
	ReleaseDC(g_hWnd, hDC);
}

int main(int argc, char* argv[])
{

	L = lua_open();

	/* 载入Lua基本库 */
	luaL_openlibs(L);

	//加载Lua文件  
	int bRet = luaL_loadfile(L, "config.lua");
	if (bRet)
	{
		int stackTop = lua_gettop(L);//获取栈顶的索引值
		int nIdx = 0;
		int nType;

		//显示栈中的元素  
		for (nIdx = stackTop; nIdx > 3; --nIdx)
		{
			nType = lua_type(L, nIdx);
			std::cout << lua_tostring(L, nIdx) << std::endl;
		}

		std::cout << std::endl;
		return 0;
	}

	bRet = lua_pcall(L, 0, 0, 0);
	if (bRet)
	{
		int stackTop = lua_gettop(L);//获取栈顶的索引值
		int nIdx = 0;
		int nType;

		//显示栈中的元素  
		for (nIdx = stackTop; nIdx > 3; --nIdx)
		{
			nType = lua_type(L, nIdx);
			std::cout << lua_tostring(L, nIdx) << std::endl;
		}

		std::cout << std::endl;
		return 0;
	}

	lua_getglobal(L, "win_title");
	const char* win_title = lua_tostring(L, -1);

	lua_getglobal(L, "win_width");
	double width = lua_tonumber(L, -1);

	lua_getglobal(L, "win_height");
	double height = lua_tonumber(L, -1);

	screen_w = (int)width;
	screen_h = (int)height;

	HINSTANCE hInstance = ::GetModuleHandle(NULL);

	LPVOID ptr;
	HDC hDC;
	hDC = GetDC(g_hWnd);
	screen_dc = CreateCompatibleDC(hDC);
	ReleaseDC(g_hWnd, hDC);

	BITMAPINFO bi = { { sizeof(BITMAPINFOHEADER), width, -height, 1, 32, BI_RGB,
		width * height * 4, 0, 0, 0, 0 } };

	screen_hb = CreateDIBSection(screen_dc, &bi, DIB_RGB_COLORS, &ptr, 0, 0);
	if (screen_hb == NULL) return -3;

	screen_ob = (HBITMAP)SelectObject(screen_dc, screen_hb);
	screen_fb = (unsigned char*)ptr;

	device_init(screen_w, screen_h, screen_fb);


	MyRegisterClass(hInstance, win_title);

	// 执行应用程序初始化: 
	if (!InitInstance(hInstance, SW_SHOW, win_title, (int)width, (int)height))
	{
		return 0;
	}

	//HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_WIN32TEST));

	/* 注册函数 */
	lua_register(L, "draw_pixel", draw_pixel);
	lua_register(L, "bit_lshit", bit_lshit);
	lua_register(L, "bit_rshit", bit_rshit);
	lua_register(L, "bit_and", bit_and);

	lua_register(L, "color_rgba2hex", color_rgba2hex);
	lua_register(L, "color_hex2rgba", color_hex2rgba);

	/* 运行脚本 */
	bRet = luaL_dofile(L, "main.lua");
	if (bRet)
	{
		int stackTop = lua_gettop(L);//获取栈顶的索引值
		int nIdx = 0;
		int nType;

		//显示栈中的元素  
		for (nIdx = stackTop; nIdx > 3; --nIdx)
		{
			nType = lua_type(L, nIdx);
			std::cout << lua_tostring(L, nIdx) << std::endl;
		}

		std::cout << std::endl;
		return 0;
	}

	MSG msg;

	// 主消息循环: 
	while (GetMessage(&msg, nullptr, 0, 0))
	{
		screen_update();

		TranslateMessage(&msg);
		DispatchMessage(&msg);

		lua_getglobal(L, "tick");
		if (!lua_isfunction(L, -1))
			continue;

		lua_pcall(L, 0, 0, 0);
	}

	/* 清除Lua */
	lua_close(L);

	return (int)msg.wParam;
}