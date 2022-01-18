Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B56C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jan 2022 22:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344949AbiARWkX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jan 2022 17:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344927AbiARWkW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jan 2022 17:40:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6220C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 14:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8D7C6143D
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 22:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081FEC340E0;
        Tue, 18 Jan 2022 22:40:20 +0000 (UTC)
Date:   Tue, 18 Jan 2022 17:40:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3] trace-cruncher: Add API to set tracing CPU affinity
Message-ID: <20220118174019.005afcc2@gandalf.local.home>
In-Reply-To: <3a60bdb7-6d2c-a912-3ef1-880ff9388a52@gmail.com>
References: <20220117201835.0991759f@gandalf.local.home>
        <3a60bdb7-6d2c-a912-3ef1-880ff9388a52@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 18 Jan 2022 12:08:44 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> On 18.01.22 г. 3:18 ч., Steven Rostedt wrote:

> > diff --git a/examples/reset-affinity.py b/examples/reset-affinity.py
> > new file mode 100755
> > index 0000000..2bca32e
> > --- /dev/null
> > +++ b/examples/reset-affinity.py
> > @@ -0,0 +1,5 @@
> > +#!/usr/bin/env python3
> > +
> > +import tracecruncher.ftracepy as ft
> > +
> > +ft.reset_affinity();
> > diff --git a/examples/test-affinity.py b/examples/test-affinity.py
> > new file mode 100755
> > index 0000000..1619931
> > --- /dev/null
> > +++ b/examples/test-affinity.py
> > @@ -0,0 +1,5 @@
> > +#!/usr/bin/env python3
> > +
> > +import tracecruncher.ftracepy as ft
> > +
> > +ft.set_affinity(cpus=["0-1","3"]);
> > diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
> > index a735d88..e42f69c 100644
> > --- a/src/ftracepy-utils.c
> > +++ b/src/ftracepy-utils.c
> > @@ -2394,6 +2394,99 @@ PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
> >   	return NULL;
> >   }
> >   
> > +PyObject *PyFtrace_reset_affinity(PyObject *self, PyObject *args,
> > +				  PyObject *kwargs)
> > +{
> > +	struct tracefs_instance *instance;
> > +	static char *kwlist[] = {"instance", NULL};
> > +	PyObject *py_inst = NULL;
> > +	int ret;
> > +
> > +	if (!PyArg_ParseTupleAndKeywords(args,
> > +					 kwargs,
> > +					 "|O",
> > +					 kwlist,
> > +					 &py_inst)) {
> > +		return NULL;
> > +	}
> > +
> > +	if (!get_optional_instance(py_inst, &instance))
> > +		goto err;  
> 
> No need to have 'goto' in this function. Just return NULL (see also my comment at the bottom).
> 
> 
> > +
> > +	/* NULL for CPUs will set all available CPUS */
> > +	ret = tracefs_instance_set_affinity(instance, NULL);
> > +	if (ret < 0) {
> > +		PyErr_SetString(TRACECRUNCHER_ERROR,
> > +				"Failed to reset tracing affinity.");
> > +		goto err;
> > +	}  
> 
> Can we make the call of tracefs_instance_set_affinity(), the error check and the error message a static helper?
> I will explain why bellow in the patch.
> 
> > +
> > +	Py_RETURN_NONE;
> > +err:
> > +	return NULL;
> > +}
> > +
> > +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
> > +						PyObject *kwargs)
> > +{
> > +	struct tracefs_instance *instance;
> > +	static char *kwlist[] = {"cpus", "instance", NULL};
> > +	PyObject *py_cpus;
> > +	PyObject *py_inst = NULL;
> > +	const char *cpu_str;
> > +	int ret;
> > +
> > +	if (!init_print_seq())
> > +		return false;  
> 
> We have to return NULL here.

Oops, silly cut and paste issue.

> 
> > +
> > +	if (!PyArg_ParseTupleAndKeywords(args,
> > +					 kwargs,
> > +					 "O|O",
> > +					 kwlist,
> > +					 &py_cpus,
> > +					 &py_inst)) {
> > +		return NULL;
> > +	}
> > +
> > +	if (PyUnicode_Check(py_cpus)) {
> > +		cpu_str = (const char *)PyUnicode_DATA(py_cpus);  
> 
> And here we can have
> 
> 		if ((is_all(cpu_str) {
> 			Call the static helper for 'reset' here and return.

Do we need a static helper? It is simply:

	tracefs_instance_set_affinity(instance, NULL);

and that will set all of them. (NULL for CPUs means all CPUs).

> 		}
> 
> > +		if (trace_seq_puts(&seq, cpu_str) < > +			goto err_seq;
> > +	} else if (PyList_CheckExact(py_cpus)) {
> > +		int i, n = PyList_Size(py_cpus);
> > +
> > +		for (i = 0; i < n; ++i) {
> > +			cpu_str = str_from_list(py_cpus, i);
> > +			if (i)
> > +				trace_seq_putc(&seq, ',');
> > +			if (trace_seq_puts(&seq, cpu_str) < 0)
> > +				goto err_seq;
> > +		}
> > +	} else {
> > +		PyErr_SetString(TRACECRUNCHER_ERROR,
> > +				"Invalid \"cpus\" type.");  
> 
> It may be better to use TfsError_fmt() here.
> This helper will print also the error log of libtracefs.
> The same comment applies for all error messages below.

Do we want that as the error log will not be modified by this operation.

> 
> > +		goto err;  
>   		return NULL;
> > +	}
> > +
> > +	if (!get_optional_instance(py_inst, &instance))
> > +		goto err;  
> 		return NULL;
> > +
> > +	trace_seq_terminate(&seq);
> > +	ret = tracefs_instance_set_affinity(instance, seq.buffer);
> > +	if (ret < 0) {
> > +		PyErr_SetString(TRACECRUNCHER_ERROR,
> > +				"Invalid \"cpus\" argument.");
> > +		goto err;  
>   		return NULL;
> > +	}
> > +
> > +	Py_RETURN_NONE;
> > +err_seq:
> > +	PyErr_SetString(TRACECRUNCHER_ERROR,
> > +			"Internal processing string error.");
> > +err:
> > +	return NULL;  
> 
> I guess you use 'goto err;' everywhere, because you want to stress that returning NULL is essentially exiting with 
> error. However, so far we used just 'return NULL' everywhere and I would prefer to keep the code consistent.
> Maybe in a separate patch we can replace all ''return NULL;' lines with a macro that can have some self-explanatory name?

Yeah, I was trying to match the existing code, as I'm new to this. ;-)

-- Steve
