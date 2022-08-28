#pragma once

#include <iostream>

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

struct ShellKeyboardCommand
{
  std::string commandKey;

  bool isWithShiftModifier = false;
  bool isWithCmdCtrlModifier = false;

  bool isWithMacControlModifier = false;
  bool isWithMacOptionModifier = false;
  bool isWithMacCommandModifier = false;

  bool isWitWinControlModifier = false;
  bool isWitWinAltModifier = false;
  bool isWitWinWinModifier = false;
};

struct ShellClipboardData
{
  std::string mimeType = "";
  std::string stringData = "";
  void * otherData = nullptr;
};

struct ShellClipboardInstruction
{
  bool isCopy = false;
  bool isPaste = false;
  bool isCut = false;
  bool isDragAndDrop = false;

  ShellClipboardData data;
};
