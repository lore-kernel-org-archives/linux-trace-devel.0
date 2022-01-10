Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9650EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 Jan 2022 13:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiAJNcW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 Jan 2022 08:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbiAJNcU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 Jan 2022 08:32:20 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267CFC06173F
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 05:32:20 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id m4so12114493edb.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 10 Jan 2022 05:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=ym47QDmpo/rd9C128mHMSoRLbZNfv/gxp4aLnhRX9CU=;
        b=JcHbUMX6ickcLzBALVILENuDj3CfxjZ2440vAVNCBLn52/vHOxSslYJ1rvb2ed82xV
         pHB5o8EHerj1k5p0JDKh39C3Vn6hohwl5pFI6Gwabzr0J613ghgA5rZlpbSVdVwJq4Zo
         HIek875dWPwSRDXaa9gim+EpNJxD9TOmLLwKfZjKlcx8K1XHpUPbJOLSpoKQ6QXIs6AU
         f5ux7g7iT//xhYUXMDqla4hRZ9U+l0sU5QdrIz6DhGtmGEMoFkhD/nPb3BSJBfQD1SLv
         NavVMvRugeRQJBJZm+WTO/STS8Q2WWyyYUiYZSLp1ABmyj9Mhuf7rYGLNw5r596W0gSr
         FZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=ym47QDmpo/rd9C128mHMSoRLbZNfv/gxp4aLnhRX9CU=;
        b=gM7Gy+7ui9hvvZoXIK/EmBJshM8+Rcj5tuhgr9q4HGVWVD5VeBHLoVhSdWpf/kxr+z
         tTZzhX3EnpxyXlXNl+8c1lLJB4mIRpQGOtwRN7MyZKtVUCi3GDz2lqbUoCgzawZG3/iY
         jepBcf3ksVR9NnyGFG+nuO6lwRGbt2HjdPuSdcjYOPc2Jzwu114UbRmydcav1s+jigNv
         90vM1DKa+nrRhIrIV/REmJcxKlY/ULMwPd9w1eOLJHE8ovzhhAYg7aqH4x16Psvp8/lf
         Q3gmwJu+UewTOSigdQAvg5NTDZB2vcUb2mEINwYi+mp7q3+uvSSuG04o8Jq3MzUFhu8u
         YRqA==
X-Gm-Message-State: AOAM532GGOBRTYN3UR6oib1emdzcVE4EfmHspWVXWja98JOeFTcsyZs/
        3JNUwDIlr8VRM7DgvpwwIyI=
X-Google-Smtp-Source: ABdhPJwJotwTba0s/J0jzZGmqMNtU+e+TD0MkTAid0Hw6g4IJbzxquGzoPhYiVF5bzmwLxo+Fnwk2A==
X-Received: by 2002:a17:906:924e:: with SMTP id c14mr129075ejx.451.1641821538335;
        Mon, 10 Jan 2022 05:32:18 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id m12sm3581100edd.86.2022.01.10.05.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 05:32:17 -0800 (PST)
Message-ID: <87b5f204-8132-a8dc-321a-f0928eef3710@gmail.com>
Date:   Mon, 10 Jan 2022 15:32:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
From:   Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH] trace-cruncher: Add API to set tracing CPU affinity
To:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20211217182619.13db88f0@gandalf.local.home>
Content-Language: en-US
In-Reply-To: <20211217182619.13db88f0@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven

On 18.12.21 г. 1:26 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Add a set_affinity API that can let the user set what CPUs to enable
> tracing on.

For the sake of completeness we will need APIs to 'clear' and 'get' the CPU affinity as well.

> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
> This depends on the new libtracefs API found here:
> 
>    https://patchwork.kernel.org/project/linux-trace-devel/patch/20211217180450.12d3524b@gandalf.local.home/
> 
> This can be worked out later if you have comments. And I'll keep
> the VMWare tag, as I did write while still working at VMware. I figured
> that my last patch as a VMware employee would be my first patch
> to trace-cruncher ;-)

This is really symbolic and means a lot for me!

> 
>   examples/test-affinity.py |  5 ++++
>   src/ftracepy-utils.c      | 58 +++++++++++++++++++++++++++++++++++++++
>   src/ftracepy-utils.h      |  3 ++
>   src/ftracepy.c            |  5 ++++
>   4 files changed, 71 insertions(+)
>   create mode 100755 examples/test-affinity.py
> 
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
> index a735d88..ab39cf1 100644
> --- a/src/ftracepy-utils.c
> +++ b/src/ftracepy-utils.c
> @@ -2394,6 +2394,64 @@ PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
>   	return NULL;
>   }
>   
> +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
> +						PyObject *kwargs)
> +{
> +	struct tracefs_instance *instance;
> +	static char *kwlist[] = {"cpus", "instance", NULL};
> +	PyObject *py_cpus;
> +	PyObject *py_inst = NULL;
> +	const char *cpu_str;
> +	struct trace_seq seq;
> +	int ret;
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
> +	trace_seq_init(&seq);

There is a global trace_seq object that can be used here. Also you have to check for error.
Perhaps having:

	if (!init_print_seq())
		return NULL;

> +
> +	if (PyUnicode_Check(py_cpus)) {
> +		cpu_str = (const char *)PyUnicode_DATA(py_cpus);
> +		if (trace_seq_puts(&seq, cpu_str) < 0)
> +			goto err_seq;
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
> +	}
If py_cpus is neither PyUnicode nor PyList, we have to print error and return NULL.

> +
> +	if (!get_optional_instance(py_inst, &instance))
> +		goto err;
> +
> +	trace_seq_terminate(&seq);
> +	ret = tracefs_instance_set_affinity(instance, seq.buffer);
> +	if (ret < 0) {
> +		PyErr_SetString(TRACECRUNCHER_ERROR,
> +				"Invalid \"cpus\" argument.");
> +		goto err;
> +	}
> +
> +	Py_RETURN_NONE;
> +err_seq:
> +	PyErr_SetString(TRACECRUNCHER_ERROR,
> +			"Internal processing string error.");
> +err:
> +	trace_seq_destroy(&seq);
> +	return NULL;
> +}
> +
>   PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
>   						       PyObject *kwargs)
>   {
> diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
> index d09c8bf..67f67ab 100644
> --- a/src/ftracepy-utils.h
> +++ b/src/ftracepy-utils.h
> @@ -208,6 +208,9 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
>   PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
>   					PyObject *kwargs);
>   
> +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
> +						PyObject *kwargs);
> +
>   PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
>   						       PyObject *kwargs);
>   
> diff --git a/src/ftracepy.c b/src/ftracepy.c
> index b270b71..634f357 100644
> --- a/src/ftracepy.c
> +++ b/src/ftracepy.c
> @@ -377,6 +377,11 @@ static PyMethodDef ftracepy_methods[] = {
>   	 METH_VARARGS | METH_KEYWORDS,
>   	 "Define a histogram."
>   	},
> +	{"set_affinity",
> +	 (PyCFunction) PyFtrace_set_affinity,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Find an existing ftrace instance."
A short description of the method has to be provided here.

Thanks!
Yordan


> +	},
>   	{"set_ftrace_loglevel",
>   	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
>   	 METH_VARARGS | METH_KEYWORDS,
> 
