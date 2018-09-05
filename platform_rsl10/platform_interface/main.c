#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include "cJSON.h"
#include "queue.h"
#include "dispatch.h"


#define ARRAY_SIZE(array)  sizeof(array) / sizeof(array[0]);

/* *
 * Lists of the command_handler that will be used for dispatching
 * commands. Each sub array in function_map[] will have the
 * command in a string format followed by the function that
 * will be declared and defined in dispatch.h and
 * dispatch.c respectively. Command argument will be the
 * name of the function.
 * */

command_handler command_handlers[] = {
        {"request_platform_id", request_platform_id},
        {"request_echo", request_echo},
        {"general_purpose", general_purpose},
};

/* ----------------------------------------------------------------------------
 * Function      : void list_init();
 * ----------------------------------------------------------------------------
 * Description   : Initialize the list and pushes the commands to the linked list
 *                 by calling push function and passing the json command along
 *                 with the list as a second arguments. Then, the execute function
 *                 will be called to execute the commands on the queue. Commands will
 *                 be executed in order of queue (FIFO).
 * ------------------------------------------------------------------------- */
void list_init(){

    int command_handlers_size = ARRAY_SIZE(command_handlers);

    linked_list *list = (linked_list*)malloc(sizeof(linked_list));

    list->head = NULL;
    list->tail = NULL;

    push("{\"cmd\":\"request_platform_id\"}", list);
    push("{\"cmd\" : \"whatever\", \"payload\" : {\"number_argument\" : 1, \"string_argument\" : \"0x000000FF\"}}",
         list);
    push("{\"cmd\" : \"general_purpose\", \"payload\" : {\"number_argument\" : 1, \"string_argument\" : \"0x000000FF\"}}",
         list);
    push("{\"cmd\":\"request_echo\"}", list);
    push("Hello world!", list);

    print_list(list);

    execute(list, command_handlers, command_handlers_size);

}

int main( )
{
    list_init();


    return 0;
}
