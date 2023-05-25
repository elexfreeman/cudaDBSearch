#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <regex.h>
#include <cuda.h>
#include "../src/includes/env.h"
#include "../src/includes/logic_data.cu"
#include <json-c/json.h>

#define SIZE 3
void doarray(json_object *obj);

void doit(json_object *obj)
{
  json_object_object_foreach(obj, key, val)
  {
    switch (json_object_get_type(val))
    {
    case json_type_array:
      printf("\n%s  \n\n", key);
      doarray(val);
      break;

    case json_type_object:
      printf("\n%s  \n\n", key);
      doit(val);
      break;

    default:
      printf("%s: %s\n", key, json_object_get_string(val));
    }
  }
}

void doarray(json_object *obj)
{
  int temp_n = json_object_array_length(obj);
  const char *str;
  for (int i = 0; i < temp_n; i++)
  {
    switch (json_object_get_type(json_object_array_get_idx(obj, i)))
    {
    case json_type_array:
      doarray(json_object_array_get_idx(obj, i));
      break;

    case json_type_object:
      doit(json_object_array_get_idx(obj, i));
      break;

    default:
      str= json_object_get_string(json_object_array_get_idx(obj, i));
      printf("The value at %i position is: %s\n", i, str);
    }
  }
}

void parceDataItem(struct json_object *obj)
{
  if(!obj) return;
  json_object_object_foreach(obj, key, val)
  {
    switch (json_object_get_type(val))
    {
    case json_type_array:
      printf("\n%s  \n\n", key);
//      doarray(val);
      break;

    case json_type_object:
      printf("\n%s  \n\n", key);
//     doit(val);
      break;

    default:
      printf("%s: %s\n", key, json_object_get_string(val));
    }
  }
}

// NVIDIA P106-100
// Main function
int json_search_data_test()
{

// Declare a variable to store a pointer to the file.

  char* filename = strdup("./src/data.json");
  FILE* file = fopen(filename, "r");
  if (file == NULL)
  {
    fprintf(stderr, "Failed to open file: %s\n", filename);
    return 1;
  }

  // Determine the file size
  fseek(file, 0, SEEK_END);
  long file_size = ftell(file);
  rewind(file);

  // Allocate memory for the file content
  char* content = (char*)malloc(file_size + 1);
  if (content == NULL)
  {
    fprintf(stderr, "Failed to allocate memory for file content.\n");
    fclose(file);
    return 1;
  }

  // Read the file content into memory
  size_t bytes_read = fread(content, 1, file_size, file);
  if (bytes_read != file_size)
  {
    fprintf(stderr, "Error reading file: %s\n", filename);
    free(content);
    fclose(file);
    return 1;
  }
  free(filename);

  // Null-terminate the content
  content[file_size] = '\0';

  // Print the file content
//  printf("File content:\n%s\n", content);


  json_object *root = json_tokener_parse(content);

  printf(" >>>>>>>>>>>>>>>>>>>>>> \n");
  doit(root);


  // Cleanup
  json_object_put(root);
  free(content);
  fclose(file);
  return 0;
}


