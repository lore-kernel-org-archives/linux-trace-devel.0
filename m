Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68570C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Jan 2022 13:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357493AbiAYNbM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 08:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577158AbiAYN3E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 08:29:04 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDB8C061775
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 05:29:00 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id p12so62708302edq.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Jan 2022 05:29:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=j2JpO9BIqbltKwcJmoZHlG+6bXEvUT+6nFuITS3FY3E=;
        b=S2tyyW9bHGFy33k7mlztKSeHDh+mgtaZAhbt2UXZJT36iV+GxEKglLLrRsix/9hGXJ
         vBJRQikRjyVhhDtJCta/NfLz+9XunFiYvffsB4HhxEp1LeS6uPv76Q8aG8FCFzBVXZ0Z
         YJdmp4tZJcu4L6SNin1f3ZAODO4D3hCSZSBFjKVe8DemPJDuS7bl/mTSTIpCSZMqvbB/
         aHYL71B4o7jMQYA+9CBvAN1ukFsSLJk0ijNPkPDwVJGhzVKxraNE5xnhqvDVqmE0OILC
         B2h4c6/YWt+Fz+pTMU/6aCWN01HbfpIO5taFsF192SBZhOEUlWwAEQnn6KsJ62cJPxrM
         Iogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j2JpO9BIqbltKwcJmoZHlG+6bXEvUT+6nFuITS3FY3E=;
        b=or/+3bUNxrkEQBTbnPk4gFzwrJ8IvQ9gS1PH8S1nbXtPwxGKaTUBdAH9SheXXdri3Z
         38ZQpCawvdusRNPSSkExar33l3aC3B1BTR2JXcYfR+nue+EMumznIurOMauDR72f9Ypa
         VkN+ZZoDfISD7lDqlETIAvqB75YkFGc2YNqKNHmEfqrb24epd7w3jBjNThVFsJJ8Eezm
         UVA45kxOe+vGE9lhSzMbbmsbWhYNvoaZdcRHw0VWJ7fOO+01+h1XG4CZCAA8K/1Xos+b
         5jtMED0iLLaQi8Z5pvRFgeAhereC5TkEZknzUE3mcj/Wk4twMZXI5eOvUEp+2sH8HCe4
         Ui4A==
X-Gm-Message-State: AOAM530mvXKmRdTqn1qrsw1BB/wwAQiDcO9znWFegnXTsdwpvQRiRkRV
        ORp/CVc0XEZrg/77J5nurg0=
X-Google-Smtp-Source: ABdhPJyESmJOR3dnUzFbetYRktqRtIXZXeZGuCS1v+nHKpaDcUzXjWz142Cz1dhYALpeY1+gDvq24Q==
X-Received: by 2002:a05:6402:42ce:: with SMTP id i14mr20335062edc.126.1643117338730;
        Tue, 25 Jan 2022 05:28:58 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id f11sm8209078edv.29.2022.01.25.05.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 05:28:58 -0800 (PST)
Message-ID: <fe3cdba5-ec21-650b-095a-7e77cae0fe33@gmail.com>
Date:   Tue, 25 Jan 2022 15:28:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] trace-cruncher: Add support for event probes
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220124152020.459405-1-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220124152020.459405-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 24.01.22 г. 17:20 ч., Tzvetomir Stoyanov (VMware) wrote:
> Event probe (eprobe) is a new type of ftrace dynamic events, introduced
> in the Linux kernel 5.15 version. It is useful to have support for it in
> trace-cruncher, as it allows more flexibility when printing event's
> data.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>   src/ftracepy-utils.c                          | 34 ++++++++++++++++
>   src/ftracepy-utils.h                          |  3 ++
>   src/ftracepy.c                                |  5 +++
>   .../tests/1_unit/test_01_ftracepy_unit.py     | 39 +++++++++++++++++++
>   4 files changed, 81 insertions(+)
> 
> diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
> index cecb180..28ed7b9 100644
> --- a/src/ftracepy-utils.c
> +++ b/src/ftracepy-utils.c
> @@ -2064,6 +2064,40 @@ PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
>   	return PyDynevent_New(kprobe);
>   }
>   
> +PyObject *PyFtrace_register_eprobe(PyObject *self, PyObject *args,
> +						   PyObject *kwargs)
> +{

It seems that we have an inconsistency in the naming convention of the 'constructor' methods. The 'constructor' for 
kprobes is called 'register_kprobe', while for histograms and synthetic events we have just 'hist' and 'synth'. Lets use 
the short naming here (just 'eprobe') and you can remove the 'register' prefix from the constructor for kprobes in 
another patch.

> +	static char *kwlist[] = {"event", "target_system", "target_event", "fetchargs", NULL};
> +	const char *event, *target_system, *target_event, *fetchargs;
> +	struct tracefs_dynevent *eprobe;
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "ssss",
> +					 kwlist,
> +					 &event,
> +					 &target_system,
> +					 &target_event,
> +					 &fetchargs)) {
> +		return NULL;
> +	}
> +
> +	eprobe = tracefs_eprobe_alloc(TC_SYS, event, target_system, target_event, fetchargs);
> +	if (!eprobe) {
> +		MEM_ERROR;
> +		return NULL;
> +	}
> +
> +	if (tracefs_dynevent_create(eprobe) < 0) {
> +		TfsError_fmt(NULL, "Failed to create eprobe '%s'", event);
> +		tracefs_dynevent_free(eprobe);
> +		return NULL;
> +	}
> +
> +	return PyDynevent_New(eprobe);
> +}
> +
> +
>   PyObject *PyDynevent_set_filter(PyDynevent *self, PyObject *args,
>   						  PyObject *kwargs)
>   {
> diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
> index fc5016c..1030a50 100644
> --- a/src/ftracepy-utils.h
> +++ b/src/ftracepy-utils.h
> @@ -207,6 +207,9 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
>   PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
>   						      PyObject *kwargs);
>   
> +PyObject *PyFtrace_register_eprobe(PyObject *self, PyObject *args,
> +						   PyObject *kwargs);
> +
>   PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
>   					PyObject *kwargs);
>   
> diff --git a/src/ftracepy.c b/src/ftracepy.c
> index f59bd4c..50ee4d3 100644
> --- a/src/ftracepy.c
> +++ b/src/ftracepy.c
> @@ -377,6 +377,11 @@ static PyMethodDef ftracepy_methods[] = {
>   	 METH_VARARGS | METH_KEYWORDS,
>   	 "Define a kretprobe."
>   	},
> +	{"register_eprobe",
> +	 (PyCFunction) PyFtrace_register_eprobe,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Define an eprobe."
> +	},
>   	{"hist",
>   	 (PyCFunction) PyFtrace_hist,
>   	 METH_VARARGS | METH_KEYWORDS,
> diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
> index 51970d3..12b58a0 100644
> --- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
> +++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py


Please move the tests in separate patch!

> @@ -457,6 +457,45 @@ class KprobeTestCase(unittest.TestCase):
>           ret = kp1.is_enabled(instance=inst)
>           self.assertEqual(ret, '0')
>   
> +class EprobeTestCase(unittest.TestCase):
> +    def test_register_eprobe(self):

This fails on my machine, because I am still on the 5.13 kernel. Maybe somewhere up in the file you can add a global 
variable defined like this:

kernel_version = tuple(map(int, (os.uname()[2].split('.')[:2])))

and here you can check the kernel version

	if kernel_version < (5, 15):
		return

> +        evt1 = 'sopen_in'
> +        evt1_tsys = 'syscalls'
> +        evt1_tevent = 'sys_enter_openat'
> +        evt1_args = 'file=+0($filename):ustring'
> +        evt2 = 'sopen_out'
> +        evt2_tsys = 'syscalls'
> +        evt2_tevent = 'sys_exit_openat'
> +        evt2_args = 'res=$ret:u64'
> +
> +        ep1 = ft.register_eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
> +                                 fetchargs=evt1_args)
> +        self.assertEqual(evt1, ep1.event())
> +        self.assertEqual("{}.{}".format(evt1_tsys, evt1_tevent), ep1.address())
> +        self.assertEqual(evt1_args, ep1.probe())
> +
> +        ep2 = ft.register_eprobe(event=evt2, target_system=evt2_tsys, target_event=evt2_tevent,
> +                                 fetchargs=evt2_args)
> +        self.assertEqual(evt2, ep2.event())
> +        self.assertEqual("{}.{}".format(evt2_tsys, evt2_tevent), ep2.address())
> +        self.assertEqual(evt2_args, ep2.probe())
> +
> +    def test_enable_eprobe(self):

Another kernel version check

> +        evt1 = 'sopen_out'
> +        evt1_tsys = 'syscalls'
> +        evt1_tevent = 'sys_exit_openat'
> +        evt1_args = 'res=$ret:u64'
> +
> +        ep1 = ft.register_eprobe(event=evt1, target_system=evt1_tsys, target_event=evt1_tevent,
> +                                 fetchargs=evt1_args)
> +        inst = ft.create_instance(instance_name)
> +        ep1.enable(instance=inst)
> +        ret = ep1.is_enabled(instance=inst)
> +        self.assertEqual(ret, '1')
> +
> +        ep1.disable(instance=inst)
> +        ret = ep1.is_enabled(instance=inst)
> +        self.assertEqual(ret, '0')
>   
>   class TracingOnTestCase(unittest.TestCase):
>       def test_ON_OF(self):
> 


Ideally, there must be one more patch that will add an example.
Thanks!

Yordan
