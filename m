Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6ED7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jan 2022 14:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbiAKOAk convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 09:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236054AbiAKOAk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 09:00:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32573C06173F
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 06:00:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1A44B81A8F
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 14:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5027BC36AE3;
        Tue, 11 Jan 2022 14:00:37 +0000 (UTC)
Date:   Tue, 11 Jan 2022 09:00:35 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cruncher: Add API to set tracing CPU affinity
Message-ID: <20220111090035.3cf11479@rorschach.local.home>
In-Reply-To: <ddda1b3a-c626-8733-5d74-0d29d768e7a5@gmail.com>
References: <20211217182619.13db88f0@gandalf.local.home>
        <87b5f204-8132-a8dc-321a-f0928eef3710@gmail.com>
        <20220110102010.5c41b336@gandalf.local.home>
        <ddda1b3a-c626-8733-5d74-0d29d768e7a5@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 11 Jan 2022 15:07:06 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> On 10.01.22 г. 17:20 ч., Steven Rostedt wrote:
> > On Mon, 10 Jan 2022 15:32:16 +0200
> > Yordan Karadzhov <y.karadz@gmail.com> wrote:
> >   
> >> Hi Steven
> >>
> >> On 18.12.21 г. 1:26 ч., Steven Rostedt wrote:  
> >>> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> >>>
> >>> Add a set_affinity API that can let the user set what CPUs to enable
> >>> tracing on.  
> >>
> >> For the sake of completeness we will need APIs to 'clear' and 'get' the CPU affinity as well.  
> > 
> > For "clear" you mean to avoid a CPU(s), not clear the mask, right?  
> 
> I mean clear the mask. This will be a very simple method. The only argument will be the instance. And inside the method 
> you just call 'tracefs_instance_file_clear()'. The 'get' method can return the bit mask of the CPUs.
> 

But why would anyone clear it? It doesn't make any sense. This mask is
the CPUs that tracing is allowed on. By clearing it, you basically
stopped all tracing. If anything, it would confuse people. I honestly
do not know of a single use case (besides testing the tracing
infrastructure) for clearing the entire mask.

It would be similar to clearing the affinity mask for a task or
interrupt. If anything, that could harm the system. I'm not even sure
it's allowed (it would fail if tried).

Now, I could see clearing specific CPUs, and that would be useful. Say
you want to trace the entire system, but you dedicated a CPU for the
tracing application. It would make sense to clear the CPUs that your
tracing application is on and leave all others intact. That way the
tracing application doesn't affect the results as much.


> >>>    
> >>> +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
> >>> +						PyObject *kwargs)
> >>> +{
> >>> +	struct tracefs_instance *instance;
> >>> +	static char *kwlist[] = {"cpus", "instance", NULL};
> >>> +	PyObject *py_cpus;
> >>> +	PyObject *py_inst = NULL;
> >>> +	const char *cpu_str;
> >>> +	struct trace_seq seq;
> >>> +	int ret;
> >>> +
> >>> +	if (!PyArg_ParseTupleAndKeywords(args,
> >>> +					 kwargs,
> >>> +					 "O|O",
> >>> +					 kwlist,
> >>> +					 &py_cpus,
> >>> +					 &py_inst)) {
> >>> +		return NULL;
> >>> +	}
> >>> +
> >>> +	trace_seq_init(&seq);  
> >>
> >> There is a global trace_seq object that can be used here. Also you have to check for error.
> >> Perhaps having:  
> > 
> > 
> > Don't we need mutex protection if we use a global object?  
> 
> As far as I know Python is intrinsically single threaded.
> Only one thread can execute Python code at once.

Are you sure about that? A quick search produced this:

  https://realpython.com/intro-to-python-threading/

> Multiprocessing is the only way to parallelize the execution.
> 
> > 
> > 
> >   
> >>
> >> 	if (!init_print_seq())
> >> 		return NULL;  
> > 
> > Sure. I left it out as trace_seq has an internal state that won't (at least
> > it should not) allow anything to be added if it didn't allocate or
> > something else failed. Thus, you could do all the work and just test at the
> > end.
> >   
> >>  
> >>> +
> >>> +	if (PyUnicode_Check(py_cpus)) {
> >>> +		cpu_str = (const char *)PyUnicode_DATA(py_cpus);
> >>> +		if (trace_seq_puts(&seq, cpu_str) < 0)
> >>> +			goto err_seq;
> >>> +	} else if (PyList_CheckExact(py_cpus)) {
> >>> +		int i, n = PyList_Size(py_cpus);
> >>> +
> >>> +		for (i = 0; i < n; ++i) {
> >>> +			cpu_str = str_from_list(py_cpus, i);
> >>> +			if (i)
> >>> +				trace_seq_putc(&seq, ',');
> >>> +			if (trace_seq_puts(&seq, cpu_str) < 0)
> >>> +				goto err_seq;
> >>> +		}
> >>> +	}  
> >> If py_cpus is neither PyUnicode nor PyList, we have to print error and return NULL.  
> > 
> > Yeah, I wasn't sure how much python would detect this. That can be added.  
> 
> The C code here is everything that will happen when you call the method in Python.
> No black magic ;-)

OK.

-- Steve

> 
> Actually there is one magical use case and this is when the method returns NULL.
> In this case Python will do for you the error propagation and the cleanup.
> 
> >  
