cl /c /Foaspnetcorev2_arm64.obj empty.cpp
cl /c /arm64EC /Foaspnetcorev2_x64.obj empty.cpp

link /lib /machine:arm64 /def:aspnetcorev2_arm64.def /out:aspnetcorev2_arm64.lib
link /lib /machine:x64 /def:aspnetcorev2_x64.def /out:aspnetcorev2_x64.lib

link /dll /noentry /machine:arm64x /defArm64Native:aspnetcorev2_arm64.def /def:aspnetcorev2_x64.def aspnetcorev2_arm64.obj aspnetcorev2_x64.obj /out:aspnetcorev2.dll aspnetcorev2_arm64.lib aspnetcorev2_x64.lib

cl /c /Foaspnetcorev2_outofprocess_arm64.obj empty.cpp
cl /c /arm64EC /Foaspnetcorev2_outofprocess_x64.obj empty.cpp

link /lib /machine:arm64 /def:aspnetcorev2_outofprocess_arm64.def /out:aspnetcorev2_outofprocess_arm64.lib
link /lib /machine:x64 /def:aspnetcorev2_outofprocess_x64.def /out:aspnetcorev2_outofprocess_x64.lib

link /dll /noentry /machine:arm64x /defArm64Native:aspnetcorev2_outofprocess_arm64.def /def:aspnetcorev2_outofprocess_x64.def aspnetcorev2_outofprocess_arm64.obj aspnetcorev2_outofprocess_x64.obj /out:aspnetcorev2_outofprocess.dll aspnetcorev2_outofprocess_arm64.lib aspnetcorev2_outofprocess_x64.lib
