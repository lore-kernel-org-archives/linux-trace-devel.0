Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2E8C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 02:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D8BA61411
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 02:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhDUCOP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 22:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233824AbhDUCOP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 22:14:15 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC1A613FA;
        Wed, 21 Apr 2021 02:13:42 +0000 (UTC)
Date:   Tue, 20 Apr 2021 22:13:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/9] trace-cruncher: Refactor the part that wraps ftrace
Message-ID: <20210420221340.65c89491@oasis.local.home>
In-Reply-To: <20210419130140.59140-2-y.karadz@gmail.com>
References: <20210419130140.59140-1-y.karadz@gmail.com>
        <20210419130140.59140-2-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 19 Apr 2021 16:01:32 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> This is the first patch from a patch-set that aims to refactor
> trace-cruncher completely. The goal it to be able to build the

General comment. Try to avoid mentioning "first patch from a patch
set", as that becomes meaningless in git history. Three years from now,
a git blame comes to this patch, that "first patch in a patch set"
becomes meaningless. Basically, when writing a change log, you want to
think, "What do I want this commit log to say when I read it by itself
three years from now?" ;-)

> project as a native Python package, which contains several
> sub-packages implemented as C extensions via the Python's C API.
> In this patch the part of the interface that relies on libtracefs,
> libtraceevent (and libtracecmd in the future) gets re-implemented
> as an extension called "tracecruncher.ftracepy". Note that this
> new extension has a stand-alone build that is completely decoupled
> from the existing build system used by trace-cruncher.

The way I would say it is this:

"In order to be able to bulid the project as a native Python package,
which contains several sub-packages implement as C extensions via the
Pythons' C API, the part of the interface that relies on libtracefs,
libtraceevent (and libtracecmd in the future) needs to be
re-implemented as an extension called "tracecruncher.ftracepy". Note
that..."

That is, try to word it where as disjoint from the rest of the series.

> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  setup.py             |   68 +++
>  src/common.h         |  100 +++
>  src/ftracepy-utils.c | 1367 ++++++++++++++++++++++++++++++++++++++++++
>  src/ftracepy-utils.h |  127 ++++
>  src/ftracepy.c       |  262 ++++++++
>  5 files changed, 1924 insertions(+)
>  create mode 100644 setup.py
>  create mode 100644 src/common.h
>  create mode 100644 src/ftracepy-utils.c
>  create mode 100644 src/ftracepy-utils.h
>  create mode 100644 src/ftracepy.c
> 
> diff --git a/setup.py b/setup.py
> new file mode 100644
> index 0000000..450f043
> --- /dev/null
> +++ b/setup.py
> @@ -0,0 +1,68 @@
> +#!/usr/bin/env python3
> +
> +"""
> +SPDX-License-Identifier: LGPL-2.1
> +
> +Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> +"""
> +
> +from setuptools import setup, find_packages
> +from distutils.core import Extension
> +from Cython.Build import cythonize
> +
> +import pkgconfig as pkg
> +
> +
> +def third_party_paths():
> +    pkg_traceevent = pkg.parse('libtraceevent')
> +    pkg_ftracepy = pkg.parse('libtracefs')
> +    pkg_tracecmd = pkg.parse('libtracecmd')
> +
> +    include_dirs = []
> +    include_dirs.extend(pkg_traceevent['include_dirs'])
> +    include_dirs.extend(pkg_ftracepy['include_dirs'])
> +    include_dirs.extend(pkg_tracecmd['include_dirs'])
> +
> +    library_dirs = []
> +    library_dirs.extend(pkg_traceevent['library_dirs'])
> +    library_dirs.extend(pkg_ftracepy['library_dirs'])
> +    library_dirs.extend(pkg_tracecmd['library_dirs'])
> +    library_dirs = list(set(library_dirs))
> +
> +    return include_dirs, library_dirs
> +
> +include_dirs, library_dirs = third_party_paths()
> +
> +def extension(name, sources, libraries):
> +    runtime_library_dirs = library_dirs
> +    runtime_library_dirs.extend('$ORIGIN')
> +    return Extension(name, sources=sources,
> +                           include_dirs=include_dirs,
> +                           library_dirs=library_dirs,
> +                           runtime_library_dirs=runtime_library_dirs,
> +                           libraries=libraries,
> +                           )
> +
> +def main():
> +    module_ft  = extension(name='tracecruncher.ftracepy',
> +                            sources=['src/ftracepy.c', 'src/ftracepy-utils.c'],
> +                            libraries=['traceevent', 'tracefs'])
> +
> +    setup(name='tracecruncher',
> +          version='0.1.0',
> +          description='NumPy based interface for accessing tracing data in Python.',
> +          author='Yordan Karadzhov (VMware)',
> +          author_email='y.karadz@gmail.com',
> +          url='https://github.com/vmware/trace-cruncher',
> +          license='LGPL-2.1',
> +          packages=find_packages(),
> +          ext_modules=[module_ft],
> +          classifiers=[
> +              'Development Status :: 3 - Alpha',
> +              'Programming Language :: Python :: 3',
> +              ]
> +          )
> +
> +
> +if __name__ == '__main__':
> +    main()
> diff --git a/src/common.h b/src/common.h
> new file mode 100644
> index 0000000..71ba3fd
> --- /dev/null
> +++ b/src/common.h
> @@ -0,0 +1,100 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> +#ifndef _TC_COMMON_H
> +#define _TC_COMMON_H
> +
> +// C
> +#include <stdbool.h>
> +#include <string.h>
> +
> +#define TRACECRUNCHER_ERROR	tracecruncher_error
> +#define KSHARK_ERROR		kshark_error
> +#define TEP_ERROR		tep_error
> +#define TFS_ERROR		tfs_error
> +
> +#define KS_INIT_ERROR \
> +	PyErr_SetString(KSHARK_ERROR, "libshark failed to initialize");
> +
> +#define MEM_ERROR \
> +	PyErr_SetString(TRACECRUNCHER_ERROR, "failed to allocate memory");
> +
> +#define NO_ARG	"none"

If you defined NO_ARG as:

static const char *NO_ARG = "/NONE/";

then you could test for equal below, as well as not worry that someone
might name their instance "none" and screw this up.

> +
> +static inline bool is_all(const char *arg)
> +{
> +	return strcmp(arg, "all") == 0 ||
> +	       strcmp(arg, "All") == 0 ||
> +	       strcmp(arg, "ALL") == 0;

If you want to make this truly case insensitive:
{
	const char all[] = "all";
	const char *p = &all[0];

	for (; *arg; arg++, p++) {
		if (tolower(*arg) != *p)
			return false;
	}
	return !(*p);
}

> +}
> +
> +static inline bool is_no_arg(const char *arg)
> +{
> +	return arg[0] == '\0' || strcmp(arg, NO_ARG) == 0;

If NO_ARG is a const char *, then you could have this be:

	return arg[0] == '\0' || arg == NO_ARG;


> +}
> +
> +static inline bool is_set(const char *arg)
> +{
> +	return !(is_all(arg) || is_no_arg(arg));
> +}
> +
> +static inline void no_free()
> +{
> +}
> +
> +#define NO_FREE		no_free
> +
> +#define STR(x) #x
> +
> +#define MAKE_TYPE_STR(x) STR(traceevent.x)
> +
> +#define MAKE_DIC_STR(x) STR(libtraceevent x object)
> +
> +#define C_OBJECT_WRAPPER_DECLARE(c_type, py_type)				\
> +	typedef struct {							\
> +	PyObject_HEAD								\
> +	struct c_type *ptrObj;							\
> +} py_type;									\
> +PyObject *py_type##_New(struct c_type *evt_ptr);				\
> +bool py_type##TypeInit();							\
> +
> +#define  C_OBJECT_WRAPPER(c_type, py_type, ptr_free)				\
> +static PyTypeObject py_type##Type = {						\
> +	PyVarObject_HEAD_INIT(NULL, 0) MAKE_TYPE_STR(c_type)			\
> +};										\
> +PyObject *py_type##_New(struct c_type *evt_ptr)					\
> +{										\
> +	py_type *newObject;							\
> +	newObject = PyObject_New(py_type, &py_type##Type);			\
> +	newObject->ptrObj = evt_ptr;						\
> +	return (PyObject *) newObject;						\
> +}										\
> +static int py_type##_init(py_type *self, PyObject *args, PyObject *kwargs)	\
> +{										\
> +	self->ptrObj = NULL;							\
> +	return 0;								\
> +}										\
> +static void py_type##_dealloc(py_type *self)					\
> +{										\
> +	ptr_free(self->ptrObj);							\
> +	Py_TYPE(self)->tp_free(self);						\
> +}										\
> +bool py_type##TypeInit()							\
> +{										\
> +	py_type##Type.tp_new = PyType_GenericNew;				\
> +	py_type##Type.tp_basicsize = sizeof(py_type);				\
> +	py_type##Type.tp_init = (initproc) py_type##_init;			\
> +	py_type##Type.tp_dealloc = (destructor) py_type##_dealloc;		\
> +	py_type##Type.tp_flags = Py_TPFLAGS_DEFAULT;				\
> +	py_type##Type.tp_doc = MAKE_DIC_STR(c_type);				\
> +	py_type##Type.tp_methods = py_type##_methods;				\
> +	if (PyType_Ready(&py_type##Type) < 0)					\
> +		return false;							\
> +	Py_INCREF(&py_type##Type);						\
> +	return true;								\
> +}										\
> +
> +#endif
> diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
> new file mode 100644
> index 0000000..d026688
> --- /dev/null
> +++ b/src/ftracepy-utils.c
> @@ -0,0 +1,1367 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> + */
> +
> +#ifndef _GNU_SOURCE
> +/** Use GNU C Library. */
> +#define _GNU_SOURCE
> +#endif // _GNU_SOURCE
> +
> +// C
> +#include <search.h>
> +#include <string.h>
> +#include <sys/wait.h>
> +
> +// trace-cruncher
> +#include "ftracepy-utils.h"
> +
> +int tep_vwarning(const char *name, const char *fmt, va_list ap)
> +{
> +	return 0;
> +}
> +
> +static void *instance_root = NULL;
> +PyObject *TFS_ERROR = NULL;
> +PyObject *TEP_ERROR = NULL;
> +PyObject *TRACECRUNCHER_ERROR = NULL;

Static and global variables are defined as zero or NULL, hence you do
not need to initialized them to NULL or zero.

> +
> +PyObject *PyTepRecord_time(PyTepRecord* self)
> +{
> +	return PyLong_FromLongLong(self->ptrObj->ts);
> +}
> +
> +PyObject *PyTepRecord_cpu(PyTepRecord* self)
> +{
> +	return PyLong_FromLong(self->ptrObj->cpu);
> +}
> +
> +PyObject *PyTepEvent_name(PyTepEvent* self)
> +{
> +	return PyUnicode_FromString(self->ptrObj->name);
> +}
> +
> +PyObject *PyTepEvent_id(PyTepEvent* self)
> +{
> +	return PyLong_FromLong(self->ptrObj->id);
> +}
> +
> +PyObject *PyTepEvent_field_names(PyTepEvent* self)
> +{
> +	struct tep_format_field *field, **fields;
> +	struct tep_event *event = self->ptrObj;
> +	int i = 0, nr_fields;
> +	PyObject *list;
> +
> +	nr_fields= event->format.nr_fields + event->format.nr_common;
> +	list = PyList_New(nr_fields);
> +
> +	/* Get all common fields. */
> +	fields = tep_event_common_fields(event);
> +	if (!fields) {
> +		PyErr_Format(TEP_ERROR,
> +			     "Failed to get common fields for event \'%s\'",
> +			     self->ptrObj->name);
> +		return NULL;
> +	}
> +
> +	for (field = *fields; field; field = field->next)
> +		PyList_SET_ITEM(list, i++, PyUnicode_FromString(field->name));
> +	free(fields);
> +
> +	/* Add all unique fields. */
> +	fields = tep_event_fields(event);
> +	if (!fields) {
> +		PyErr_Format(TEP_ERROR,
> +			     "Failed to get fields for event \'%s\'",
> +			     self->ptrObj->name);
> +		return NULL;
> +	}
> +
> +	for (field = *fields; field; field = field->next)
> +		PyList_SET_ITEM(list, i++, PyUnicode_FromString(field->name));
> +	free(fields);
> +
> +	return list;
> +}
> +
> +PyObject *PyTepEvent_parse_record_field(PyTepEvent* self, PyObject *args,
> +							  PyObject *kwargs)
> +{
> +	int mumber_field_mask = TEP_FIELD_IS_SIGNED |

What's a "mumber"?

> +				TEP_FIELD_IS_LONG |
> +				TEP_FIELD_IS_FLAG;
> +	struct tep_format_field *field;
> +	const char *field_name;
> +	PyTepRecord *record;
> +
> +	static char *kwlist[] = {"record", "field", NULL};
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"Os",
> +					kwlist,
> +					&record,
> +					&field_name)) {
> +		return NULL;
> +	}
> +
> +	field = tep_find_field(self->ptrObj, field_name);
> +	if (!field)
> +		field = tep_find_common_field(self->ptrObj, field_name);
> +
> +	if (!field) {
> +		PyErr_Format(TEP_ERROR,
> +			     "Failed to find field \'%s\' in event \'%s\'",
> +			     field_name, self->ptrObj->name);
> +		return NULL;
> +	}
> +
> +	if (field->flags & TEP_FIELD_IS_STRING) {
> +		char *val = record->ptrObj->data + field->offset;
> +
> +		return PyUnicode_FromString(val);
> +	} else if (field->flags & mumber_field_mask) {
> +		unsigned long long val;
> +
> +		tep_read_number_field(field, record->ptrObj->data, &val);
> +		return PyLong_FromLong(val);
> +	}
> +
> +	PyErr_Format(TEP_ERROR,
> +		     "Unsupported field format \"%li\" (TODO: implement this)",
> +		     field->flags);
> +	return NULL;
> +}
> +
> +PyObject *PyTepEvent_get_pid(PyTepEvent* self, PyObject *args,
> +					       PyObject *kwargs)
> +{
> +	static char *kwlist[] = {"record", NULL};
> +	const char *field_name = "common_pid";
> +	struct tep_format_field *field;
> +	unsigned long long val = 0;
> +	PyTepRecord *record;
> +
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"O",
> +					kwlist,
> +					&record)) {
> +		return NULL;
> +	}
> +
> +	field = tep_find_common_field(self->ptrObj, field_name);
> +	if (!field) {
> +		PyErr_Format(TEP_ERROR,
> +			     "Failed to find field \'s\' in event \'%s\'",
> +			     field_name, self->ptrObj->name);
> +		return NULL;
> +	}
> +
> +	tep_read_number_field(field, record->ptrObj->data, &val);
> +
> +	return PyLong_FromLong(val);
> +}
> +
> +static const char **get_arg_list(PyObject *py_list)
> +{
> +	const char **argv = NULL;
> +	PyObject *arg_py;
> +	int i, n;
> +
> +	if (!PyList_CheckExact(py_list))
> +		goto fail;
> +
> +	n = PyList_Size(py_list);
> +	argv = calloc(n + 1, sizeof(*argv));
> +	for (i = 0; i < n; ++i) {
> +		arg_py = PyList_GetItem(py_list, i);
> +		if (!PyUnicode_Check(arg_py))
> +			goto fail;
> +
> +		argv[i] = PyUnicode_DATA(arg_py);
> +	}
> +
> +	return argv;
> +
> + fail:
> +	PyErr_SetString(TRACECRUNCHER_ERROR,
> +			"Failed to parse argument list.");
> +	free(argv);
> +	return NULL;
> +}
> +
> +PyObject *PyTep_init_local(PyTep *self, PyObject *args,
> +					PyObject *kwargs)
> +{
> +	static char *kwlist[] = {"dir", "systems", NULL};
> +	struct tep_handle *tep = NULL;
> +	PyObject *system_list = NULL;
> +	const char *dir_str;
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "s|O",
> +					 kwlist,
> +					 &dir_str,
> +					 &system_list)) {
> +		return NULL;
> +	}
> +
> +	if (system_list) {
> +		const char **sys_names = get_arg_list(system_list);
> +
> +		if (sys_names) {
> +			tep = tracefs_local_events_system(dir_str, sys_names);
> +			free(sys_names);
> +		}
> +	} else {
> +		tep = tracefs_local_events(dir_str);
> +	}
> +
> +	if (!tep) {
> +		PyErr_Format(TFS_ERROR,
> +			     "Failed to get local events from \'%s\'.",
> +			     dir_str);

I wonder if that's the right message if the get_arg_list() failed.

> +		return NULL;
> +	}
> +
> +	tep_free(self->ptrObj);
> +	self->ptrObj = tep;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyTep_get_event(PyTep *self, PyObject *args,
> +				       PyObject *kwargs)
> +{
> +	static char *kwlist[] = {"system", "name", NULL};
> +	const char *system, *event_name;
> +	struct tep_event *event;
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "ss",
> +					 kwlist,
> +					 &system,
> +					 &event_name)) {
> +		return NULL;
> +	}
> +
> +	event = tep_find_event_by_name(self->ptrObj, system, event_name);
> +
> +	return PyTepEvent_New(event);
> +}
> +
> +static bool check_file(struct tracefs_instance *instance, const char *file)
> +{
> +	if (!tracefs_file_exists(instance, file)) {
> +		PyErr_Format(TFS_ERROR, "File %s does not exist.", file);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool check_dir(struct tracefs_instance *instance, const char *dir)
> +{
> +	if (!tracefs_dir_exists(instance, dir)) {
> +		PyErr_Format(TFS_ERROR, "Directory %s does not exist.", dir);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static int write_to_file(struct tracefs_instance *instance,
> +			 const char *file,
> +			 const char *val)
> +{
> +	int size;
> +
> +	if (!check_file(instance, file))
> +		return -1;
> +
> +	size = tracefs_instance_file_write(instance, file, val);
> +	if (size <= 0)
> +		PyErr_Format(TFS_ERROR, "Can not write to file %s", file);
> +
> +	return size;
> +}
> +
> +static int read_from_file(struct tracefs_instance *instance,
> +			  const char *file,
> +			  char **val)
> +{
> +	int size;
> +
> +	if (!check_file(instance, file))
> +		return -1;
> +
> +	*val = tracefs_instance_file_read(instance, file, &size);
> +	if (size <= 0)
> +		PyErr_Format(TFS_ERROR, "Can not read from file %s", file);
> +
> +	return size;
> +}
> +
> +static inline void trim_new_line(char *val)
> +{
> +	val[strlen(val) - 1] = '\0';
> +}
> +
> +static bool write_to_file_and_chack(struct tracefs_instance *instance,

  "chack"?

> +				    const char *file,
> +				    const char *val)
> +{
> +	char *read_val;
> +	int ret;
> +
> +	if (write_to_file(instance, file, val) <= 0)
> +		return false;
> +
> +	if (read_from_file(instance, file, &read_val) <= 0)
> +		return false;
> +
> +	trim_new_line(read_val);
> +	ret = strcmp(read_val, val);
> +	free(read_val);
> +
> +	return ret == 0 ? true : false;

	return !ret;

?

> +}
> +
> +static PyObject *tfs_list2py_list(char **list)
> +{
> +	PyObject *py_list = PyList_New(0);
> +	int i;
> +
> +	for (i = 0; list && list[i]; i++)
> +		PyList_Append(py_list, PyUnicode_FromString(list[i]));
> +
> +	tracefs_list_free(list);
> +
> +	return py_list;
> +}
> +
> +struct instance_wrapper {
> +	struct tracefs_instance *ptr;
> +	const char *name;
> +};
> +
> +const char *instance_wrapper_get_name(const struct instance_wrapper *iw)
> +{
> +	if (!iw->ptr)
> +		return iw->name;
> +
> +	return tracefs_instance_get_name(iw->ptr);
> +}
> +
> +static int instance_compare(const void *a, const void *b)
> +{
> +	const struct instance_wrapper *iwa, *iwb;
> +
> +	iwa = (const struct instance_wrapper *) a;
> +	iwb = (const struct instance_wrapper *) b;
> +
> +	return strcmp(instance_wrapper_get_name(iwa),
> +		      instance_wrapper_get_name(iwb));
> +}
> +
> +void instance_wrapper_free(void *ptr)
> +{
> +	struct instance_wrapper *iw;
> +	if (!ptr)
> +		return;
> +
> +	iw = ptr;
> +	if (iw->ptr)
> +		tracefs_instance_destroy(iw->ptr);
> +
> +	free(ptr);
> +}
> +
> +static void destroy_all_instances(void)
> +{
> +	tdestroy(instance_root, instance_wrapper_free);
> +	instance_root = NULL;
> +}
> +
> +static struct tracefs_instance *find_instance(const char *name)
> +{
> +	struct instance_wrapper iw, **iw_ptr;
> +	if (!is_set(name))
> +		return NULL;
> +
> +	if (!tracefs_instance_exists(name)) {
> +		PyErr_Format(TFS_ERROR, "Trace instance \'%s\' does not exist.",
> +			     name);
> +		return NULL;
> +	}
> +
> +	iw.ptr = NULL;
> +	iw.name = name;
> +	iw_ptr = tfind(&iw, &instance_root, instance_compare);
> +	if (!iw_ptr || !(*iw_ptr) || !(*iw_ptr)->ptr ||
> +	    strcmp(tracefs_instance_get_name((*iw_ptr)->ptr), name) != 0) {
> +		PyErr_Format(TFS_ERROR, "Unable to find trace instances \'%s\'.",
> +			     name);
> +		return NULL;
> +	}
> +
> +	return (*iw_ptr)->ptr;
> +}
> +
> +bool get_optional_instance(const char *instance_name,
> +			   struct tracefs_instance **instance)
> +{
> +	*instance = NULL;
> +	if (is_set(instance_name)) {
> +		*instance = find_instance(instance_name);
> +		if (!instance) {
> +			PyErr_Format(TFS_ERROR,
> +				     "Failed to find instance \'%s\'.",
> +				     instance_name);
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +bool get_instance_from_arg(PyObject *args, PyObject *kwargs,
> +			   struct tracefs_instance **instance)
> +{
> +	const char *instance_name;
> +
> +	static char *kwlist[] = {"instance", NULL};
> +	instance_name = NO_ARG;

As stated above, if NO_ARG was a const char *, then you don't need to
worry about instances called "none".

> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"|s",
> +					kwlist,
> +					&instance_name)) {
> +		return false;
> +	}
> +
> +	if (!get_optional_instance(instance_name, instance))
> +		return false;
> +
> +	return true;
> +}
> +
> +PyObject *PyFtrace_dir(PyObject *self)
> +{
> +	return PyUnicode_FromString(tracefs_tracing_dir());
> +}
> +
> +PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
> +						   PyObject *kwargs)
> +{
> +	struct instance_wrapper *iw, **iw_ptr;
> +	struct tracefs_instance *instance;
> +	char *name = NO_ARG;
> +
> +	static char *kwlist[] = {"name", NULL};
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"s",
> +					kwlist,
> +					&name)) {
> +		return NULL;
> +	}
> +
> +	if (!is_set(name)) {
> +		PyErr_Format(TFS_ERROR,
> +			     "\'%s\' is not a valid name for trace instance.",
> +			     name);
> +		return NULL;
> +	}
> +
> +	instance = tracefs_instance_create(name);
> +	if (!instance ||
> +	    !tracefs_instance_exists(name) ||
> +	    !tracefs_instance_is_new(instance)) {
> +		PyErr_Format(TFS_ERROR,
> +			     "Failed to create new trace instance \'%s\'.",
> +			     name);
> +		return NULL;
> +	}
> +
> +	iw = malloc(sizeof(*iw));

Need to check if malloc fails.

> +	iw->ptr = instance;
> +	iw_ptr = tsearch(iw, &instance_root, instance_compare);
> +	if (!iw_ptr || !(*iw_ptr) || !(*iw_ptr)->ptr ||
> +	    strcmp(tracefs_instance_get_name((*iw_ptr)->ptr), name) != 0) {
> +		PyErr_Format(TFS_ERROR,
> +			     "Failed to store new trace instance \'%s\'.",
> +			     name);
> +		tracefs_instance_destroy(instance);
> +		tracefs_instance_free(instance);
> +		return NULL;
> +	}
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyFtrace_destroy_instance(PyObject *self, PyObject *args,
> +						    PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +	struct instance_wrapper iw;
> +	char *name;
> +
> +	static char *kwlist[] = {"name", NULL};
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"s",
> +					kwlist,
> +					&name)) {
> +		return NULL;
> +	}
> +
> +	if (is_all(name)) {
> +		destroy_all_instances();
> +		Py_RETURN_NONE;
> +	}
> +
> +	instance = find_instance(name);
> +	if (!instance) {
> +		PyErr_Format(TFS_ERROR,
> +			     "Unable to destroy trace instances \'%s\'.",
> +			     name);
> +		return NULL;
> +	}
> +
> +	iw.ptr = NULL;
> +	iw.name = name;
> +	tdelete(&iw, &instance_root, instance_compare);
> +
> +	tracefs_instance_destroy(instance);
> +	tracefs_instance_free(instance);
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *instance_list;
> +
> +static void instance_action(const void *nodep, VISIT which, int depth)
> +{
> +	struct instance_wrapper *iw = *( struct instance_wrapper **) nodep;
> +	const char *name;
> +
> +	switch(which) {
> +	case preorder:
> +	case endorder:
> +		break;
> +
> +	case postorder:
> +	case leaf:
> +		name = tracefs_instance_get_name(iw->ptr);
> +		PyList_Append(instance_list, PyUnicode_FromString(name));
> +		break;
> +	}
> +}
> +
> +PyObject *PyFtrace_get_all_instances(PyObject *self)
> +{
> +	instance_list = PyList_New(0);
> +	twalk(instance_root, instance_action);
> +
> +	return instance_list;
> +}
> +
> +PyObject *PyFtrace_destroy_all_instances(PyObject *self)
> +{
> +	destroy_all_instances();
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyFtrace_instance_dir(PyObject *self, PyObject *args,
> +						PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +
> +	if (!get_instance_from_arg(args, kwargs, &instance))
> +		return NULL;
> +
> +	return PyUnicode_FromString(tracefs_instance_get_dir(instance));
> +}
> +
> +PyObject *PyFtrace_available_tracers(PyObject *self, PyObject *args,
> +						     PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +	char **list;
> +
> +	if (!get_instance_from_arg(args, kwargs, &instance))
> +		return NULL;
> +
> +	list = tracefs_tracers(tracefs_instance_get_dir(instance));
> +	if (!list)
> +		return NULL;
> +
> +	return tfs_list2py_list(list);
> +}
> +
> +PyObject *PyFtrace_set_current_tracer(PyObject *self, PyObject *args,
> +						      PyObject *kwargs)
> +{
> +	const char *file = "current_tracer", *tracer, *instance_name;
> +	struct tracefs_instance *instance;
> +
> +	static char *kwlist[] = {"tracer", "instance", NULL};
> +	tracer = instance_name = NO_ARG;
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"|ss",
> +					kwlist,
> +					&tracer,
> +					&instance_name)) {
> +		return NULL;
> +	}
> +
> +	if (!get_optional_instance(instance_name, &instance))
> +		return NULL;
> +
> +	if (is_set(tracer) &&
> +	    strcmp(tracer, "nop") != 0) {
> +		char **all_tracers =
> +			tracefs_tracers(tracefs_instance_get_dir(instance));
> +		int i;
> +
> +		for (i = 0; all_tracers && all_tracers[i]; i++) {
> +			if (!strcmp(all_tracers[i], tracer))
> +				break;
> +		}
> +
> +		if (!all_tracers || !all_tracers[i]) {
> +			PyErr_Format(TFS_ERROR,
> +				     "Tracer \'%s\' is not available.",
> +				     tracer);
> +			return NULL;
> +		}
> +	} else if (!is_set(tracer)) {
> +		tracer = "nop";
> +	}
> +
> +	if (!write_to_file_and_chack(instance, file, tracer)) {
> +		PyErr_Format(TFS_ERROR, "Failed to enable tracer \'%s\'",
> +			     tracer);
> +		return NULL;
> +	}
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyFtrace_get_current_tracer(PyObject *self, PyObject *args,
> +						      PyObject *kwargs)
> +{
> +	const char *file = "current_tracer";
> +	struct tracefs_instance *instance;
> +	PyObject *ret;
> +	char *tracer;
> +
> +	if (!get_instance_from_arg(args, kwargs, &instance))
> +		return NULL;
> +
> +	if (read_from_file(instance, file, &tracer) <= 0)
> +		return NULL;
> +
> +	trim_new_line(tracer);
> +	ret = PyUnicode_FromString(tracer);
> +	free(tracer);
> +
> +	return ret;
> +}
> +
> +PyObject *PyFtrace_available_event_systems(PyObject *self, PyObject *args,
> +							   PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +	char **list;
> +
> +	if (!get_instance_from_arg(args, kwargs, &instance))
> +		return NULL;
> +
> +	list = tracefs_event_systems(tracefs_instance_get_dir(instance));
> +	if (!list)
> +		return NULL;
> +
> +	return tfs_list2py_list(list);
> +}
> +
> +PyObject *PyFtrace_available_system_events(PyObject *self, PyObject *args,
> +							   PyObject *kwargs)
> +{
> +	static char *kwlist[] = {"system", "instance", NULL};
> +	const char *instance_name = NO_ARG, *system;
> +	struct tracefs_instance *instance;
> +	char **list;
> +
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"s|s",
> +					kwlist,
> +					&system,
> +					&instance_name)) {
> +		return NULL;
> +	}
> +
> +	if (!get_optional_instance(instance_name, &instance))
> +		return NULL;
> +
> +	list = tracefs_system_events(tracefs_instance_get_dir(instance),
> +				     system);
> +	if (!list)
> +		return NULL;
> +
> +	return tfs_list2py_list(list);
> +}
> +
> +bool get_event_enable_file(struct tracefs_instance *instance,
> +			   const char *system, const char *event,
> +			   char **path)
> +{
> +	char *buff = calloc(PATH_MAX, 1);
> +	const char *instance_name;

Need to check buff.

> +
> +	if ((is_all(system) && is_all(event)) ||
> +	    (is_all(system) && is_no_arg(event)) ||
> +	    (is_no_arg(system) && is_all(event))) {
> +		strcpy(buff, "events/enable");
> +
> +		*path = buff;
> +	} else if (is_set(system)) {
> +		strcpy(buff, "events/");
> +		strcat(buff, system);
> +		if (!check_dir(instance, buff))
> +			goto fail;
> +
> +		if (is_set(event)) {
> +			strcat(buff, "/");
> +			strcat(buff, event);
> +			if (!check_dir(instance, buff))
> +				goto fail;
> +
> +			strcat(buff, "/enable");
> +		} else {
> +			strcat(buff, "/enable");
> +		}
> +
> +		*path = buff;
> +	} else {
> +		goto fail;
> +	}

We really need to implement a

 tracefs_enable_event(struct tracefs_instance *instance, const char *system, const char *event);

That way we don't need to search for the file to write to here.

> +
> +	return true;
> +
> + fail:
> +	instance_name =
> +		instance ? tracefs_instance_get_name(instance) : "top";
> +	PyErr_Format(TFS_ERROR,
> +		     "Failed to locate event:\n Instance: %s  System: %s  Event: %s",
> +		     instance_name, system, event);
> +	free(buff);
> +	*path = NULL;
> +	return false;
> +}
> +
> +static bool enable_event(PyObject *self, PyObject *args, PyObject *kwargs,
> +			 const char *val)
> +{
> +	struct tracefs_instance *instance;
> +	char *file;
> +	int ret;
> +	static char *kwlist[] = {"instance", "system", "event", NULL};
> +	const char *instance_name, *system, *event;
> +
> +	instance_name = system = event = NO_ARG;
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"|sss",
> +					kwlist,
> +					&instance_name,
> +					&system,
> +					&event)) {
> +		return false;
> +	}
> +
> +	if (!get_optional_instance(instance_name, &instance))
> +		return false;
> +
> +	if (!get_event_enable_file(instance, system, event, &file))
> +		return false;
> +
> +	ret = write_to_file_and_chack(instance, file, val);
> +	free(file);
> +
> +	return ret < 0 ? false : true;
> +}
> +
> +#define ON	"1"
> +#define OFF	"0"
> +
> +PyObject *PyFtrace_enable_event(PyObject *self, PyObject *args,
> +						PyObject *kwargs)
> +{
> +	if (!enable_event(self, args, kwargs, ON))
> +		return NULL;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyFtrace_disable_event(PyObject *self, PyObject *args,
> +						 PyObject *kwargs)
> +{
> +	if (!enable_event(self, args, kwargs, OFF))
> +		return NULL;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +static bool enable_events(PyObject *self, PyObject *args, PyObject *kwargs,
> +			  const char *val)
> +{
> +	static char *kwlist[] = {"instance", "systems", "events", NULL};
> +	PyObject *system_list = NULL, *event_list = NULL, *system_event_list;
> +	const char **systems = NULL, **events = NULL;
> +	struct tracefs_instance *instance;
> +	const char *instance_name;
> +	char *file = NULL;
> +	int ret;
> +
> +	instance_name = NO_ARG;
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"|sOO",
> +					kwlist,
> +					&instance_name,
> +					&system_list,
> +					&event_list)) {
> +		return false;
> +	}
> +
> +	if (!get_optional_instance(instance_name, &instance))
> +		return false;
> +
> +	if (!system_list && !event_list) {
> +		ret = write_to_file_and_chack(instance, "events/enable", val);
> +		return ret < 0 ? false : true;
> +	}
> +
> +	if (!system_list && event_list) {
> +		if (PyUnicode_Check(event_list) &&
> +		    is_all(PyUnicode_DATA(event_list))) {
> +			ret = write_to_file_and_chack(instance,
> +						      "events/enable",
> +						      val);
> +			return ret < 0 ? false : true;
> +		} else {
> +			PyErr_SetString(TFS_ERROR,
> +					"Failed to enable events for unspecified system");
> +			return false;
> +		}
> +	}
> +
> +	systems = get_arg_list(system_list);
> +
> +	if (!event_list) {
> +		for (int s = 0; systems[s]; ++s) {
> +			asprintf(&file, "events/%s/enable", systems[s]);
> +			ret = write_to_file_and_chack(instance, file, val);
> +			free(file);
> +			if (ret < 0)
> +				return false;
> +		}
> +
> +		return true;
> +	}
> +
> +	if (!PyList_CheckExact(event_list))
> +		goto fail_with_err;
> +
> +	for (int s = 0; systems[s]; ++s) {
> +		system_event_list = PyList_GetItem(event_list, s);
> +		if (!system_event_list || !PyList_CheckExact(system_event_list))
> +			goto fail_with_err;
> +
> +		events = get_arg_list(system_event_list);
> +		for (int e = 0; events[e]; ++e) {
> +			if (!get_event_enable_file(instance,
> +						   systems[s], events[e],
> +						   &file))
> +				goto fail;
> +
> +			if (!write_to_file(instance, file, val))
> +				goto fail;
> +
> +			free(file);
> +			file = NULL;
> +		}
> +
> +		free(events);
> +		events = NULL;
> +	}
> +
> +	free(systems);
> +
> +	return true;
> +
> + fail_with_err:
> +	PyErr_SetString(TFS_ERROR, "Inconsistent \"events\" argument. ");
> +
> + fail:
> +	free(systems);
> +	free(events);
> +	free(file);
> +
> +	return false;
> +}
> +
> +PyObject *PyFtrace_enable_events(PyObject *self, PyObject *args,
> +						 PyObject *kwargs)
> +{
> +	if (!enable_events(self, args, kwargs, ON))
> +		return NULL;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyFtrace_disable_events(PyObject *self, PyObject *args,
> +						  PyObject *kwargs)
> +{
> +	if (!enable_events(self, args, kwargs, OFF))
> +		return NULL;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyFtrace_event_is_enabled(PyObject *self, PyObject *args,
> +						    PyObject *kwargs)
> +{
> +	static char *kwlist[] = {"instance", "system", "event", NULL};
> +	const char *instance_name, *system, *event;
> +	struct tracefs_instance *instance;
> +	char *file, *val;
> +	PyObject *ret;
> +
> +	instance_name = system = event = NO_ARG;
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"|sss",
> +					kwlist,
> +					&instance_name,
> +					&system,
> +					&event)) {
> +		return false;
> +	}
> +
> +	if (!get_optional_instance(instance_name, &instance))
> +		return false;
> +
> +	if (!get_event_enable_file(instance, system, event, &file))
> +		return NULL;
> +
> +	if (read_from_file(instance, file, &val) <= 0)
> +		return NULL;
> +
> +	trim_new_line(val);
> +	ret = PyUnicode_FromString(val);
> +
> +	free(file);
> +	free(val);
> +
> +	return ret;
> +}
> +
> +static bool tracing_ON(struct tracefs_instance *instance)
> +{
> +	int ret = tracefs_trace_on(instance);
> +
> +	if (ret < 0 ||
> +	    tracefs_trace_is_on(instance) != 1) {
> +		const char *instance_name =
> +			instance ? tracefs_instance_get_name(instance) : "top";
> +
> +		PyErr_Format(TFS_ERROR,
> +			     "Failed to start tracing (Instance: %s)",
> +			     instance_name);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +PyObject *PyFtrace_tracing_ON(PyObject *self, PyObject *args,
> +					      PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +
> +	if (!get_instance_from_arg(args, kwargs, &instance))
> +		return NULL;
> +
> +	if (!tracing_ON(instance))
> +		return NULL;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +static bool tracing_OFF(struct tracefs_instance *instance)
> +{
> +	int ret = tracefs_trace_off(instance);
> +
> +	if (ret < 0 ||
> +	    tracefs_trace_is_on(instance) != 0) {
> +		const char *instance_name =
> +			instance ? tracefs_instance_get_name(instance) : "top";
> +
> +		PyErr_Format(TFS_ERROR,
> +			     "Failed to stop tracing (Instance: %s)",
> +			     instance_name);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +PyObject *PyFtrace_tracing_OFF(PyObject *self, PyObject *args,
> +					       PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +
> +	if (!get_instance_from_arg(args, kwargs, &instance))
> +		return NULL;
> +
> +	if (!tracing_OFF(instance))
> +		return NULL;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyFtrace_is_tracing_ON(PyObject *self, PyObject *args,
> +						 PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +	int ret;
> +
> +	if (!get_instance_from_arg(args, kwargs, &instance))
> +		return NULL;
> +
> +	ret = tracefs_trace_is_on(instance);
> +	if (ret < 0) {
> +		const char *instance_name =
> +			instance ? tracefs_instance_get_name(instance) : "top";
> +
> +		PyErr_Format(TFS_ERROR,
> +			     "Failed to check if tracing is ON (Instance: %s)",
> +			     instance_name);
> +		return NULL;
> +	}
> +
> +	if (ret == 0)
> +		Py_RETURN_FALSE;
> +
> +	Py_RETURN_TRUE;
> +}
> +
> +static bool set_pid(struct tracefs_instance *instance,
> +			   const char *file, pid_t pid)
> +{
> +	char pid_str[100];
> +
> +	if (sprintf(pid_str, "%d", pid) <= 0 ||
> +	    !write_to_file_and_chack(instance, file, pid_str)) {
> +		PyErr_Format(TFS_ERROR, "Failed to set PID %i for \"%s\"",
> +			     pid, file);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +PyObject *PyFtrace_set_event_pid(PyObject *self, PyObject *args,
> +						 PyObject *kwargs)
> +{
> +	const char *instance_name = NO_ARG;
> +	struct tracefs_instance *instance;
> +	int pid;
> +
> +	static char *kwlist[] = {"pid", "instance", NULL};
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"i|s",
> +					kwlist,
> +					&pid,
> +					&instance_name)) {
> +		return NULL;
> +	}
> +
> +	if (!get_optional_instance(instance_name, &instance))
> +		return NULL;
> +
> +	if (!set_pid(instance, "set_event_pid", pid))
> +		return NULL;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyFtrace_set_ftrace_pid(PyObject *self, PyObject *args,
> +						  PyObject *kwargs)
> +{
> +	const char *instance_name = NO_ARG;
> +	struct tracefs_instance *instance;
> +	int pid;
> +
> +	static char *kwlist[] = {"pid", "instance", NULL};
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"i|s",
> +					kwlist,
> +					&pid,
> +					&instance_name)) {
> +		return NULL;
> +	}
> +
> +	if (!get_optional_instance(instance_name, &instance))
> +		return NULL;
> +
> +	if (!set_pid(instance, "set_ftrace_pid", pid))
> +		return NULL;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +static bool set_opt(struct tracefs_instance *instance,
> +		    const char *opt, const char *val)
> +{
> +	char file[PATH_MAX];
> +
> +	if (sprintf(file, "options/%s", opt) <= 0 ||
> +	    !write_to_file_and_chack(instance, file, val)) {
> +		PyErr_Format(TFS_ERROR, "Failed to set option \"%s\"", opt);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static PyObject *set_option_py_args(PyObject *args, PyObject *kwargs,
> +				   const char *val)
> +{
> +	const char *instance_name = NO_ARG, *opt;
> +	struct tracefs_instance *instance;
> +
> +	static char *kwlist[] = {"option", "instance", NULL};
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"s|s",
> +					kwlist,
> +					&opt,
> +					&instance_name)) {
> +		return NULL;
> +	}
> +
> +	if (!get_optional_instance(instance_name, &instance))
> +		return NULL;
> +
> +	if (!set_opt(instance, opt, val))
> +		return NULL;
> +
> +	Py_RETURN_NONE;
> +}
> +
> +PyObject *PyFtrace_enable_option(PyObject *self, PyObject *args,
> +						 PyObject *kwargs)
> +{
> +	return set_option_py_args(args, kwargs, ON);
> +}
> +
> +PyObject *PyFtrace_disable_option(PyObject *self, PyObject *args,
> +						  PyObject *kwargs)
> +{
> +	return set_option_py_args(args, kwargs, OFF);
> +}
> +
> +PyObject *PyFtrace_option_is_set(PyObject *self, PyObject *args,
> +						 PyObject *kwargs)
> +{
> +	const char *instance_name = NO_ARG, *opt;
> +	struct tracefs_instance *instance;
> +	enum tracefs_option_id opt_id;
> +
> +	static char *kwlist[] = {"option", "instance", NULL};
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"s|s",
> +					kwlist,
> +					&opt,
> +					&instance_name)) {
> +		return NULL;
> +	}
> +
> +	if (!get_optional_instance(instance_name, &instance))
> +		return NULL;
> +
> +	opt_id = tracefs_option_id(opt);
> +	if (tracefs_option_is_enabled(instance, opt_id))
> +		Py_RETURN_TRUE;
> +
> +	Py_RETURN_FALSE;
> +}
> +
> +static PyObject *get_option_list(struct tracefs_instance *instance,
> +				 bool enabled)
> +{
> +	const struct tracefs_options_mask *mask;
> +	PyObject *list = PyList_New(0);
> +	int i;
> +
> +	mask = enabled ? tracefs_options_get_enabled(instance) :
> +			 tracefs_options_get_supported(instance);
> +
> +	for (i = 0; i < TRACEFS_OPTION_MAX; ++i)
> +		if (tracefs_option_mask_is_set(mask, i)) {
> +			const char *opt = tracefs_option_name(i);
> +			PyList_Append(list, PyUnicode_FromString(opt));
> +		}
> +
> +	return list;
> +}
> +
> +PyObject *PyFtrace_enabled_options(PyObject *self, PyObject *args,
> +						   PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +
> +	if (!get_instance_from_arg(args, kwargs, &instance))
> +		return NULL;
> +
> +	return get_option_list(instance, true);
> +}
> +
> +PyObject *PyFtrace_supported_options(PyObject *self, PyObject *args,
> +						     PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +
> +	if (!get_instance_from_arg(args, kwargs, &instance))
> +		return NULL;
> +
> +	return get_option_list(instance, false);
> +}
> +
> +static PyObject *get_callback_func(const char *plugin_name, const char * py_callback)
> +{
> +	PyObject *py_name, *py_module, *py_func;
> +
> +	py_name = PyUnicode_FromString(plugin_name);
> +	py_module = PyImport_Import(py_name);
> +	if (!py_module) {
> +		PyErr_Format(TFS_ERROR, "Failed to import plugin \'%s\'",
> +			     plugin_name);
> +		return NULL;
> +	}
> +
> +	py_func = PyObject_GetAttrString(py_module, py_callback);
> +	if (!py_func || !PyCallable_Check(py_func)) {
> +		PyErr_Format(TFS_ERROR,
> +			     "Failed to import callback from plugin \'%s\'",
> +			     plugin_name);
> +		return NULL;
> +	}
> +
> +	return py_func;
> +}
> +
> +static void start_tracing(struct tracefs_instance *instance,
> +			  char **argv, char **env)
> +{
> +	if(tracefs_option_enable(instance, TRACEFS_OPTION_EVENT_FORK) < 0 ||
> +	   tracefs_option_enable(instance, TRACEFS_OPTION_FUNCTION_FORK) < 0 ||
> +	   !set_pid(instance, "set_ftrace_pid", getpid()) ||
> +	   !set_pid(instance, "set_event_pid", getpid()))
> +		exit(1);

So trace cruncher will only trace the given process and its children.
There's no other alternative?

-- Steve



> +
> +	tracing_ON(instance);
> +	if (execve(argv[0], argv, env) < 0) {
> +		PyErr_Format(TFS_ERROR, "Failed to exec \'%s\'",
> +			     argv[0]);
> +	}
> +
> +	exit(1);
> +}
> +
> +static int callback(struct tep_event *event, struct tep_record *record,
> +		    int cpu, void *py_func)
> +{
> +	record->cpu = cpu; // Remove when the bug in libtracefs is fixed.
> +
> +	PyObject *py_tep_event = PyTepEvent_New(event);
> +	PyObject *py_tep_record = PyTepRecord_New(record);
> +
> +	PyObject *arglist = PyTuple_New(2);
> +	PyTuple_SetItem(arglist, 0, py_tep_event);
> +	PyTuple_SetItem(arglist, 1, py_tep_record);
> +
> +	PyObject_CallObject((PyObject *) py_func, arglist);
> +
> +	return 0;
> +}
> +
> +PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
> +						       PyObject *kwargs)
> +{
> +	const char *plugin = "__main__", *py_callback = "callback";
> +	char *process, *instance_name;
> +	struct tracefs_instance *instance;
> +	static char *kwlist[] = {"process", "plugin", "callback", "instance", NULL};
> +	struct tep_handle *tep;
> +	PyObject *py_func;
> +	pid_t pid;
> +
> +	instance_name = NO_ARG;
> +	if(!PyArg_ParseTupleAndKeywords(args,
> +					kwargs,
> +					"s|sss",
> +					kwlist,
> +					&process,
> +					&plugin,
> +					&py_callback,
> +					&instance_name)) {
> +		return NULL;
> +	}
> +
> +	py_func = get_callback_func(plugin, py_callback);
> +	if (!py_func)
> +		return NULL;
> +
> +	if (!get_optional_instance(instance_name, &instance))
> +		return NULL;
> +
> +	tep = tracefs_local_events(tracefs_instance_get_dir(instance));
> +
> +	char *argv[] = {getenv("SHELL"), "-c", process, NULL};
> +	char *env[] = {NULL};
> +
> +	pid = fork();
> +	if (pid < 0) {
> +		PyErr_SetString(TFS_ERROR, "Failed to fork");
> +		return NULL;
> +	}
> +
> +	if (pid == 0)
> +		start_tracing(instance, argv, env);
> +
> +	do {
> +		tracefs_iterate_raw_events(tep, instance, NULL, 0, callback, py_func);
> +	} while (waitpid(pid, NULL, WNOHANG) != pid);
> +
> +	Py_RETURN_NONE;
> +}
> +
> +void PyFtrace_at_exit(void)
> +{
> +	destroy_all_instances();
> +}
> diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
> new file mode 100644
> index 0000000..2faa4a6
> --- /dev/null
> +++ b/src/ftracepy-utils.h
> @@ -0,0 +1,127 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +
> +/*
> + * Copyright (C) 2021 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
> + */
> +
> +#ifndef _TC_FTRACE_PY_UTILS
> +#define _TC_FTRACE_PY_UTILS
> +
> +// Python
> +#include <Python.h>
> +
> +// libtracefs
> +#include "tracefs.h"
> +
> +// trace-cruncher
> +#include "common.h"
> +
> +C_OBJECT_WRAPPER_DECLARE(tep_record, PyTepRecord)
> +
> +C_OBJECT_WRAPPER_DECLARE(tep_event, PyTepEvent)
> +
> +C_OBJECT_WRAPPER_DECLARE(tep_handle, PyTep)
> +
> +PyObject *PyTepRecord_time(PyTepRecord* self);
> +
> +PyObject *PyTepRecord_cpu(PyTepRecord* self);
> +
> +PyObject *PyTepEvent_name(PyTepEvent* self);
> +
> +PyObject *PyTepEvent_id(PyTepEvent* self);
> +
> +PyObject *PyTepEvent_field_names(PyTepEvent* self);
> +
> +PyObject *PyTepEvent_parse_record_field(PyTepEvent* self, PyObject *args,
> +							  PyObject *kwargs);
> +
> +PyObject *PyTepEvent_get_pid(PyTepEvent* self, PyObject *args,
> +					       PyObject *kwargs);
> +
> +PyObject *PyTep_init_local(PyTep *self, PyObject *args,
> +					PyObject *kwargs);
> +
> +PyObject *PyTep_get_event(PyTep *self, PyObject *args,
> +				       PyObject *kwargs);
> +
> +PyObject *PyFtrace_dir(PyObject *self);
> +
> +PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
> +						   PyObject *kwargs);
> +
> +PyObject *PyFtrace_destroy_instance(PyObject *self, PyObject *args,
> +						    PyObject *kwargs);
> +
> +PyObject *PyFtrace_get_all_instances(PyObject *self);
> +
> +PyObject *PyFtrace_destroy_all_instances(PyObject *self);
> +
> +PyObject *PyFtrace_instance_dir(PyObject *self, PyObject *args,
> +						PyObject *kwargs);
> +
> +PyObject *PyFtrace_available_tracers(PyObject *self, PyObject *args,
> +						     PyObject *kwargs);
> +
> +PyObject *PyFtrace_set_current_tracer(PyObject *self, PyObject *args,
> +						      PyObject *kwargs);
> +
> +PyObject *PyFtrace_get_current_tracer(PyObject *self, PyObject *args,
> +						      PyObject *kwargs);
> +
> +PyObject *PyFtrace_available_event_systems(PyObject *self, PyObject *args,
> +							   PyObject *kwargs);
> +
> +PyObject *PyFtrace_available_system_events(PyObject *self, PyObject *args,
> +							   PyObject *kwargs);
> +
> +PyObject *PyFtrace_enable_event(PyObject *self, PyObject *args,
> +						PyObject *kwargs);
> +
> +PyObject *PyFtrace_disable_event(PyObject *self, PyObject *args,
> +						 PyObject *kwargs);
> +
> +PyObject *PyFtrace_enable_events(PyObject *self, PyObject *args,
> +						 PyObject *kwargs);
> +
> +PyObject *PyFtrace_disable_events(PyObject *self, PyObject *args,
> +						  PyObject *kwargs);
> +
> +PyObject *PyFtrace_event_is_enabled(PyObject *self, PyObject *args,
> +						    PyObject *kwargs);
> +
> +PyObject *PyFtrace_tracing_ON(PyObject *self, PyObject *args,
> +					      PyObject *kwargs);
> +
> +PyObject *PyFtrace_tracing_OFF(PyObject *self, PyObject *args,
> +					       PyObject *kwargs);
> +
> +PyObject *PyFtrace_is_tracing_ON(PyObject *self, PyObject *args,
> +						 PyObject *kwargs);
> +
> +PyObject *PyFtrace_set_event_pid(PyObject *self, PyObject *args,
> +						 PyObject *kwargs);
> +
> +PyObject *PyFtrace_set_ftrace_pid(PyObject *self, PyObject *args,
> +						  PyObject *kwargs);
> +
> +PyObject *PyFtrace_enable_option(PyObject *self, PyObject *args,
> +						 PyObject *kwargs);
> +
> +PyObject *PyFtrace_disable_option(PyObject *self, PyObject *args,
> +						  PyObject *kwargs);
> +
> +PyObject *PyFtrace_option_is_set(PyObject *self, PyObject *args,
> +						 PyObject *kwargs);
> +
> +PyObject *PyFtrace_supported_options(PyObject *self, PyObject *args,
> +						     PyObject *kwargs);
> +
> +PyObject *PyFtrace_enabled_options(PyObject *self, PyObject *args,
> +						   PyObject *kwargs);
> +
> +PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
> +						       PyObject *kwargs);
> +
> +void PyFtrace_at_exit(void);
> +
> +#endif
> diff --git a/src/ftracepy.c b/src/ftracepy.c
> new file mode 100644
> index 0000000..6aa5359
> --- /dev/null
> +++ b/src/ftracepy.c
> @@ -0,0 +1,262 @@
> +// SPDX-License-Identifier: LGPL-2.1
> +
> +/*
> + * Copyright (C) 2021 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> + */
> +
> +// trace-cruncher
> +#include "ftracepy-utils.h"
> +
> +extern PyObject *TFS_ERROR;
> +extern PyObject *TEP_ERROR;
> +extern PyObject *TRACECRUNCHER_ERROR;
> +
> +static PyMethodDef PyTepRecord_methods[] = {
> +	{"time",
> +	 (PyCFunction) PyTepRecord_time,
> +	 METH_NOARGS,
> +	 "Get the time of the record."
> +	},
> +	{"CPU",
> +	 (PyCFunction) PyTepRecord_cpu,
> +	 METH_NOARGS,
> +	 "Get the CPU Id of the record."
> +	},
> +	{NULL}
> +};
> +
> +C_OBJECT_WRAPPER(tep_record, PyTepRecord, NO_FREE)
> +
> +static PyMethodDef PyTepEvent_methods[] = {
> +	{"name",
> +	 (PyCFunction) PyTepEvent_name,
> +	 METH_NOARGS,
> +	 "Get the name of the event."
> +	},
> +	{"id",
> +	 (PyCFunction) PyTepEvent_id,
> +	 METH_NOARGS,
> +	 "Get the unique identifier of the event."
> +	},
> +	{"field_names",
> +	 (PyCFunction) PyTepEvent_field_names,
> +	 METH_NOARGS,
> +	 "Get the names of all fields."
> +	},
> +	{"parse_record_field",
> +	 (PyCFunction) PyTepEvent_parse_record_field,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Get the content of a record field."
> +	},
> +	{"get_pid",
> +	 (PyCFunction) PyTepEvent_get_pid,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	},
> +	{NULL}
> +};
> +
> +C_OBJECT_WRAPPER(tep_event, PyTepEvent, NO_FREE)
> +
> +static PyMethodDef PyTep_methods[] = {
> +	{"init_local",
> +	 (PyCFunction) PyTep_init_local,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Initialize from local instance."
> +	},
> +	{"get_event",
> +	 (PyCFunction) PyTep_get_event,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Get a PyTepEvent object."
> +	},
> +	{NULL}
> +};
> +
> +C_OBJECT_WRAPPER(tep_handle, PyTep, tep_free)
> +
> +static PyMethodDef ftracepy_methods[] = {
> +	{"dir",
> +	 (PyCFunction) PyFtrace_dir,
> +	 METH_NOARGS,
> +	 "Get the absolute path to the tracefs directory."
> +	},
> +	{"create_instance",
> +	 (PyCFunction) PyFtrace_create_instance,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Create new tracefs instance."
> +	},
> +	{"get_all_instances",
> +	 (PyCFunction) PyFtrace_get_all_instances,
> +	 METH_NOARGS,
> +	 "Get all existing tracefs instances."
> +	},
> +	{"destroy_instance",
> +	 (PyCFunction) PyFtrace_destroy_instance,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Destroy existing tracefs instance."
> +	},
> +	{"destroy_all_instances",
> +	 (PyCFunction) PyFtrace_destroy_all_instances,
> +	 METH_NOARGS,
> +	 "Destroy all existing tracefs instances."
> +	},
> +	{"instance_dir",
> +	 (PyCFunction) PyFtrace_instance_dir,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Get the absolute path to the instance directory."
> +	},
> +	{"available_tracers",
> +	 (PyCFunction) PyFtrace_available_tracers,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Get a list of available tracers."
> +	},
> +	{"set_current_tracer",
> +	 (PyCFunction) PyFtrace_set_current_tracer,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Enable a tracer."
> +	},
> +	{"get_current_tracer",
> +	 (PyCFunction) PyFtrace_get_current_tracer,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Check the enabled tracer."
> +	},
> +	{"available_event_systems",
> +	 (PyCFunction) PyFtrace_available_event_systems,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Get a list of available trace event systems."
> +	},
> +	{"available_system_events",
> +	 (PyCFunction) PyFtrace_available_system_events,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Get a list of available trace event for a given system."
> +	},
> +	{"enable_event",
> +	 (PyCFunction) PyFtrace_enable_event,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Enable trece event."
> +	},
> +	{"disable_event",
> +	 (PyCFunction) PyFtrace_disable_event,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Disable trece event."
> +	},
> +	{"enable_events",
> +	 (PyCFunction) PyFtrace_enable_events,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Enable multiple trece event."
> +	},
> +	{"disable_events",
> +	 (PyCFunction) PyFtrace_disable_events,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Disable multiple trece event."
> +	},
> +	{"event_is_enabled",
> +	 (PyCFunction) PyFtrace_event_is_enabled,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Check if event is enabled."
> +	},
> +	{"tracing_ON",
> +	 (PyCFunction) PyFtrace_tracing_ON,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Start tracing."
> +	},
> +	{"tracing_OFF",
> +	 (PyCFunction) PyFtrace_tracing_OFF,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Stop tracing."
> +	},
> +	{"is_tracing_ON",
> +	 (PyCFunction) PyFtrace_is_tracing_ON,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Check if tracing is ON."
> +	},
> +	{"set_event_pid",
> +	 (PyCFunction) PyFtrace_set_event_pid,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "."
> +	},
> +	{"set_ftrace_pid",
> +	 (PyCFunction) PyFtrace_set_ftrace_pid,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "."
> +	},
> +	{"enable_option",
> +	 (PyCFunction) PyFtrace_enable_option,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Enable trece option."
> +	},
> +	{"disable_option",
> +	 (PyCFunction) PyFtrace_disable_option,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Disable trece option."
> +	},
> +	{"option_is_set",
> +	 (PyCFunction) PyFtrace_option_is_set,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Check if trece option is enabled."
> +	},
> +	{"supported_options",
> +	 (PyCFunction) PyFtrace_supported_options,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Gat a list of all supported options."
> +	},
> +	{"enabled_options",
> +	 (PyCFunction) PyFtrace_enabled_options,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Gat a list of all supported options."
> +	},
> +	{"trace_shell_process",
> +	 (PyCFunction) PyFtrace_trace_shell_process,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Trace a shell process."
> +	},
> +	{NULL, NULL, 0, NULL}
> +};
> +
> +static struct PyModuleDef ftracepy_module = {
> +	PyModuleDef_HEAD_INIT,
> +	"ftracepy",
> +	"Python interface for Ftrace.",
> +	-1,
> +	ftracepy_methods
> +};
> +
> +PyMODINIT_FUNC PyInit_ftracepy(void)
> +{
> +	if (!PyTepTypeInit())
> +		return NULL;
> +
> +	if (!PyTepEventTypeInit())
> +		return NULL;
> +
> +	if (!PyTepRecordTypeInit())
> +		return NULL;
> +
> +	TFS_ERROR = PyErr_NewException("tracecruncher.ftracepy.tfs_error",
> +				       NULL, NULL);
> +
> +	TEP_ERROR = PyErr_NewException("tracecruncher.ftracepy.tep_error",
> +				       NULL, NULL);
> +
> +	TRACECRUNCHER_ERROR = PyErr_NewException("tracecruncher.tc_error",
> +						 NULL, NULL);
> +
> +	PyObject *module =  PyModule_Create(&ftracepy_module);
> +
> +	PyModule_AddObject(module, "tep_handle", (PyObject *) &PyTepType);
> +	PyModule_AddObject(module, "tep_event", (PyObject *) &PyTepEventType);
> +	PyModule_AddObject(module, "tep_record", (PyObject *) &PyTepRecordType);
> +
> +	PyModule_AddObject(module, "tfs_error", TFS_ERROR);
> +	PyModule_AddObject(module, "tep_error", TEP_ERROR);
> +	PyModule_AddObject(module, "tc_error", TRACECRUNCHER_ERROR);
> +
> +	if (geteuid() != 0) {
> +		PyErr_SetString(TFS_ERROR,
> +				"Permission denied. Root privileges are required.");
> +		return NULL;
> +	}
> +
> +	Py_AtExit(PyFtrace_at_exit);
> +
> +	return module;
> +}

