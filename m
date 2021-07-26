Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C216C4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 09:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E66E860F11
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 09:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhGZIxy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 04:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbhGZIxx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 04:53:53 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9A8C061757
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jul 2021 02:34:22 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id g15so10278684wrd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jul 2021 02:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IDV+AtlpeWbRbn08dJg9c+0DN4oIcaO0IDcBeoD35OI=;
        b=LcOXHdPEWvQtauKRGpjGnNJg763TfuQDemO0+osCJv3/hvrQWvrkbNwG4Or7PYvBAe
         m7c3foPYpcD4p5TXjYgUo9rtEL1KyJ33l48nXpYBvy4WjUqjZpd/fnlH+8tqqGT5eF5Q
         n/utK2Ne5ZmpbiUZubXjiIQjM69ax+OikqR5ANlmGDVU2dwHx9gvVeH8cTuIG51C2/5o
         GDcUacYjeFnMeneZd5gjNRiQkxBveQvxpUk+qatCgOtLf5s48aBsyVrHIcYUtm9IHo13
         FjjmW3/KiQXEaWQD9Gm6hlZz6lzoHfuGr5Uuv2a0U5OHA9NCsKD2o3vAL23CeSAQN87y
         TcIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IDV+AtlpeWbRbn08dJg9c+0DN4oIcaO0IDcBeoD35OI=;
        b=Jw7Ue4P9jYJq249xc6Z+V0maOn6nV5tUAgpWtpw+JAlBd9DnHY0+1gSs289WF37G81
         CqgT8FYby2gHKf1h3CadcWZS4NsJNcL55ahBjNJKb8fzTq3ii6xtC0uJIZLb11cTWhjn
         dbcAR4aXfh3oBlVEPEGP5PNB/DW8vKDg8UthZ1E5C9UfrNaaugc/A6gGObhZkLKXZ1jK
         zol5w/gLN/r+5PU47u9LxEjyAdBwJH+xbEkz+z9CLVU0yFRllfno1Z+ObZGE1OKDPjn3
         OvNRB5T9cXdgG7WkdBnSLf2GnvnuOFWwoDRH+CSvltfDO6AHG2vdWIAjnR/LPDXd02MO
         +7ZA==
X-Gm-Message-State: AOAM530yiy6JgT+AjeHkuywrQjrSNFEfacgDRr+Xz7DSKRjl/FJ4ifgm
        esppWjdeTPHeO7B5W9yGPfGs5RQGdfs=
X-Google-Smtp-Source: ABdhPJw3Zmw3u8ACd6VB55zGFH5kMIcfN0aR/jWxdm9gLPZzUcK4Pi8glrIlD0MMoG6zp7Zv4QW5Ow==
X-Received: by 2002:adf:f80f:: with SMTP id s15mr4346485wrp.330.1627292061081;
        Mon, 26 Jul 2021 02:34:21 -0700 (PDT)
Received: from [10.93.171.151] ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id u11sm261027wrr.44.2021.07.26.02.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 02:34:20 -0700 (PDT)
Subject: Re: [PATCH 1/4] trace-cruncher: Add set_ftrace_loglevel()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210712123242.223500-1-y.karadz@gmail.com>
 <20210722171551.6a640651@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <b65d92d5-4978-a9c1-e04d-52f58638d8c5@gmail.com>
Date:   Mon, 26 Jul 2021 12:34:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210722171551.6a640651@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 23.07.21 г. 0:15, Steven Rostedt wrote:
> On Mon, 12 Jul 2021 15:32:39 +0300
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
> -ENOCOMMITMESSAGE
> 
> Please describe what you are doing and why. The subject is not enough.
> 
> Even on simple changes, there should be some commentary.

There was a message for this commit. I guess I somehow deleted it with 
the last rebase. Will fix this in v2.

Thanks!
Yordan

> The rest looks fine.
> 
> -- Steve
> 
> 
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   src/ftracepy-utils.c | 23 +++++++++++++++++++++++
>>   src/ftracepy-utils.h |  3 +++
>>   src/ftracepy.c       |  5 +++++
>>   3 files changed, 31 insertions(+)
>>
>> diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
>> index dfb0669..8f4b50c 100644
>> --- a/src/ftracepy-utils.c
>> +++ b/src/ftracepy-utils.c
>> @@ -1801,6 +1801,29 @@ PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
>>   	return event_is_enabled(instance, TC_SYS, event);
>>   }
>>   
>> +PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
>> +						       PyObject *kwargs)
>> +{
>> +	static char *kwlist[] = {"level", NULL};
>> +	int level;
>> +
>> +	if (!PyArg_ParseTupleAndKeywords(args,
>> +					 kwargs,
>> +					 "i",
>> +					 kwlist,
>> +					 &level)) {
>> +		return NULL;
>> +	}
>> +
>> +	if (level < 0)
>> +		level = 0;
>> +
>> +	tracefs_set_loglevel(level);
>> +	tep_set_loglevel(level);
>> +
>> +	Py_RETURN_NONE;
>> +}
>> +
>>   static bool set_fork_options(struct tracefs_instance *instance, bool enable)
>>   {
>>   	if (enable) {
>> diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
>> index d826427..5d7c19c 100644
>> --- a/src/ftracepy-utils.h
>> +++ b/src/ftracepy-utils.h
>> @@ -155,6 +155,9 @@ PyObject *PyFtrace_disable_kprobe(PyObject *self, PyObject *args,
>>   PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
>>   						     PyObject *kwargs);
>>   
>> +PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
>> +						       PyObject *kwargs);
>> +
>>   PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
>>   						 PyObject *kwargs);
>>   
>> diff --git a/src/ftracepy.c b/src/ftracepy.c
>> index e5fcd54..e3fec7b 100644
>> --- a/src/ftracepy.c
>> +++ b/src/ftracepy.c
>> @@ -269,6 +269,11 @@ static PyMethodDef ftracepy_methods[] = {
>>   	 METH_VARARGS | METH_KEYWORDS,
>>   	 "Check if kprobe event is enabled."
>>   	},
>> +	{"set_ftrace_loglevel",
>> +	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
>> +	 METH_VARARGS | METH_KEYWORDS,
>> +	 "Set the verbose level of the ftrace libraries."
>> +	},
>>   	{"trace_process",
>>   	 (PyCFunction) PyFtrace_trace_process,
>>   	 METH_VARARGS | METH_KEYWORDS,
> 
