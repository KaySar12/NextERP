#!/usr/bin/env python3

def colorize(text, code):
  """Colorizes text using ANSI escape codes."""
  return f"\033[{code}m{text}\033[0m"

def Show(status, message):
  """Displays a message with a status indicator."""
  colors = {
      0: (colorize("[", "90")+colorize(" OK ", "38;5;154") + colorize("]", "90")),  # Green, Grey
      1: (colorize("[", "90")+colorize(" FAILED ", "91") + colorize("]", "90")),  # Red, Grey
      2: (colorize("[", "90")+colorize(" INFO ", "38;5;154") + colorize("]", "90")),  # Green, Grey
      3: (colorize("[", "90")+colorize(" NOTICE ", "33") + colorize("]", "90")),  # Yellow, Grey
  }
  print(f"{colors.get(status, '')} {message}")
  if status == 1:
    exit(1)

def Warn(message):
  """Displays a warning message in red."""
  print(colorize(message, "91"))

def GreyStart():
  """Starts a grey-colored output."""
  print(colorize("", "90"), end="")

def ColorReset():
  """Resets the output color."""
  print("\033[0m", end="") 