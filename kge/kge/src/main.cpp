#include <iostream>

#include<windows.h>

extern "C"
{
#include "lua/lua.h"
#include "lua/lualib.h"
#include "lua/lauxlib.h"
}

HINSTANCE g_hInst;                                // 当前实例
HWND g_hWnd;

/* 指向Lua解释器的指针 */
lua_State* L;

static int draw_pixel(lua_State *L)
{
	/* 得到参数个数 */
	int n = lua_gettop(L);

	if (n != 5)
		return 0;

	double x = lua_tonumber(L, 1);
	double y = lua_tonumber(L, 2);
	double r = lua_tonumber(L, 3);
	double g = lua_tonumber(L, 4);
	double b = lua_tonumber(L, 5);

	HDC g_hdc = GetWindowDC(g_hWnd);

	SetPixel(g_hdc, (int)x, (int)y, RGB(r, g, b));

	return 0;
}


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

int main(int argc, char* argv[])
{

	L = lua_open();

	/* 载入Lua基本库 */
	luaL_openlibs(L);

	//加载Lua文件  
	int bRet = luaL_loadfile(L, "config.lua");
	if (bRet)
	{
		std::cout << "load file error" << std::endl;
		return 0;
	}

	bRet = lua_pcall(L, 0, 0, 0);
	if (bRet)
	{
		std::cout << "pcall error" << std::endl;
		return 0;
	}

	lua_getglobal(L, "win_title");
	const char* win_title = lua_tostring(L, -1);

	lua_getglobal(L, "win_width");
	double width = lua_tonumber(L, -1);

	lua_getglobal(L, "win_height");
	double height = lua_tonumber(L, -1);

	HINSTANCE hInstance = ::GetModuleHandle(NULL);

	MyRegisterClass(hInstance, win_title);

	// 执行应用程序初始化: 
	if (!InitInstance(hInstance, SW_SHOW, win_title, (int)width, (int)height))
	{
		return 0;
	}

	//HACCEL hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_WIN32TEST));

	/* 注册函数 */
	lua_register(L, "draw_pixel", draw_pixel);
	/* 运行脚本 */
	luaL_dofile(L, "main.lua");

	MSG msg;

	// 主消息循环: 
	while (GetMessage(&msg, nullptr, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	/* 清除Lua */
	lua_close(L);

	return (int)msg.wParam;
}