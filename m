Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3027DC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 10:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14D7B61406
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 10:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhENKpv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 06:45:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231941AbhENKpt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 06:45:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620989078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5OJksD4FXwzVXvugV2dt+GnPE2KLuC/2FaMVq4+6DxM=;
        b=ScMnVHRHCWNn0+XMeWFUy4fkvYChgXcS8ye150cGR2Y7FBqdK03k/sWtHUx71vF2y40oQf
        CeMmIG/DeTQVeMkvNRQdloZAfsiIEzRNkgSuQ2UnlI6hDw/iYQqfW1ibOiOQkDX1377ky0
        bJ09yGbUunduT3vHdyUko82Zo7XVfzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-x36sP7GaM7WokQwDAy2u7w-1; Fri, 14 May 2021 06:44:36 -0400
X-MC-Unique: x36sP7GaM7WokQwDAy2u7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA4011005582;
        Fri, 14 May 2021 10:44:34 +0000 (UTC)
Received: from [10.40.208.50] (unknown [10.40.208.50])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AE61776E33;
        Fri, 14 May 2021 10:44:33 +0000 (UTC)
Subject: Re: trace-cmd profile is not working
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <8c1d353e-05d5-d789-00a2-de94d705950e@redhat.com>
 <20210512095541.4dcfdb4d@gandalf.local.home>
 <f35477a7-c301-655e-940a-bcc6b38c44f0@redhat.com>
 <CAPpZLN6x-SeP7FtkD1Oopa7fj-HLxj47SJi3ATkdvjcfyhunKw@mail.gmail.com>
From:   Jerome Marchand <jmarchan@redhat.com>
Message-ID: <5f7f058c-d4de-1e49-e9ec-2a18e59fa6e4@redhat.com>
Date:   Fri, 14 May 2021 12:44:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAPpZLN6x-SeP7FtkD1Oopa7fj-HLxj47SJi3ATkdvjcfyhunKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 14/05/2021 09:56, Tzvetomir Stoyanov wrote:
> Hi Jerome,
> 
> On Wed, May 12, 2021 at 5:09 PM Jerome Marchand <jmarchan@redhat.com> wrote:
>>
>> On 12/05/2021 15:55, Steven Rostedt wrote:
>>> On Wed, 12 May 2021 15:51:52 +0200
>>> Jerome Marchand <jmarchan@redhat.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> Streams, and thus trace-cmd profile, are not working. A simple
>>>> "trace-cmd profile ls" command exit with the following message
>>>> "Creating stream for 0". I've been looking at it and the issue is that
>>>> tracecmd_read_headers() tries to read the cmdlines, cpus and options
>>>> sections that have not been written to the temporary file when called
>>>> from trace_stream_init().
>>>>
>>>> AFAICT, it is caused by the two following patches:
>>>>
>>>> commit 1eea02a4 ("trace-cmd: Write saved cmdlines in the trace file at
>>>> the end of the trace.") which moved the writing of cmdlines from
>>>> create_file_fd() to tracecmd_create_file_latency() and
>>>> tracecmd_append_cpu_data()
>>>>
>>>> commit 5d4d7ec3 ("trace-cmd: Move reading of trace.dat options to
>>>> tracecmd_read_headers()") which moved the reading of options and cpu
>>>> datas to tracecmd_read_headers().
>>>>
>>>
>>> Thanks for the report. I'm not surprised, profiling and streams have not
>>> been given the love they deserve (been focusing on host/guest tracing
>>> recently).
>>>
>>> Can you fill out a bug report on bugzilla?
>>
>> Sure thing:
>> https://bugzilla.kernel.org/show_bug.cgi?id=213045
>>
>> Jerome
>>
>>>
>>>     https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&list_id=1090417&product=Tools&resolution=---
>>>
>>> Thanks!
>>>
> 
> I've submitted a fix for this, please can you verify if it fixes the problem.
> Thanks for testing this code and reporting bugs!

Yes, it does fixes the issue have been seeing.

Thanks,
Jerome

> 
>>> -- Steve
>>>
>>
> 
> 

