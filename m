Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE205C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 Jan 2022 13:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240162AbiAKNHK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 08:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiAKNHK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 08:07:10 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE354C06173F
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 05:07:09 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id m4so25460737edb.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jan 2022 05:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VfnlG4nzKqITF7OvwQhPH9q0BJstOEZj6WgYwqDYyVk=;
        b=TBnQn2CFWPH1hvPiIehLha8JfgiTyOnnTl5Iw+SKlmrFwdusWKn73HifO+hSvvHEjw
         y2/77vHcd1Zxgp3E4upErluZcYoeFQjdnpjvp5DQ4F4qju19uxkySVY1qYQ39w6QVjIb
         VYMmZTn46SezgsZXtbmdVN4q8xg/NfDMvdw4JfXNpyvh+oi/tgd7yayh0IVtoTKSwwg1
         LZCDzkPOIS1NU2t0LTymrATCxuNhV05G/Vv7yRNSncI5yLFjqGPmcZGegZ2X0xOL+KFR
         9H5dy2Zp9I2kX2ALDshNoPZD0j0rQqorxFedCR+ouHKjDHSn5qbaAJ1lBOwn4d/qjMYe
         6ejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VfnlG4nzKqITF7OvwQhPH9q0BJstOEZj6WgYwqDYyVk=;
        b=yLWAPhgfV1ICWwovHIKNvZiOp1X2QUX0PjO3lLfmvbbvm6EwW0FyugdKRCxXpcXOnj
         sNIIRK3cRd54sgX4dQkiEslyNdjMy7KZKTyfWAtuvvOBcBlY5owlfhkkhb/P4iU2+iwF
         jg37tYLy9TDc+uRYXbQ0GQpGiKmg5FNYDsmyeiIBs6bAT6yXBN8cCLUUeO0+kxFgg6mF
         qfPPFLmby/s4fND3MFYUBfCivITfvtRHTaW3lG0HqbYEK9epFd3ukhtsmoWhqjb8fYNi
         +wNM3gETeSIDJk4bmg376NTolbty/B1CKV/x3DftdtHEF1q0Y3a6ZQBT6HzQ5BiUt7MG
         M1rg==
X-Gm-Message-State: AOAM530hDAb8ORpz0PIteeU0F4x5Uieutn/uVozRsxGfbIscSbkVXdyp
        XYgptQJnfA9cssvMZFxRfJnZxZiTFqA=
X-Google-Smtp-Source: ABdhPJzGDBIWgG/4SHz84WFEBUTqGZfwZfxUFaAk2pn+hBc2t/RcrjrrynLsmKhLbfeSqhS7k0lKAg==
X-Received: by 2002:a05:6402:5112:: with SMTP id m18mr4275769edd.45.1641906428254;
        Tue, 11 Jan 2022 05:07:08 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id g4sm5001480edp.25.2022.01.11.05.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 05:07:07 -0800 (PST)
Message-ID: <ddda1b3a-c626-8733-5d74-0d29d768e7a5@gmail.com>
Date:   Tue, 11 Jan 2022 15:07:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] trace-cruncher: Add API to set tracing CPU affinity
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <20211217182619.13db88f0@gandalf.local.home>
 <87b5f204-8132-a8dc-321a-f0928eef3710@gmail.com>
 <20220110102010.5c41b336@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220110102010.5c41b336@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 10.01.22 г. 17:20 ч., Steven Rostedt wrote:
> On Mon, 10 Jan 2022 15:32:16 +0200
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>> Hi Steven
>>
>> On 18.12.21 г. 1:26 ч., Steven Rostedt wrote:
>>> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>>>
>>> Add a set_affinity API that can let the user set what CPUs to enable
>>> tracing on.
>>
>> For the sake of completeness we will need APIs to 'clear' and 'get' the CPU affinity as well.
> 
> For "clear" you mean to avoid a CPU(s), not clear the mask, right?

I mean clear the mask. This will be a very simple method. The only argument will be the instance. And inside the method 
you just call 'tracefs_instance_file_clear()'. The 'get' method can return the bit mask of the CPUs.

> 
>>
>>>
>>> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>>> ---
>>> This depends on the new libtracefs API found here:
>>>
>>>     https://patchwork.kernel.org/project/linux-trace-devel/patch/20211217180450.12d3524b@gandalf.local.home/
>>>
>>> This can be worked out later if you have comments. And I'll keep
>>> the VMWare tag, as I did write while still working at VMware. I figured
>>> that my last patch as a VMware employee would be my first patch
>>> to trace-cruncher ;-)
>>
>> This is really symbolic and means a lot for me!
> 
> I thought you may appreciate it ;-)
I really do appreciate this :-)

> 
>>
>>>
>>>    examples/test-affinity.py |  5 ++++
>>>    src/ftracepy-utils.c      | 58 +++++++++++++++++++++++++++++++++++++++
>>>    src/ftracepy-utils.h      |  3 ++
>>>    src/ftracepy.c            |  5 ++++
>>>    4 files changed, 71 insertions(+)
>>>    create mode 100755 examples/test-affinity.py
>>>
>>> diff --git a/examples/test-affinity.py b/examples/test-affinity.py
>>> new file mode 100755
>>> index 0000000..1619931
>>> --- /dev/null
>>> +++ b/examples/test-affinity.py
>>> @@ -0,0 +1,5 @@
>>> +#!/usr/bin/env python3
>>> +
>>> +import tracecruncher.ftracepy as ft
>>> +
>>> +ft.set_affinity(cpus=["0-1","3"]);
>>> diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
>>> index a735d88..ab39cf1 100644
>>> --- a/src/ftracepy-utils.c
>>> +++ b/src/ftracepy-utils.c
>>> @@ -2394,6 +2394,64 @@ PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
>>>    	return NULL;
>>>    }
>>>    
>>> +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
>>> +						PyObject *kwargs)
>>> +{
>>> +	struct tracefs_instance *instance;
>>> +	static char *kwlist[] = {"cpus", "instance", NULL};
>>> +	PyObject *py_cpus;
>>> +	PyObject *py_inst = NULL;
>>> +	const char *cpu_str;
>>> +	struct trace_seq seq;
>>> +	int ret;
>>> +
>>> +	if (!PyArg_ParseTupleAndKeywords(args,
>>> +					 kwargs,
>>> +					 "O|O",
>>> +					 kwlist,
>>> +					 &py_cpus,
>>> +					 &py_inst)) {
>>> +		return NULL;
>>> +	}
>>> +
>>> +	trace_seq_init(&seq);
>>
>> There is a global trace_seq object that can be used here. Also you have to check for error.
>> Perhaps having:
> 
> 
> Don't we need mutex protection if we use a global object?

As far as I know Python is intrinsically single threaded.
Only one thread can execute Python code at once.
Multiprocessing is the only way to parallelize the execution.

> 
> 
> 
>>
>> 	if (!init_print_seq())
>> 		return NULL;
> 
> Sure. I left it out as trace_seq has an internal state that won't (at least
> it should not) allow anything to be added if it didn't allocate or
> something else failed. Thus, you could do all the work and just test at the
> end.
> 
>>
>>> +
>>> +	if (PyUnicode_Check(py_cpus)) {
>>> +		cpu_str = (const char *)PyUnicode_DATA(py_cpus);
>>> +		if (trace_seq_puts(&seq, cpu_str) < 0)
>>> +			goto err_seq;
>>> +	} else if (PyList_CheckExact(py_cpus)) {
>>> +		int i, n = PyList_Size(py_cpus);
>>> +
>>> +		for (i = 0; i < n; ++i) {
>>> +			cpu_str = str_from_list(py_cpus, i);
>>> +			if (i)
>>> +				trace_seq_putc(&seq, ',');
>>> +			if (trace_seq_puts(&seq, cpu_str) < 0)
>>> +				goto err_seq;
>>> +		}
>>> +	}
>> If py_cpus is neither PyUnicode nor PyList, we have to print error and return NULL.
> 
> Yeah, I wasn't sure how much python would detect this. That can be added.

The C code here is everything that will happen when you call the method in Python.
No black magic ;-)

Actually there is one magical use case and this is when the method returns NULL.
In this case Python will do for you the error propagation and the cleanup.

> 
>>
>>> +
>>> +	if (!get_optional_instance(py_inst, &instance))
>>> +		goto err;
>>> +
>>> +	trace_seq_terminate(&seq);
>>> +	ret = tracefs_instance_set_affinity(instance, seq.buffer);
>>> +	if (ret < 0) {
>>> +		PyErr_SetString(TRACECRUNCHER_ERROR,
>>> +				"Invalid \"cpus\" argument.");
>>> +		goto err;
>>> +	}
>>> +
>>> +	Py_RETURN_NONE;
>>> +err_seq:
>>> +	PyErr_SetString(TRACECRUNCHER_ERROR,
>>> +			"Internal processing string error.");
>>> +err:
>>> +	trace_seq_destroy(&seq);
>>> +	return NULL;
>>> +}
>>> +
>>>    PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
>>>    						       PyObject *kwargs)
>>>    {
>>> diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
>>> index d09c8bf..67f67ab 100644
>>> --- a/src/ftracepy-utils.h
>>> +++ b/src/ftracepy-utils.h
>>> @@ -208,6 +208,9 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
>>>    PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
>>>    					PyObject *kwargs);
>>>    
>>> +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
>>> +						PyObject *kwargs);
>>> +
>>>    PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
>>>    						       PyObject *kwargs);
>>>    
>>> diff --git a/src/ftracepy.c b/src/ftracepy.c
>>> index b270b71..634f357 100644
>>> --- a/src/ftracepy.c
>>> +++ b/src/ftracepy.c
>>> @@ -377,6 +377,11 @@ static PyMethodDef ftracepy_methods[] = {
>>>    	 METH_VARARGS | METH_KEYWORDS,
>>>    	 "Define a histogram."
>>>    	},
>>> +	{"set_affinity",
>>> +	 (PyCFunction) PyFtrace_set_affinity,
>>> +	 METH_VARARGS | METH_KEYWORDS,
>>> +	 "Find an existing ftrace instance."
>> A short description of the method has to be provided here.
> 
> OK, will do in v2.

Thanks!
Yordan


> 
> Cheers,
> 
> -- Steve
> 
