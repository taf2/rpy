/** 
 * Copyright (c) 2008 Todd A. Fisher
 * see LICENSE
 */
#include "ruby.h"
#include "Python.h"

#define DEBUG
#ifdef DEBUG
#define TRACE()  fprintf(stderr, "> %s:%d:%s\n", __FILE__, __LINE__, __FUNCTION__)
#else
#define TRACE() 
#endif

/* ruby 1.9 compat */
#ifndef RSTRING_PTR
#define RSTRING_PTR(str) RSTRING(str)->ptr
#endif

#ifndef RSTRING_LEN
#define RSTRING_LEN(str) RSTRING(str)->len
#endif

static VALUE rb_Py;

static VALUE Python_start(VALUE self)
{
	/* Name the Python interpreter */
	Py_SetProgramName("ruby-embedded");

	/* Initialize the Python interpreter.  Required. */
	Py_Initialize();

  /* load the python yaml library */
  //PyImport_ImportModule("yaml");
  PyRun_SimpleString( "import yaml" );
  return Qnil;
}

static VALUE Python_marshal_with_yaml(VALUE self)
{
  PyObject * module;
  PyObject * dict;
  PyObject * result;

  // send the caller result object to yet another internal global variable
  PyRun_SimpleString( "_rpython_yaml_result = yaml.dump(_rpython_result)" );
  module = PyImport_AddModule("__main__");
  dict = PyModule_GetDict(module);
  result = PyMapping_GetItemString( dict, "_rpython_yaml_result" );
  if( result != NULL ){
    // convert the python result object into yaml
    int len = PyString_Size( result );
    return rb_str_new( PyString_AsString( result ), len );
  }
  return Qnil;
}

static VALUE Python_run(VALUE self, VALUE python, VALUE options )
{
  VALUE serialization = Qnil;

  if( options && !NIL_P(options) ){
    serialization = rb_hash_aref(options,rb_eval_string(":serialize"));
  }

  // call python
  PyRun_SimpleString( RSTRING_PTR(python) );

  if( NIL_P(serialization) ){
    return Qnil;
  }

  return Python_marshal_with_yaml(self);

}

static VALUE Python_stop(VALUE self)
{
  Py_Finalize();
  return Qnil;
}

void Init_rpy()
{
  rb_Py = rb_define_class( "Py", rb_cObject );

  rb_define_singleton_method( rb_Py, "start", Python_start, 0 );
  rb_define_singleton_method( rb_Py, "run", Python_run, 2 );
  rb_define_singleton_method( rb_Py, "stop", Python_stop, 0 );
}
