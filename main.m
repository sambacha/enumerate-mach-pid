/**
 * The main entry point of the application.
 *
 * This code sets up an XPC connection to the "com.apple.CodeSigningHelper" service,
 * and then sends a series of messages to the service to fetch data. The fetched data
 * is then printed to the console.
 *
 * @param argc The number of command-line arguments.
 * @param argv An array of C-style strings containing the command-line arguments.
 * @return The exit status of the application.
 */
#import <Foundation/Foundation.h>

char * service_name = "com.apple.CodeSigningHelper";

int main(int argc, const char **argv) {
    xpc_connection_t conn = xpc_connection_create_mach_service(service_name, NULL, 0 );
    xpc_connection_set_event_handler(conn, ^(xpc_object_t object) {
    });
    xpc_connection_resume(conn);


    int i;
    for (i = 0; i < 99999; i++) {
        xpc_object_t message = xpc_dictionary_create(NULL, NULL, 0);
        xpc_dictionary_set_string(message, "command", "fetchData");
        xpc_dictionary_set_int64(message, "pid", i);

        xpc_connection_send_message_with_reply(conn, message, NULL, ^(xpc_object_t object) {
            size_t sz = 0;
            //  assigning a const void * _Nullable to a void *, which discards the const qualifier
            const void *data = xpc_dictionary_get_data(object, "bundleURL", &sz);
            if (sz != 0) {
                printf("%s\n", (char*)data);
            }
            
            if (i == 99998) {
                exit(0);
            }
        });
    }

    // dispatch_main();
}
