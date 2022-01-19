Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D718C4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 10:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239216AbiASKZh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 05:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353736AbiASKZE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 05:25:04 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CBAC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 02:25:04 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id f21so8860248eds.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 02:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YGTNkNKsVf3Iv6IhID2qlSByWf7od6V27wW0aguNDhc=;
        b=fDKy0r038B01enZj7c7naZn4YTXHmFh/fp/n+EhJQn3EZPXFPjKgbpIbbH1n6WTyz/
         MAC0dP0E0AmBY8WEz778ymBD2LyKWF5KZnVdEbFziby0N+5c31qfVGLFux66NoaAC8CV
         S3wDC+TQzwD/E4AfAFHrDeHW7Bfzvp6QMQIxTAcyFsRODjOSRIjccH7nTokzPMAfEHVP
         2eWhtrtnutSY6esmPICE8WnXFKD3XNJUMh2TLuDjTHtKQQ+C+cwxOV2Ah9PZPCoGV+Iw
         2HVHf/5ODMaLGVuDQyTRNoRamqhm/zgOmBtmQOJOgeFsPKn2UbH3tW2Q+1AJY8Sb4ENB
         EdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YGTNkNKsVf3Iv6IhID2qlSByWf7od6V27wW0aguNDhc=;
        b=SNOHcgra3OUML4y6mxMhhiyRbDh0BNQZOIYZBjK7g+RGh6lbCNUjnoLQXPVDSN96Tb
         KJYVAPdlhEhD16jx35ZtVqh4n/+nFojWfc6QGhgYBK5uBbng0NsfpOGRxrZrEA9EmhU3
         REoupHMiVe1mppRFNxVZCfotPnCJtd8V3MTwJPwlFurSAIcsvsGU+Z/1vs8ebGIHB+hh
         6LGHHnMA0iFh2yHPS7W6BBB/7CpI20ldmAC0F3SUoBwkA7P7D+pQyMQYkbvYAFSmM2V8
         I8iPbfhli+VFOsGj5hXMrzJ0xvTC0wrY/tLelBehZluUxT3rC+a5ksYFwoOKii9P4Lnp
         p5Dw==
X-Gm-Message-State: AOAM532xWaxmxZtV0nNyGYObEj5TS1oAWQ6lp7RVd6kkM1Uh+7Olm2Jp
        u3eBtUt40ktUy/nAL1rsoQ0xmh2Tntk=
X-Google-Smtp-Source: ABdhPJxJjRTbLhD4sn52aAI9Lcf/2OuR8QBy1yylHMJlKbMFbmBSuFl+nrBhemS/SnYuKOGWeQQdfQ==
X-Received: by 2002:a17:907:9494:: with SMTP id dm20mr221369ejc.120.1642587902738;
        Wed, 19 Jan 2022 02:25:02 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id o6sm1001870eds.35.2022.01.19.02.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 02:25:02 -0800 (PST)
Message-ID: <13f597fa-e82a-cc2a-aa9a-e917fb9a7a6c@gmail.com>
Date:   Wed, 19 Jan 2022 12:24:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] trace-cruncher: Add API to set tracing CPU affinity
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20220117201835.0991759f@gandalf.local.home>
 <3a60bdb7-6d2c-a912-3ef1-880ff9388a52@gmail.com>
 <20220118174019.005afcc2@gandalf.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220118174019.005afcc2@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.01.22 г. 0:40 ч., Steven Rostedt wrote:
> On Tue, 18 Jan 2022 12:08:44 +0200
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>> On 18.01.22 г. 3:18 ч., Steven Rostedt wrote:
> 
>>> diff --git a/examples/reset-affinity.py b/examples/reset-affinity.py
>>> new file mode 100755
>>> index 0000000..2bca32e
>>> --- /dev/null
>>> +++ b/examples/reset-affinity.py
>>> @@ -0,0 +1,5 @@
>>> +#!/usr/bin/env python3
>>> +
>>> +import tracecruncher.ftracepy as ft
>>> +
>>> +ft.reset_affinity();
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
>>> index a735d88..e42f69c 100644
>>> --- a/src/ftracepy-utils.c
>>> +++ b/src/ftracepy-utils.c
>>> @@ -2394,6 +2394,99 @@ PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
>>>    	return NULL;
>>>    }
>>>    
>>> +PyObject *PyFtrace_reset_affinity(PyObject *self, PyObject *args,
>>> +				  PyObject *kwargs)
>>> +{
>>> +	struct tracefs_instance *instance;
>>> +	static char *kwlist[] = {"instance", NULL};
>>> +	PyObject *py_inst = NULL;
>>> +	int ret;
>>> +
>>> +	if (!PyArg_ParseTupleAndKeywords(args,
>>> +					 kwargs,
>>> +					 "|O",
>>> +					 kwlist,
>>> +					 &py_inst)) {
>>> +		return NULL;
>>> +	}
>>> +
>>> +	if (!get_optional_instance(py_inst, &instance))
>>> +		goto err;
>>
>> No need to have 'goto' in this function. Just return NULL (see also my comment at the bottom).
>>
>>
>>> +
>>> +	/* NULL for CPUs will set all available CPUS */
>>> +	ret = tracefs_instance_set_affinity(instance, NULL);
>>> +	if (ret < 0) {
>>> +		PyErr_SetString(TRACECRUNCHER_ERROR,
>>> +				"Failed to reset tracing affinity.");
>>> +		goto err;
>>> +	}
>>
>> Can we make the call of tracefs_instance_set_affinity(), the error check and the error message a static helper?
>> I will explain why bellow in the patch.
>>
>>> +
>>> +	Py_RETURN_NONE;
>>> +err:
>>> +	return NULL;
>>> +}
>>> +
>>> +PyObject *PyFtrace_set_affinity(PyObject *self, PyObject *args,
>>> +						PyObject *kwargs)
>>> +{
>>> +	struct tracefs_instance *instance;
>>> +	static char *kwlist[] = {"cpus", "instance", NULL};
>>> +	PyObject *py_cpus;
>>> +	PyObject *py_inst = NULL;
>>> +	const char *cpu_str;
>>> +	int ret;
>>> +
>>> +	if (!init_print_seq())
>>> +		return false;
>>
>> We have to return NULL here.
> 
> Oops, silly cut and paste issue.
> 
>>
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
>>> +	if (PyUnicode_Check(py_cpus)) {
>>> +		cpu_str = (const char *)PyUnicode_DATA(py_cpus);
>>
>> And here we can have
>>
>> 		if ((is_all(cpu_str) {
>> 			Call the static helper for 'reset' here and return.
> 
> Do we need a static helper? It is simply:
> 
> 	tracefs_instance_set_affinity(instance, NULL);
> 
> and that will set all of them. (NULL for CPUs means all CPUs).

Yes, but we still need to check the return value and print an error message in the case of a failure.

> 
>> 		}
>>
>>> +		if (trace_seq_puts(&seq, cpu_str) < > +			goto err_seq;
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
>>> +	} else {
>>> +		PyErr_SetString(TRACECRUNCHER_ERROR,
>>> +				"Invalid \"cpus\" type.");
>>
>> It may be better to use TfsError_fmt() here.
>> This helper will print also the error log of libtracefs.
>> The same comment applies for all error messages below.
> 
> Do we want that as the error log will not be modified by this operation.

So far I'v been trying to print the error log every time when a libtracefs API returns an error. I know that not all of 
the errors are adding messages to the log, but I was thinking that this is something that is not guarantied to be stable 
and may change in the future.

Thanks!
Yordan

> 
>>
>>> +		goto err;
>>    		return NULL;
>>> +	}
>>> +
>>> +	if (!get_optional_instance(py_inst, &instance))
>>> +		goto err;
>> 		return NULL;
>>> +
>>> +	trace_seq_terminate(&seq);
>>> +	ret = tracefs_instance_set_affinity(instance, seq.buffer);
>>> +	if (ret < 0) {
>>> +		PyErr_SetString(TRACECRUNCHER_ERROR,
>>> +				"Invalid \"cpus\" argument.");
>>> +		goto err;
>>    		return NULL;
>>> +	}
>>> +
>>> +	Py_RETURN_NONE;
>>> +err_seq:
>>> +	PyErr_SetString(TRACECRUNCHER_ERROR,
>>> +			"Internal processing string error.");
>>> +err:
>>> +	return NULL;
>>
>> I guess you use 'goto err;' everywhere, because you want to stress that returning NULL is essentially exiting with
>> error. However, so far we used just 'return NULL' everywhere and I would prefer to keep the code consistent.
>> Maybe in a separate patch we can replace all ''return NULL;' lines with a macro that can have some self-explanatory name?
> 
> Yeah, I was trying to match the existing code, as I'm new to this. ;-)
> 
> -- Steve
> 
