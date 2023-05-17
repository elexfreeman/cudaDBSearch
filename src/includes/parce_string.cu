#ifndef _PARCE_STRING_CU
#define _PARCE_STRING_CU

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "./env.h"

__device__ int cu_strcmp(const char *str_a, const char *str_b, unsigned len = 256)
{
  int match = 0;
  unsigned i = 0;
  unsigned done = 0;
  while ((i < len) && (match == 0) && !done)
  {
    if ((str_a[i] == 0) || (str_b[i] == 0)) done = 1;
    else if (str_a[i] != str_b[i])
    {
      match = i+1;
      if (((int)str_a[i] - (int)str_b[i]) < 0) match = 0 - (i + 1);
    }
    i++;
  }
  return match;
}

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

#endif
