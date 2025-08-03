#include <stdio.h>
#include <stdint.h>
#include "i19c.h"

int32_t main (int argc, char **argv) {
	if (argc == 1) {
		printf ("Err: set lang path\n");
		return 1;
	}
	I19C *ctx = get_i19c ();
	set_path_i19c (ctx, argv[1]);

	printf ("%s : %s\n", ctx->language, T (ctx, "HELLO"));
	set_lang_i19c (ctx, "tm");
	printf ("%s : %s\n", ctx->language, T (ctx, "HELLO"));
	return 0;
}
