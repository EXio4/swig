/* -----------------------------------------------------------------------------
 * arrays_javascript.i
 *
 * These typemaps give more natural support for arrays. The typemaps are not efficient
 * as there is a lot of copying of the array values whenever the array is passed to C/C++
 * from JavaScript and vice versa. The JavaScript array is expected to be the same size as the C array.
 * An exception is thrown if they are not.
 *
 * Example usage:
 * Wrapping:
 *
 *   %include <arrays_javascript.i>
 *   %inline %{
 *       extern int FiddleSticks[3];
 *   %}
 *
 * Use from JavaScript like this:
 *
 *   var fs = [10, 11, 12];
 *   example.FiddleSticks = fs;
 *   fs = example.FiddleSticks;
 * ----------------------------------------------------------------------------- */

%typemap(in) int[], int[ANY]
    ($*1_ltype temp) {
  if (!duk_is_array(ctx, $input)) {
	duk_push_string(ctx,"Expected int array in $input argument");
	goto fail;
  };
  {
  /* duk_get_prop_string(ctx, $input, "length");
  int length = duk_get_int(ctx, -1);
  duk_pop(ctx);*/
    int length = $1_dim0;
    $1  = ($*1_ltype *)malloc(sizeof($*1_ltype) * length);

    // Get each element from array
    for (i = 0; i < length; i++)
    {
      duk_get_prop_index(ctx, $input, i);
      if (!duk_is_int(ctx, -1)) {
          duk_push_string(ctx,"Expected int array in $input argument"); goto fail;
      }
      arg$argnum[i] = duk_get_int(ctx, -1);
      duk_pop(ctx);
    }

  }

}

%typemap(freearg) int[], int[ANY] {
    free($1);
}

%typemap(out) int[], int[ANY] ()
{
  {
    length = $1_dim0;
    duk_idx_t arr_idx = duk_push_array(ctx);
    for (int i=0; i<length; i++) {
	duk_push_int(ctx, $1[i]);
        duk_push_prop_index(ctx, arr_idx, i);
    }
  }
}


%typemap(in) double[], double[ANY]
    ($*1_ltype temp) {
  if (!duk_is_array(ctx, $input)) {
	duk_push_string(ctx,"Expected double array in $input argument");
	goto fail;
  };
  {
  /* duk_get_prop_string(ctx, $input, "length");
  int length = duk_get_int(ctx, -1);
  duk_pop(ctx);*/
    int length = $1_dim0;
    $1  = ($*1_ltype *)malloc(sizeof($*1_ltype) * length);

    // Get each element from array
    for (i = 0; i < length; i++)
    {
      duk_get_prop_index(ctx, $input, i);
      if (!duk_is_double(ctx, -1)) {
          duk_push_string(ctx,"Expected double array in $input argument"); goto fail;
      }
      arg$argnum[i] = duk_get_double(ctx, -1);
      duk_pop(ctx);
    }

  }

}

%typemap(freearg) double[], double[ANY] {
    free($1);
}

%typemap(out) double[], double[ANY] ()
{
  {
    length = $1_dim0;
    duk_idx_t arr_idx = duk_push_array(ctx);
    for (int i=0; i<length; i++) {
	duk_push_double(ctx, $1[i]);
        duk_push_prop_index(ctx, arr_idx, i);
    }
  }
}


