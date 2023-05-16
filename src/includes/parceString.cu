#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void removeSpaces(char* str)
{
  int i, j;
  for (i = 0, j = 0; str[i] != '\0'; i++)
  {
    if (str[i] != ' ')
    {
      str[j++] = str[i];
    }
  }
  str[j] = '\0';
}


void replaceSubstring(char* str, const char* oldSubstr, const char* newSubstr)
{
  int status = 1;
  while(status)
  {
    char* pos = strstr(str, oldSubstr);
    if (pos != NULL)
    {
      int oldSubstrLen = strlen(oldSubstr);
      int newSubstrLen = strlen(newSubstr);
      int diff = newSubstrLen - oldSubstrLen;

      // Make room for the new substring if its length is different from the old substring
      if (diff != 0)
      {
        memmove(pos + newSubstrLen, pos + oldSubstrLen, strlen(pos + oldSubstrLen) + 1);
      }

      // Copy the new substring into the string
      memcpy(pos, newSubstr, newSubstrLen);
    }
    else
    {
      status = 0;
    }
  }
}

void prepareLogicStr(char* logicStr)
{
  removeSpaces(logicStr);
  replaceSubstring(logicStr, "AND", C_AND);
}

