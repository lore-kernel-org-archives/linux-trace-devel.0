Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DE6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 10:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiA0Khg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 05:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiA0Khg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 05:37:36 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3947C061714
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 02:37:35 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r10so3032373edt.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 02:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Mm8VTBLM2e4uajhcCjxY9z/rgu5hLwYk3eDJ8kCznss=;
        b=XIf0gQewSRAJs0QXw+buAbIMbvzRJ2pUDA+7+YDKBYVmFb79YkmLwF/wiNruMdijkO
         bpRu4RXeuQyJx2o43QxiM1y5s+OZPdhFR9m7cbts/KsNVZN9IlCh3QkEdv1ZG67Ok673
         jxkRf3E+pHOxDUp7gqOZke4svBkp7O7j9p2l1jDQCJmu153dlYg53inVvWmArd0lX6c/
         CuDlzX1/M+IP0tJ+/HAl7NKf8a3qUQiuBEVJ5yDtH1IQdlkBy6IezzfTBDNh1B/OLI+w
         sS30pZ7bpDXUMwnpADbP1eaFF5GbrRl14yPpPrKDqhCaJ4PL5wD+EKoZS+NUoJEwjL8N
         m0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Mm8VTBLM2e4uajhcCjxY9z/rgu5hLwYk3eDJ8kCznss=;
        b=NvNzZ11kcr6GBrWhtpZ1JbEevMkPije+162c8cubl1onAYjJzEw708mIVSJG8IaofX
         dUTKN51pU84mdPIbGqJOoHMYL/CG+TWju8M5Ax9NTNNog11uzSR9E778IVuSjdMGFJR2
         7nSf0xcVkgpivpC8rBHb+tsMvT6PBA+lzTDY/yLORR9SxiUJnEZ+rp5zxLEiRy8iPwpm
         NACwc25YV+ACdbTcEi2ojwdpS+/e8P7mE/E0PGG8lmr3G5D+OsiC31T4fn0IkSCs9EHQ
         WnwiFh8jKgRkz9v0OLrHC4Nx+Rk80d5nfPdTifqqN8OStw7jEO3lGhDcH1l3m1d7NKtD
         wt9Q==
X-Gm-Message-State: AOAM533Tm1lyK62OfjMWSbnRHg9crPVr8eASr+eHNXgXRILh7lFz0t6v
        pv6SnBAFBHqPkbWqrzQ27far08u9xZM=
X-Google-Smtp-Source: ABdhPJwOTwetTl4S99+ZgeRCrmPcK+86etKEi8Dv48y92py5Sb9I2e2QC5V3JYvEGQvMWGubzbscIA==
X-Received: by 2002:aa7:dbcc:: with SMTP id v12mr2996573edt.263.1643279854426;
        Thu, 27 Jan 2022 02:37:34 -0800 (PST)
Received: from [192.168.1.9] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id cz6sm5748911edb.4.2022.01.27.02.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 02:37:33 -0800 (PST)
Message-ID: <e8357999-a96a-18c3-398a-71867c77d8da@gmail.com>
Date:   Thu, 27 Jan 2022 12:37:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] trace-cruncher: Remove "register" from k(ret)probe
 APIs
Content-Language: en-US
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
References: <20220127070244.27701-1-tz.stoyanov@gmail.com>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220127070244.27701-1-tz.stoyanov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Applied.

Thanks Ceco!
Yordan

On 27.01.22 г. 9:02 ч., Tzvetomir Stoyanov (VMware) wrote:
> In order to be consistent with the other trace-cruncher APIs for dynamic
> events, renamed these APIs:
> 	register_kprobe to kprobe
> 	register_kretprobe to kretprobe
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
> v2 changes:
>   - Coding style fixes.
> 
>   src/ftracepy-utils.c                               |  6 ++----
>   src/ftracepy-utils.h                               |  6 ++----
>   src/ftracepy.c                                     |  8 ++++----
>   tracecruncher/ft_utils.py                          |  4 ++--
>   .../tests/1_unit/test_01_ftracepy_unit.py          | 14 +++++---------
>   5 files changed, 15 insertions(+), 23 deletions(-)
> 
> diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
> index 053b659..0a4092f 100644
> --- a/src/ftracepy-utils.c
> +++ b/src/ftracepy-utils.c
> @@ -2229,8 +2229,7 @@ PyObject *PyDynevent_probe(PyDynevent *self)
>   	return dynevent_info2py(buff, type);
>   }
>   
> -PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
> -						   PyObject *kwargs)
> +PyObject *PyFtrace_kprobe(PyObject *self, PyObject *args, PyObject *kwargs)
>   {
>   	static char *kwlist[] = {"event", "function", "probe", NULL};
>   	const char *event, *function, *probe;
> @@ -2261,8 +2260,7 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
>   	return PyDynevent_New(kprobe);
>   }
>   
> -PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
> -						      PyObject *kwargs)
> +PyObject *PyFtrace_kretprobe(PyObject *self, PyObject *args, PyObject *kwargs)
>   {
>   	static char *kwlist[] = {"event", "function", "probe", NULL};
>   	const char *event, *function, *probe = "$retval";
> diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
> index c96fd85..b7ce179 100644
> --- a/src/ftracepy-utils.h
> +++ b/src/ftracepy-utils.h
> @@ -245,11 +245,9 @@ PyObject *PyFtrace_enabled_options(PyObject *self, PyObject *args,
>   
>   PyObject *PyFtrace_tc_event_system(PyObject *self);
>   
> -PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
> -						   PyObject *kwargs);
> +PyObject *PyFtrace_kprobe(PyObject *self, PyObject *args, PyObject *kwargs);
>   
> -PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
> -						      PyObject *kwargs);
> +PyObject *PyFtrace_kretprobe(PyObject *self, PyObject *args, PyObject *kwargs);
>   
>   PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs);
>   
> diff --git a/src/ftracepy.c b/src/ftracepy.c
> index 464e8d3..9207c70 100644
> --- a/src/ftracepy.c
> +++ b/src/ftracepy.c
> @@ -450,13 +450,13 @@ static PyMethodDef ftracepy_methods[] = {
>   	 METH_NOARGS,
>   	 "Get the name of the event system used by trace-cruncher."
>   	},
> -	{"register_kprobe",
> -	 (PyCFunction) PyFtrace_register_kprobe,
> +	{"kprobe",
> +	 (PyCFunction) PyFtrace_kprobe,
>   	 METH_VARARGS | METH_KEYWORDS,
>   	 "Define a kprobe."
>   	},
> -	{"register_kretprobe",
> -	 (PyCFunction) PyFtrace_register_kretprobe,
> +	{"kretprobe",
> +	 (PyCFunction) PyFtrace_kretprobe,
>   	 METH_VARARGS | METH_KEYWORDS,
>   	 "Define a kretprobe."
>   	},
> diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
> index ed4bdcd..54cffe0 100644
> --- a/tracecruncher/ft_utils.py
> +++ b/tracecruncher/ft_utils.py
> @@ -178,7 +178,7 @@ class kprobe(kprobe_base):
>           """
>           probe = ' '.join('{!s}={!s}'.format(key,val) for (key, val) in self.fields.items())
>   
> -        self.kp = ft.register_kprobe(event=self.name, function=self.func, probe=probe);
> +        self.kp = ft.kprobe(event=self.name, function=self.func, probe=probe);
>           self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
>   
>   
> @@ -208,7 +208,7 @@ class kretval_probe(kprobe_base):
>       def register(self):
>           """ Register this probe to Ftrace.
>           """
> -        self.kp = ft.register_kprobe(event=self.name, function=self.func);
> +        self.kp = ft.kprobe(event=self.name, function=self.func);
>           self.evt_id = find_event_id(system=ft.tc_event_system(), event=self.name)
>   
>   
> diff --git a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
> index d773acc..1ef8951 100644
> --- a/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
> +++ b/tracecruncher/tests/1_unit/test_01_ftracepy_unit.py
> @@ -405,7 +405,7 @@ class OptionsTestCase(unittest.TestCase):
>   
>   
>   class KprobeTestCase(unittest.TestCase):
> -    def test_register_kprobe(self):
> +    def test_kprobe(self):
>           evt1 = 'mkdir'
>           evt1_func = 'do_mkdirat'
>           evt1_prove = 'path=+u0($arg2):ustring'
> @@ -413,14 +413,12 @@ class KprobeTestCase(unittest.TestCase):
>           evt2_func = 'do_sys_openat2'
>           evt2_prove = 'file=+u0($arg2):ustring'
>   
> -        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
> -                                 probe=evt1_prove)
> +        kp1 = ft.kprobe(event=evt1, function=evt1_func, probe=evt1_prove)
>           self.assertEqual(evt1, kp1.event())
>           self.assertEqual(evt1_func, kp1.address())
>           self.assertEqual(evt1_prove, kp1.probe())
>   
> -        kp2 = ft.register_kprobe(event=evt2, function=evt2_func,
> -                                 probe=evt2_prove)
> +        kp2 = ft.kprobe(event=evt2, function=evt2_func, probe=evt2_prove)
>           self.assertEqual(evt2, kp2.event())
>           self.assertEqual(evt2_func, kp2.address())
>           self.assertEqual(evt2_prove, kp2.probe())
> @@ -431,8 +429,7 @@ class KprobeTestCase(unittest.TestCase):
>           evt1_prove = 'path=+u0($arg2):ustring'
>           flt = 'path~\'/sys/fs/cgroup/*\''
>   
> -        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
> -                                 probe=evt1_prove)
> +        kp1 = ft.kprobe(event=evt1, function=evt1_func, probe=evt1_prove)
>           inst = ft.create_instance(instance_name)
>   
>           kp1.set_filter(instance=inst, filter=flt)
> @@ -447,8 +444,7 @@ class KprobeTestCase(unittest.TestCase):
>           evt1_func = 'do_mkdirat'
>           evt1_prove = 'path=+u0($arg2):ustring'
>   
> -        kp1 = ft.register_kprobe(event=evt1, function=evt1_func,
> -                                 probe=evt1_prove)
> +        kp1 = ft.kprobe(event=evt1, function=evt1_func, probe=evt1_prove)
>           inst = ft.create_instance(instance_name)
>           kp1.enable(instance=inst)
>           ret = kp1.is_enabled(instance=inst)
> 
