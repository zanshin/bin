#!/bin/sh
(head $1 && echo "---" && tail $1) | less
