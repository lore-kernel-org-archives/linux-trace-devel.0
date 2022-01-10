Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0003C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Jan 2022 15:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbiAJPUP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 10:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236105AbiAJPUP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 10:20:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1C2C06173F
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 07:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 073C8B81649
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 15:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B101C36AE3;
        Mon, 10 Jan 2022 15:20:11 +0000 (UTC)
Date:   Mon, 10 Jan 2022 10:20:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cruncher: Add API to set tracing CPU affinity
Message-ID: <20220110102010.5c41b336@gandalf.local.home>
In-Reply-To: <87b5f204-8132-a8dc-321a-f0928eef3710@gmail.com>
References: <20211217182619.13db88f0@gandalf.local.home>
        <87b5f204-8132-a8dc-321a-f0928eef3710@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 10 Jan 2022 15:32:16 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> Hi Steven
> 
> On 18.12.21 г. 1:26 ч., Steven Rostedt wrote:
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > 
> > Add a set_affinity API that can let the user set what CPUs to enable
> > tracing on.  
> 
> For the sake of completeness we will need APIs to 'clear' and 'get' the CPU affinity as well.

For "clear" you mean to avoid a CPU(s), not clear the mask, right?

> 
> > 
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > ---
> > This depends on the new libtracefs API found here:
> > 
> >    https://patchwork.kernel.org/project/linux-trace-devel/patch/20211217180450.12d3524b@gandalf.local.home/
> > 
> > This can be worked out later if you have comments. And I'll keep
> > the VMWare tag, as I did write while still working at VMware. I figured
> > that my last patch as a VMware employee would be my first patch
> > to trace-cruncher ;-)  
> 
> This is really symbolic and means a lot for me!

I thought you may appreciate it ;-)

> 
> > 
> >   examples/test-affinity.py |  5 ++++
> >   src/ftracepy-utils.c      | 58 +++++++++++++++++++++++++++++++++++++++
> >   src/ftracepy-utils.h      |  3 ++
> >   src/ftracepy.c            |  5 ++++
> >   4 files changed, 71 insertions(+)
> >   create mode 100755 examples/test-affinity.py
> > 
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
> > index a735d88..ab39cf1 100644
> > --- a/src/ftracepy-utils.c
> > +++ b/src/ftracepy-utils.c
> > @@ -2394,6 +2394,64 @@ PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
> >   	return NULL;
> >   }
> >   
> > +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
> > +						PyObject *kwargs)
> > +{
> > +	struct tracefs_instance *instance;
> > +	static char *kwlist[] = {"cpus", "instance", NULL};
> > +	PyObject *py_cpus;
> > +	PyObject *py_inst = NULL;
> > +	const char *cpu_str;
> > +	struct trace_seq seq;
> > +	int ret;
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
> > +	trace_seq_init(&seq);  
> 
> There is a global trace_seq object that can be used here. Also you have to check for error.
> Perhaps having:


Don't we need mutex protection if we use a global object?



> 
> 	if (!init_print_seq())
> 		return NULL;

Sure. I left it out as trace_seq has an internal state that won't (at least
it should not) allow anything to be added if it didn't allocate or
something else failed. Thus, you could do all the work and just test at the
end.

> 
> > +
> > +	if (PyUnicode_Check(py_cpus)) {
> > +		cpu_str = (const char *)PyUnicode_DATA(py_cpus);
> > +		if (trace_seq_puts(&seq, cpu_str) < 0)
> > +			goto err_seq;
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
> > +	}  
> If py_cpus is neither PyUnicode nor PyList, we have to print error and return NULL.

Yeah, I wasn't sure how much python would detect this. That can be added.

> 
> > +
> > +	if (!get_optional_instance(py_inst, &instance))
> > +		goto err;
> > +
> > +	trace_seq_terminate(&seq);
> > +	ret = tracefs_instance_set_affinity(instance, seq.buffer);
> > +	if (ret < 0) {
> > +		PyErr_SetString(TRACECRUNCHER_ERROR,
> > +				"Invalid \"cpus\" argument.");
> > +		goto err;
> > +	}
> > +
> > +	Py_RETURN_NONE;
> > +err_seq:
> > +	PyErr_SetString(TRACECRUNCHER_ERROR,
> > +			"Internal processing string error.");
> > +err:
> > +	trace_seq_destroy(&seq);
> > +	return NULL;
> > +}
> > +
> >   PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
> >   						       PyObject *kwargs)
> >   {
> > diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
> > index d09c8bf..67f67ab 100644
> > --- a/src/ftracepy-utils.h
> > +++ b/src/ftracepy-utils.h
> > @@ -208,6 +208,9 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
> >   PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
> >   					PyObject *kwargs);
> >   
> > +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
> > +						PyObject *kwargs);
> > +
> >   PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
> >   						       PyObject *kwargs);
> >   
> > diff --git a/src/ftracepy.c b/src/ftracepy.c
> > index b270b71..634f357 100644
> > --- a/src/ftracepy.c
> > +++ b/src/ftracepy.c
> > @@ -377,6 +377,11 @@ static PyMethodDef ftracepy_methods[] = {
> >   	 METH_VARARGS | METH_KEYWORDS,
> >   	 "Define a histogram."
> >   	},
> > +	{"set_affinity",
> > +	 (PyCFunction) PyFtrace_set_affinity,
> > +	 METH_VARARGS | METH_KEYWORDS,
> > +	 "Find an existing ftrace instance."  
> A short description of the method has to be provided here.

OK, will do in v2.

Cheers,

-- Steve
