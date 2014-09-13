#!/bin/sh
echo Testing 5.1
exec lua51 syntaxcheck

echo Testing 5.2
exec lua52 syntaxcheck

echo Testing 5.3
exec lua53 syntaxcheck

echo Testing JIT
exec luaj syntaxcheck

pause