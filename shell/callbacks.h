#pragma once

struct ShellMouseInstruction
{
  int button = 0;
  float left = 0.0;
  float top = 0.0;
  bool isDown = false;
  bool isUp = false;
  bool isMove = false;
};

struct ShellKeyboardKeyInstruction
{
  int code = 0;
  bool isDown = false;
  bool isUp = false;
};

struct ShellKeyboardMoveInstruction
{
  // Don't change the order of these, they have to match what's in fluxe/views/Externs.hx
  bool isRight = false;
  bool isLeft = false;
  bool isForwards = false;
  bool isBackwards = false;
  bool isUp = false;
  bool isDown = false;

  bool isAll = false;
  bool isDocument = false;
  bool isPage = false;
  bool isParagraph = false;
  bool isLine = false;
  bool isWord = false;

  bool isDelete = false;
  bool isSelect = false;
  bool isScroll = false;

  bool isTab = false;
  bool isEnter = false;
  bool isCopy = false;
  bool isPaste = false;
};
