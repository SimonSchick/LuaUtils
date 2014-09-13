@echo off

echo 5.1
call lua51 -l syntaxcheck
echo 5.2
call lua52 -l syntaxcheck
echo 5.3
call lua53 -l syntaxcheck
echo JIT
call luaj -l syntaxcheck
pause