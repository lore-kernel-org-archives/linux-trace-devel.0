Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC75C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jan 2022 10:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiARKIs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jan 2022 05:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236740AbiARKIs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jan 2022 05:08:48 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FC0C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 02:08:47 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id ay4-20020a05600c1e0400b0034a81a94607so5983049wmb.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 02:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=QbXpra/eId80ZM3SQclFGq5jDVkpdR5BNtl/E/bHVeE=;
        b=LxCJowBDc2awBp5LKJatygoeTzO06Vm8GnkFiajg78sy3UJaALRcEeeop+iWVw9s/r
         cOCbKuExeTFkBRKsXGmBo+6p4oOdIT00KrwzD7rgs/aVk7Yl4PSrkTX5kl+gMFeFx9AN
         zWEKqbIW3cD1e+H7eI6tv+luKLvpr7Ln7TyeOzlIYn8zrJbLcLZ+f1nnKDcGE4U9HYmQ
         CE9yS8amWP6IIVwDRGbrnK1bvzXdxfRzmbchVzRAqrfjJqgQ9rDmeO1Yo2takO6hpRlf
         YfVf2oGK22re9rrxymVHL9VhGlPRpWcRHPZrtCt+WSpdl3gWeOJ30+GgSM7ZD8cMPcEw
         yUjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QbXpra/eId80ZM3SQclFGq5jDVkpdR5BNtl/E/bHVeE=;
        b=3OFUhhFT48l+qo+wdnPIMOnSbtsmKPVEKn8+L+Q6pwUKCJ54jLB5jkbTsPXdZDf8Xx
         949pusyJ8itkRKiyF/5DOm4xMiMALixQJyynVPoGBKv6/ZFRlqjUrPrDACB/hfEgxYR0
         VjDHCymDD9W3epG9MVaAsRAmrQN0bBjvB7QbvE/YRvtjVa5H5ItYIcZAPw22rg9dGfib
         I2kLTvGFZmxohCezig9BX2BMUvWjkzeUsTmfovKj/oi+vHvFDk+DLVhbTpwTT6H1nqtb
         psVXJkYwe5xE4/aTd5K3cN4qZ8t5iNF71/otC109BwcdLHkwbtlKE21JAviAo5hhdESz
         9NsA==
X-Gm-Message-State: AOAM533VY31nD4M+mZnmLVq+nDeZbQtc1abtabc4OMHSlqidv97Wv3Ox
        s2olkazE3K6J9oP7lg7BIgLCS7jmL1Q=
X-Google-Smtp-Source: ABdhPJzPt3Ha/uxfnhF5XMTJxhfCTXiuqiRc8R/ff8QFDKmJJraT5Ofl0s2mcvwwG6kCThTwDFvakA==
X-Received: by 2002:a7b:c199:: with SMTP id y25mr23641653wmi.83.1642500526260;
        Tue, 18 Jan 2022 02:08:46 -0800 (PST)
Received: from [10.93.98.252] ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id t6sm2060637wmq.16.2022.01.18.02.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 02:08:45 -0800 (PST)
Message-ID: <3a60bdb7-6d2c-a912-3ef1-880ff9388a52@gmail.com>
Date:   Tue, 18 Jan 2022 12:08:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] trace-cruncher: Add API to set tracing CPU affinity
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20220117201835.0991759f@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220117201835.0991759f@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 18.01.22 г. 3:18 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Add a set_affinity API that can let the user set what CPUs to enable
> tracing on.
> 
> Example:
> 
>    import tracecruncher.ftracepy as ft
> 
>    ft.set_affinity(cpus=["0-1","3"]);
> 
> The above will set the top level instance affinity to 0,1,3 (or 0xb)
> 
> To reset back to online CPUs:
> 
>    ft.reset_affinity()
> 
> Where it will reset the top level instance back to all CPUS.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> Changes since v2: https://lore.kernel.org/all/20220117201231.414a4799@gandalf.local.home/
> 
>   - Fix (again) the description of set_affinity.
> 
>   examples/reset-affinity.py |  5 ++
>   examples/test-affinity.py  |  5 ++
>   src/ftracepy-utils.c       | 93 ++++++++++++++++++++++++++++++++++++++
>   src/ftracepy-utils.h       |  6 +++
>   src/ftracepy.c             | 10 ++++
>   5 files changed, 119 insertions(+)
>   create mode 100755 examples/reset-affinity.py
>   create mode 100755 examples/test-affinity.py
> 
> diff --git a/examples/reset-affinity.py b/examples/reset-affinity.py
> new file mode 100755
> index 0000000..2bca32e
> --- /dev/null
> +++ b/examples/reset-affinity.py
> @@ -0,0 +1,5 @@
> +#!/usr/bin/env python3
> +
> +import tracecruncher.ftracepy as ft
> +
> +ft.reset_affinity();
> diff --git a/examples/test-affinity.py b/examples/test-affinity.py
> new file mode 100755
> index 0000000..1619931
> --- /dev/null
> +++ b/examples/test-affinity.py
> @@ -0,0 +1,5 @@
> +#!/usr/bin/env python3
> +
> +import tracecruncher.ftracepy as ft
> +
> +ft.set_affinity(cpus=["0-1","3"]);
> diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
> index a735d88..e42f69c 100644
> --- a/src/ftracepy-utils.c
> +++ b/src/ftracepy-utils.c
> @@ -2394,6 +2394,99 @@ PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
>   	return NULL;
>   }
>   
> +PyObject *PyFtrace_reset_affinity(PyObject *self, PyObject *args,
> +				  PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +	static char *kwlist[] = {"instance", NULL};
> +	PyObject *py_inst = NULL;
> +	int ret;
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "|O",
> +					 kwlist,
> +					 &py_inst)) {
> +		return NULL;
> +	}
> +
> +	if (!get_optional_instance(py_inst, &instance))
> +		goto err;

No need to have 'goto' in this function. Just return NULL (see also my comment at the bottom).


> +
> +	/* NULL for CPUs will set all available CPUS */
> +	ret = tracefs_instance_set_affinity(instance, NULL);
> +	if (ret < 0) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Failed to reset tracing affinity.");
> +		goto err;
> +	}

Can we make the call of tracefs_instance_set_affinity(), the error check and the error message a static helper?
I will explain why bellow in the patch.

> +
> +	Py_RETURN_NONE;
> +err:
> +	return NULL;
> +}
> +
> +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
> +						PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +	static char *kwlist[] = {"cpus", "instance", NULL};
> +	PyObject *py_cpus;
> +	PyObject *py_inst = NULL;
> +	const char *cpu_str;
> +	int ret;
> +
> +	if (!init_print_seq())
> +		return false;

We have to return NULL here.

> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "O|O",
> +					 kwlist,
> +					 &py_cpus,
> +					 &py_inst)) {
> +		return NULL;
> +	}
> +
> +	if (PyUnicode_Check(py_cpus)) {
> +		cpu_str = (const char *)PyUnicode_DATA(py_cpus);

And here we can have

		if ((is_all(cpu_str) {
			Call the static helper for 'reset' here and return.
		}

> +		if (trace_seq_puts(&seq, cpu_str) < > +			goto err_seq;
> +	} else if (PyList_CheckExact(py_cpus)) {
> +		int i, n = PyList_Size(py_cpus);
> +
> +		for (i = 0; i < n; ++i) {
> +			cpu_str = str_from_list(py_cpus, i);
> +			if (i)
> +				trace_seq_putc(&seq, ',');
> +			if (trace_seq_puts(&seq, cpu_str) < 0)
> +				goto err_seq;
> +		}
> +	} else {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Invalid \"cpus\" type.");

It may be better to use TfsError_fmt() here.
This helper will print also the error log of libtracefs.
The same comment applies for all error messages below.

> +		goto err;
  		return NULL;
> +	}
> +
> +	if (!get_optional_instance(py_inst, &instance))
> +		goto err;
		return NULL;
> +
> +	trace_seq_terminate(&seq);
> +	ret = tracefs_instance_set_affinity(instance, seq.buffer);
> +	if (ret < 0) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Invalid \"cpus\" argument.");
> +		goto err;
  		return NULL;
> +	}
> +
> +	Py_RETURN_NONE;
> +err_seq:
> +	PyErr_SetString(TRACECRUNCHER_ERROR,
> +			"Internal processing string error.");
> +err:
> +	return NULL;

I guess you use 'goto err;' everywhere, because you want to stress that returning NULL is essentially exiting with 
error. However, so far we used just 'return NULL' everywhere and I would prefer to keep the code consistent.
Maybe in a separate patch we can replace all ''return NULL;' lines with a macro that can have some self-explanatory name?

Thanks!
Yordan




> +}
> +
>   PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
>   						       PyObject *kwargs)
>   {
> diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
> index d09c8bf..4af557f 100644
> --- a/src/ftracepy-utils.h
> +++ b/src/ftracepy-utils.h
> @@ -208,6 +208,12 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
>   PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
>   					PyObject *kwargs);
>   
> +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
> +						PyObject *kwargs);
> +
> +PyObject *PyFtrace_reset_affinity(PyObject *self, PyObject *args,
> +						  PyObject *kwargs);
> +
>   PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
>   						       PyObject *kwargs);
>   
> diff --git a/src/ftracepy.c b/src/ftracepy.c
> index b270b71..168ad77 100644
> --- a/src/ftracepy.c
> +++ b/src/ftracepy.c
> @@ -372,11 +372,21 @@ static PyMethodDef ftracepy_methods[] = {
>   	 METH_VARARGS | METH_KEYWORDS,
>   	 "Define a kretprobe."
>   	},
> +	{"reset_affinity",
> +	 (PyCFunction) PyFtrace_reset_affinity,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Set an instance tracing affinity to all CPUs"
> +	},
>   	{"hist",
>   	 (PyCFunction) PyFtrace_hist,
>   	 METH_VARARGS | METH_KEYWORDS,
>   	 "Define a histogram."
>   	},
> +	{"set_affinity",
> +	 (PyCFunction) PyFtrace_set_affinity,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Set the tracing affinity of an instance."
> +	},
>   	{"set_ftrace_loglevel",
>   	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
>   	 METH_VARARGS | METH_KEYWORDS,
> 
