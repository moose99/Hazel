workspace "Hazel"
	architecture "x64"

	configurations
	{
		"Debug",
		"Release",		-- faster debug
		"Dist"			-- for release, no logging, stripped, etc
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"		-- debug-windows-x64

project "Hazel"
	location "Hazel"
	kind "SharedLib"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")	-- bin/debug-windows-x64/Hazel
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")	-- bin-int/debug-windows-x64/Hazel (intermediate files)

	-- specify all cpp and h files recursively below the project
	files 
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
	}

	-- specify additional include dirs
	includedirs 
	{
		"%{prj.name}/vendor/spdlog/include"
	}

	-- windows specific settings and defines
	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

	defines
	{
		"HZ_PLATFORM_WINDOWS",
		"HZ_BUILD_DLL"
		-- "_WINDLL"
	}

	-- post-build, copy Hazel dll to the Sandbox directory
	postbuildcommands
	{
		("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox")
	}

	-- configuration specific settings
	filter "configurations:Debug"
		defines "HZ_DEBUG"
		symbols "On"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		optimize "On"

-- for combining filters...
--	filters { "system:windows", "configurations:Release" }

-- SANDBOX
project "Sandbox"
	location "Sandbox"
	kind "ConsoleApp"
	language "C++"

	targetdir ("bin/" .. outputdir .. "/%{prj.name}")	-- bin/debug-windows-x64/Hazel
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")	-- bin-int/debug-windows-x64/Hazel (intermediate files)

	-- specify all cpp and h files recursively below the project
	files 
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
	}

	-- specify additional include dirs
	includedirs 
	{
		"Hazel/vendor/spdlog/include",
		"Hazel/src"
	}

	links 
	{
		"Hazel"
	}

	-- windows specific settings and defines
	filter "system:windows"
		cppdialect "C++17"
		staticruntime "On"
		systemversion "latest"

	defines
	{
		"HZ_PLATFORM_WINDOWS",
	}

		-- configuration specific settings
	filter "configurations:Debug"
		defines "HZ_DEBUG"
		symbols "On"

	filter "configurations:Release"
		defines "HZ_RELEASE"
		optimize "On"

	filter "configurations:Dist"
		defines "HZ_DIST"
		optimize "On"