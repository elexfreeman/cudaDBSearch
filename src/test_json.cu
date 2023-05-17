#include <stdio.h>
#include <stdlib.h>

//https://github.com/json-c/json-c

// This function parses a JSON string and returns a pointer to a JSON object.
JSON *parse_json(const char *json_string) {
  // Create a JSON object.
  JSON *json = malloc(sizeof(JSON));

  // Initialize the JSON object.
  json->type = JSON_OBJECT;
  json->object = NULL;

  // Parse the JSON string.
  json_parse(json, json_string);

  // Return the JSON object.
  return json;
}

// This function prints the contents of a JSON object.
void print_json(JSON *json) {
  // Check the type of the JSON object.
  switch (json->type) {
    case JSON_OBJECT:
      // Print the object's keys and values.
      for (JSON *key = json->object; key != NULL; key = key->next) {
        printf("%s: %s\n", key->key, key->value);
      }
      break;

    case JSON_ARRAY:
      // Print the array's elements.
      for (JSON *element = json->array; element != NULL; element = element->next) {
        print_json(element);
      }
      break;

    case JSON_STRING:
      // Print the string.
      printf("%s\n", json->string);
      break;

    case JSON_NUMBER:
      // Print the number.
      printf("%f\n", json->number);
      break;

    case JSON_BOOLEAN:
      // Print the boolean value.
      printf("%s\n", json->boolean ? "true" : "false");
      break;

    case JSON_NULL:
      // Print "null".
      printf("null\n");
      break;
  }
}

int main() {
  // Get the JSON string from the user.
  char json_string[1024];
  fgets(json_string, 1024, stdin);

  // Parse the JSON string.
  JSON *json = parse_json(json_string);

  // Print the contents of the JSON object.
  print_json(json);

  // Free the JSON object.
  free(json);

  return 0;
}
