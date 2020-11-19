Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CB6C56201
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F9222260
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Nov 2020 16:14:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ahCg+t09"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgKSQOk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Nov 2020 11:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727369AbgKSQOk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Nov 2020 11:14:40 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874ADC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 08:14:39 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id cq7so6418748edb.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Nov 2020 08:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UDMNx3osM7xzYks+bAg93vuieaKTHMnRTzCDZL7Zl0A=;
        b=ahCg+t099BInT9lNliyJA7/oyrBIpCwOEKPXZ0BWiEX7BL+XvitUDjTk6mIgpJ8DKz
         QUv2NSPbsLQx3S6A4AWQcdfpVi/xfr9ydjLrbVsd6drZedc/+6oLNWBuRzx70N8wRsjd
         bmY+t6HyEqUVjIbFofyvPLsfuSI3q4VMFsjobkHS48MC85FKdpqFPvEPhv3XPnvN53JK
         IZriRKXtYSaEbmE2XzZFHla566eWnGhLQpwjCLlFTaXujAdy6sTrIB2G2B6VbpKXWKy1
         C6Aj1UdECQY+eMLUiv70lamNS9WrieeG2LnXysUB6wbOrodB2Da/Vyo7IzIAoIv1gjC4
         5dug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UDMNx3osM7xzYks+bAg93vuieaKTHMnRTzCDZL7Zl0A=;
        b=RorVFwnuSuBqrXL7K+U7+V2xFz8uX0zoFaubbajYeWU7E/1zKy4ygWJcfB/O42JdRN
         zv+CUSmZXkzmwQi/pffJGkQAcdu2fIUGGiqQD/SWxsfbwGFV2Muay8FvDeReEstRx2tK
         /owDHPASZu3tWxLCGoU2fp7U6sw/YwfB+LqqBugo2ZM8C8O8Wu0/PPXpGbQtjkwphCX2
         c/FR7Wjrpv5szduJlavUQ1YYJp/dSlny1BbK/q01CnVjE86X33Q3cW+DwXUX6pI+IEQB
         L/AmFVvVujJse5LKsFvCC1bNj0f6RW5DFc4H+8BF6wLWmSNuYgTHt6bSxUgOmaVfppHu
         h4wQ==
X-Gm-Message-State: AOAM531NexFrgo096WBJbVN2XKtVjd5mWNX3TAX2uBK06QX2u/ApnIjK
        JoBMqHIc4j7yIo1WnbHxe6O5XNORlvI=
X-Google-Smtp-Source: ABdhPJxfTae+BBE1ZpH/N67acSEX8Paq2YPXJM5ZzyKlhz3nzT3lkvu73HX02Fle8x/xXFdtbbelRg==
X-Received: by 2002:aa7:d356:: with SMTP id m22mr31254964edr.270.1605802477937;
        Thu, 19 Nov 2020 08:14:37 -0800 (PST)
Received: from [192.168.0.108] ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id e10sm945241eds.8.2020.11.19.08.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 08:14:37 -0800 (PST)
Subject: Re: [PATCH v4 14/20] kernel-shark: Provide merging of multiple data
 streams
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
References: <20201118145003.156542-1-y.karadz@gmail.com>
 <20201118145003.156542-15-y.karadz@gmail.com>
 <20201118210025.0bc6326b@oasis.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <83fe0b27-f5cb-a1cf-6afd-bf48cd2f61bc@gmail.com>
Date:   Thu, 19 Nov 2020 18:14:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201118210025.0bc6326b@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 19.11.20 г. 4:00 ч., Steven Rostedt wrote:
> On Wed, 18 Nov 2020 16:49:57 +0200
> "Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:
> 
>> The C API provides loading of the trace data in two different forms.
>> The firs one is an array of kshark_entries and is being used by the
> 
>    "first one"
> 
>> KernelShark GUI. The second is a matrix-like structure that has all
>> the fields of the kshark_entry stored in separate arrays, forming the
>> columns of the matrix. The second form of the data is used by
>> trace-cruncher. In this patch we add methods for merging of several
>> data streams into a single data set. Both kshark_entries and matrix
>> forms of the data are supported. This patch includes a simple example
>> that demonstrate how to open a file that contains multiple buffers.
>> Each buffers is loaded into a separate Data stream and those streams
>> are merged together.
>>
>> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>> ---
>>   examples/CMakeLists.txt    |   4 +
>>   examples/multibufferload.c |  60 +++++++++
>>   src/libkshark.c            | 255 +++++++++++++++++++++++++++++++++++++
>>   src/libkshark.h            |  47 +++++++
>>   4 files changed, 366 insertions(+)
>>   create mode 100644 examples/multibufferload.c
>>
>> diff --git a/examples/CMakeLists.txt b/examples/CMakeLists.txt
>> index 8d40e42c..831eee24 100644
>> --- a/examples/CMakeLists.txt
>> +++ b/examples/CMakeLists.txt
>> @@ -8,6 +8,10 @@ message(STATUS "datafilter")
>>   add_executable(dfilter          datafilter.c)
>>   target_link_libraries(dfilter   kshark)
>>   
>> +message(STATUS "multibufferload")
>> +add_executable(mbload          multibufferload.c)
>> +target_link_libraries(mbload   kshark)
>> +
>>   # message(STATUS "datahisto")
>>   # add_executable(dhisto          datahisto.c)
>>   # target_link_libraries(dhisto   kshark)
>> diff --git a/examples/multibufferload.c b/examples/multibufferload.c
>> new file mode 100644
>> index 00000000..70b2733a
>> --- /dev/null
>> +++ b/examples/multibufferload.c
>> @@ -0,0 +1,60 @@
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +
>> +#include "libkshark.h"
>> +#include "libkshark-tepdata.h"
>> +
>> +const char *default_file = "trace.dat";
>> +
>> +void put_entry(struct kshark_entry *e)
>> +{
>> +	char *entry_str = kshark_dump_entry(e);
>> +	puts(entry_str);
>> +	free(entry_str);
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +	struct kshark_context *kshark_ctx;
>> +	struct kshark_entry **data = NULL;
>> +	ssize_t r, n_rows;
>> +	int sd;
>> +
>> +	/* Create a new kshark session. */
>> +	kshark_ctx = NULL;
>> +	if (!kshark_instance(&kshark_ctx))
>> +		return 1;
>> +
>> +	/* Open a trace data file produced by trace-cmd. */
>> +	if (argc > 1)
>> +		sd = kshark_open(kshark_ctx, argv[1]);
>> +	else
>> +		sd = kshark_open(kshark_ctx, default_file);
> 
> I'm confused. It doesn't look like this merges more than one stream.


Hi Steven,

Here it only opens the "top" buffer in the file.

> 
> -- Steve
> 
>> +
>> +	if (sd < 0) {
>> +		kshark_free(kshark_ctx);
>> +		return 1;
>> +	}
>> +
>> +	/* Initialize data streams for all buffers in this file. */
>> +	kshark_tep_init_all_buffers(kshark_ctx, sd);

And here is the place where it opens in separate streams the other 
buffers that are in the same file.


>> +
>> +	/* Load all buffers. */
>> +	n_rows = kshark_load_all_entries(kshark_ctx, &data);
>> +

Here it loads and merges the entries from all buffers.

Thanks!
Yordan

>> +	/* Print to the screen the first 20 entries. */
>> +	for (r = 0; r < 20; ++r)
>> +		put_entry(data[r]);
>> +
>> +	/* Free the memory. */
>> +	for (r = 0; r < n_rows; ++r)
>> +		free(data[r]);
>> +	free(data);
>> +
>> +	kshark_close_all(kshark_ctx);
>> +
>> +	/* Close the session. */
>> +	kshark_free(kshark_ctx);
>> +
>> +	return 0;
>> +}
