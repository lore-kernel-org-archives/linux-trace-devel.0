Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	DATE_IN_FUTURE_24_48,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FDAC433B4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 00:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02A526117A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 00:43:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhDFAoF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 20:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbhDFAoF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 20:44:05 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA989C06174A
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 17:43:57 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id y32so5979158pga.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 17:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=8GdI41lSNfxuPA1c5U94Afa4LU/EzgxtHgHX5J5xBug=;
        b=aKbHNxdTR7qsjHe5sYL30R2JKWsA0VWHRpOQgIc7SQHwPsdal7LYXvKkjDuIyvhl0k
         mLDn9yyfVAcFq60/NNiPG0p8+H3F2NgAOqJBMA7g5PL/wXV1DJ2AJSHiVC6Xy/t/TOFD
         K53qCZVVtDpApWam0ktvI4lWhImeMXe0TuJIkfl+HFQ76CZQ06nUW4U/jf0ecLrFtlhO
         wDxDTFjxdxONH4jTas8Hb+tzgpJeZiTt27cpmhO/60UyZYTwpatQna3JglmCfbNZA5Ew
         KKjLOxMSaSAfIGAIVgSfEf73BEQx05fkCCeje8c3ueUrmIB4wm96KXo1mtNRMtSGr/4h
         nfEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8GdI41lSNfxuPA1c5U94Afa4LU/EzgxtHgHX5J5xBug=;
        b=Ic/ZZZZg1ghrsHXuuu1V695JV+KjtGhaYg420do8KO6uXt9hcvCWqkBmqftbQLhFV8
         ovY3r9XDETVxJqgDWk2B90ShmYf61SOz5qTDzmBPy+UhvA/XkfpX1Zlc5lgqo/syX1je
         BOwFRjdArtN3uWo0+tB2GvQHpRp0/oFBJLpaKQJVK/e1tDGDNah26fOCnqrO81+1JOF7
         9UoCJR9wKeBHGXdJnHEg9KwyGZB9qyq0LscYC8WVvxeZD1HaoK36rOibQFO/hS80v1GH
         Etj9MmApgGHpF+4c5igZbWM21fXjKQ3XzIxi7NhgrmgO7lI8s0GJFeZZ7ivvglMZhmUv
         BZ3g==
X-Gm-Message-State: AOAM532t5bQInsawry6FG7z+j7hxfgR7rDWuxsDBJ2wEtrq2nOm6zo+x
        GFilWOl8m3C3OewaDvojt3OAScDA2M7Zvw==
X-Google-Smtp-Source: ABdhPJwJlqsq6qQ19YBGoDqfiiZ5XgVksuvxTf+kETGGLobov2ShMt3ABA6NZDpczAacSIeWNpf8+g==
X-Received: by 2002:a05:6a00:14d3:b029:222:b711:3326 with SMTP id w19-20020a056a0014d3b0290222b7113326mr25710376pfu.28.1617669837299;
        Mon, 05 Apr 2021 17:43:57 -0700 (PDT)
Received: from [192.168.0.115] ([45.118.75.3])
        by smtp.gmail.com with ESMTPSA id l10sm16862166pga.8.2021.04.05.17.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 17:43:56 -0700 (PDT)
Subject: Re: [PATCH] libtracefs: Unit test for the tracing filter API
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
References: <1617415260-19795-1-git-send-email-sameeruddin.shaik8@gmail.com>
 <20210402105617.2bf3a438@gandalf.local.home>
From:   sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Message-ID: <d8ef0d23-0765-51b2-be50-eba9282a879a@gmail.com>
Date:   Wed, 7 Apr 2021 06:14:28 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210402105617.2bf3a438@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


On 02/04/21 8:26 pm, Steven Rostedt wrote:
> On Sat,  3 Apr 2021 07:31:00 +0530
> Sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:
>
>> tracefs_function_filter();
> Need some more information in the change log. What is this testing?
>
>> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
>>
>> diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
>> index ed2693b..09e564f 100644
>> --- a/utest/tracefs-utest.c
>> +++ b/utest/tracefs-utest.c
>> @@ -11,6 +11,7 @@
>>   #include <time.h>
>>   #include <dirent.h>
>>   #include <ftw.h>
>> +#include <errno.h>
>>   
>>   #include <CUnit/CUnit.h>
>>   #include <CUnit/Basic.h>
>> @@ -1020,6 +1021,80 @@ static void test_custom_trace_dir(void)
>>   	free(dname);
>>   }
>>   
>> +static int test_instance_filter(struct tracefs_instance *instance,
>> +				const char **filters, const char *module,
>> +				int flags)
>> +{
>> +	int ret;
>> +	int i;
>> +
>> +	if (filters) {
>> +		for (i = 0; filters[i]; i++) {
>> +			ret = tracefs_function_filter(instance, filters[i],
>> +						      module, flags);
>> +			if (ret) {
>> +				if (errno == EINVAL)
>> +					printf("Filter %s did not match\n",
>> +					       filters[i]);
>> +				else
>> +					printf("Failed writing %s\n",
>> +					       filters[i]);
>> +			}
>> +		}
>> +	} else {
>> +		ret = tracefs_function_filter(instance, NULL, module, flags);
>> +	}
>> +	return ret;
>> +}
>> +
>> +static void test_tracefs_function_filter(void)
>> +{
>> +	const char *filter[] = {"run_init_process", "ufs*", "^ext4.*$", NULL};
> I ran this and it failed, because my box has no functions that start with
> "ufs" nor "ext4" (I use an xfs file system).
>
> You need to use core function names like "sched*" or "irq*", because ufs
> and ext4 are modules that do not exist in all machines that this may be
> executed on.
>
>> +	const char *future_filter[] = {"write_dummy", "read_dummy", NULL};
>> +	const char *future_module = "dummy";
>> +	struct tracefs_instance *instance;
>> +	const char *module = "btrtl";
> I also do not have the btrtl module. You may need to see what modules are
> loaded (reading /proc/modules will help you there).
>
>> +	int ret;
>> +
>> +	instance = tracefs_instance_create(TEST_INSTANCE_NAME);
>> +	CU_TEST(instance != NULL);
>> +
>> +	ret = tracefs_function_filter(instance, NULL, NULL,
>> +				      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
>> +	if (ret) {
>> +		printf("Failed to reset the filter\n");
> Should the above be a CU_TEST failure?
> +		if (ret < 0)
> +			tracefs_function_filter(instance, NULL, NULL, 0);
> +	}
> +	/* Test string, kernel glob and regex for specific_instance*/
> +	ret = test_instance_filter(instance, filter, NULL, TRACEFS_FL_CONTINUE);
> +	CU_ASSERT(ret == 0);
> +	/* Test Module only with no filters*/
> +	ret = test_instance_filter(instance, NULL, module, TRACEFS_FL_CONTINUE);
> +	CU_ASSERT(ret == 0);
> +	ret = test_instance_filter(instance, future_filter, future_module,
> +				   TRACEFS_FL_CONTINUE | TRACEFS_FL_FUTURE);
> +	CU_ASSERT(ret == 0);
> +	tracefs_function_filter(instance, NULL, NULL, 0);
> Should the above result also be tested?

Is it really needs to be tested?, because anyhow if we have any error, 
it will be thrown at the above lines

But anyhow, i will test the result here, since we are commiting the 
changes in the file.

>> +
>> +	ret = tracefs_function_filter(NULL, NULL, NULL,
>> +				      TRACEFS_FL_RESET | TRACEFS_FL_CONTINUE);
>> +	if (ret) {
> And here too.
okay.
>> +		printf("Failed to reset the filter\n");
>> +		if (ret < 0)
>> +			tracefs_function_filter(instance, NULL, NULL, 0);
>> +	}
>> +	/* Test top instance*/
>> +	ret = test_instance_filter(NULL, filter, NULL, TRACEFS_FL_CONTINUE);
>> +	CU_ASSERT(ret == 0);
>> +	ret = test_instance_filter(NULL, NULL, module, TRACEFS_FL_CONTINUE);
> As I stated above, I don't have the module you picked, and will most
> definitely fail this test as FUTURE is not set.

Yeah will try to add some standard modules.

Thanks,

sameer.


