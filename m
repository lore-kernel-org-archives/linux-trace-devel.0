Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA071C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 15:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 712EB61435
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Apr 2021 15:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbhDUPl7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 11:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbhDUPl6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 11:41:58 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355FCC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 08:41:25 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id k17so10408335edr.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Apr 2021 08:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KOkZRXF7qNiyzoJkF22y76FNev78grqIdDQRFs2Pju8=;
        b=g1jY10ZZzWgcfA/TRKZiLWJIqiOGOJFRVOgouadQn+FeLUwyi1GyIuhRslYUS6GpG4
         3vMeCSEdiKpS01Wj14j/o2rKRSWAOef5thE8j840FbeE3Cv9WYhk8hlw1NmS0tTrGHjJ
         bkknGKTeHI7aylsoDs+iHt0EGEabRghMXi82oicfIjUL1ardmahNt0xfh9jdLLWBzspr
         CcGsC0YoEmfaOZnFKztNYNtqhXJHdTXfQyEAICCpwcyTJhUPSzRxAF5N44G//gtIvoZa
         PRz4txdCvf17KvbdYxlHxpbizoCYs06Yh9foeFllyfa0wOag7zjXGS+lmc2mcDzsDILq
         ZGrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KOkZRXF7qNiyzoJkF22y76FNev78grqIdDQRFs2Pju8=;
        b=uSnYAYGrIAPJ33ywOPfM9hFaOUY36cFVE3TYmIOaU+s8FdoEiWZHJyVVCWliQL8Svo
         G9jGWJna+DVa7S72476/TXR6tFfxgqaeGiOjfE4geKMDH7hjG7sHQeeb1hOCm9+uWnpr
         mVmIPsNHXpXjZX+NM9/BYqMwgsn5OlQhOTUt7TdgGX5YY3f4vV1XDjg6IdyJLYRY/ufn
         QOkBDWWOoCpXJBxneP2HOV16Kvxgm23SHBEn5d+OZ+Xw0QegtP0zYHLg2ESF7SkchTJ+
         Z/KlyCa0dCvNjlxcLRgL51RnGo9t0QdxoiyfCp0NJEo7JcXeBX53FVHpqri5dFPPpwcI
         auog==
X-Gm-Message-State: AOAM532VHCbMxgyosxxsweYUX8J/SXqaceMRoaqQCZP8Vo7yAeYiM8yZ
        KI1yPtceKar+j0v56+aBNOXjqFqSP58=
X-Google-Smtp-Source: ABdhPJy9ve/I9vA2cR6fHgbsx225r0Krlq5WOrnOvoJrc4VF4MIwtqveL7wRmVNeDj7MavyblfTP3g==
X-Received: by 2002:aa7:dac5:: with SMTP id x5mr38867175eds.286.1619019683682;
        Wed, 21 Apr 2021 08:41:23 -0700 (PDT)
Received: from [192.168.0.106] ([84.40.93.28])
        by smtp.gmail.com with ESMTPSA id br14sm2834998ejb.61.2021.04.21.08.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 08:41:23 -0700 (PDT)
Subject: Re: [PATCH 1/9] trace-cruncher: Refactor the part that wraps ftrace
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20210419130140.59140-1-y.karadz@gmail.com>
 <20210419130140.59140-2-y.karadz@gmail.com>
 <20210420221340.65c89491@oasis.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
Message-ID: <9ee66a06-cdc0-7dd4-8c5f-39493e64aef4@gmail.com>
Date:   Wed, 21 Apr 2021 18:41:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210420221340.65c89491@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

Thanks a lot for the review!

I will add all your fixes in v2.


On 21.04.21 г. 5:13, Steven Rostedt wrote:
>> +}
>> +
>> +static void start_tracing(struct tracefs_instance *instance,
>> +			  char **argv, char **env)
>> +{
>> +	if(tracefs_option_enable(instance, TRACEFS_OPTION_EVENT_FORK) < 0 ||
>> +	   tracefs_option_enable(instance, TRACEFS_OPTION_FUNCTION_FORK) < 0 ||
>> +	   !set_pid(instance, "set_ftrace_pid", getpid()) ||
>> +	   !set_pid(instance, "set_event_pid", getpid()))
>> +		exit(1);
> So trace cruncher will only trace the given process and its children.
> There's no other alternative?
> 

Of course not. This is just a static helper function that is used by the 
trace_shell_process(). It has no exposure to the user of the module.

trace_shell_process() on the other hand is part of the API of the module 
and indeed will trace only one process.

It is just the first method to be implemented. You will see more methods 
for tracing in the incoming patches.

But you are right that I have to rename start_tracing(), so that it 
doesn't sound like something that has a more general use.


Thanks!

Yordan




> -- Steve
> 
> 
> 
>> +
>> +	tracing_ON(instance);
>> +	if (execve(argv[0], argv, env) < 0) {
>> +		PyErr_Format(TFS_ERROR, "Failed to exec \'%s\'",
>> +			     argv[0]);
>> +	}
>> +
>> +	exit(1);
>> +}
>> +
>> +static int callback(struct tep_event *event, struct tep_record *record,
>> +		    int cpu, void *py_func)
>> +{
>> +	record->cpu = cpu; // Remove when the bug in libtracefs is fixed.
>> +
>> +	PyObject *py_tep_event = PyTepEvent_New(event);
>> +	PyObject *py_tep_record = PyTepRecord_New(record);
>> +
>> +	PyObject *arglist = PyTuple_New(2);
>> +	PyTuple_SetItem(arglist, 0, py_tep_event);
>> +	PyTuple_SetItem(arglist, 1, py_tep_record);
>> +
>> +	PyObject_CallObject((PyObject *) py_func, arglist);
>> +
>> +	return 0;
>> +}
>> +
>> +PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
>> +						       PyObject *kwargs)
>> +{
>> +	const char *plugin = "__main__", *py_callback = "callback";
>> +	char *process, *instance_name;
>> +	struct tracefs_instance *instance;
>> +	static char *kwlist[] = {"process", "plugin", "callback", "instance", NULL};
>> +	struct tep_handle *tep;
>> +	PyObject *py_func;
>> +	pid_t pid;
>> +
>> +	instance_name = NO_ARG;
>> +	if(!PyArg_ParseTupleAndKeywords(args,
>> +					kwargs,
>> +					"s|sss",
>> +					kwlist,
>> +					&process,
>> +					&plugin,
>> +					&py_callback,
>> +					&instance_name)) {
>> +		return NULL;
>> +	}
>> +
>> +	py_func = get_callback_func(plugin, py_callback);
>> +	if (!py_func)
>> +		return NULL;
>> +
>> +	if (!get_optional_instance(instance_name, &instance))
>> +		return NULL;
>> +
>> +	tep = tracefs_local_events(tracefs_instance_get_dir(instance));
>> +
>> +	char *argv[] = {getenv("SHELL"), "-c", process, NULL};
>> +	char *env[] = {NULL};
>> +
>> +	pid = fork();
>> +	if (pid < 0) {
>> +		PyErr_SetString(TFS_ERROR, "Failed to fork");
>> +		return NULL;
>> +	}
>> +
>> +	if (pid == 0)
>> +		start_tracing(instance, argv, env);
>> +
>> +	do {
>> +		tracefs_iterate_raw_events(tep, instance, NULL, 0, callback, py_func);
>> +	} while (waitpid(pid, NULL, WNOHANG) != pid);
>> +
>> +	Py_RETURN_NONE;
>> +}
>> +
