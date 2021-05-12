Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF83C433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 14:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31EED613E9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 14:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhELOKT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 10:10:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230018AbhELOKT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 10:10:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620828551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7QkPOsq+oUUheJncqyWlnuLBk6Av4xMDfqYvMXLut1w=;
        b=VlbotGBxNuBW6PA2htzRkMoeTM3umDSTy1Vn7hdtzwFsjVc6GKDG8IpDcABmJgBN3WoqJO
        /iZ53TDxp2R3aojfcOPatIDRObuAcJ1Nrj1QD0PH8JE+WS2r6Rms+KQie0tsGP1cgjA482
        CMmsoE4VSXZxZd/38DzgAjSk73jy1dk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-Hss0LIZhNF-lxohzv8RJUg-1; Wed, 12 May 2021 10:09:09 -0400
X-MC-Unique: Hss0LIZhNF-lxohzv8RJUg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1CB5B6D5C8;
        Wed, 12 May 2021 14:09:08 +0000 (UTC)
Received: from [10.40.208.59] (unknown [10.40.208.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD6B7E71B;
        Wed, 12 May 2021 14:09:06 +0000 (UTC)
Subject: Re: trace-cmd profile is not working
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
References: <8c1d353e-05d5-d789-00a2-de94d705950e@redhat.com>
 <20210512095541.4dcfdb4d@gandalf.local.home>
From:   Jerome Marchand <jmarchan@redhat.com>
Message-ID: <f35477a7-c301-655e-940a-bcc6b38c44f0@redhat.com>
Date:   Wed, 12 May 2021 16:09:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512095541.4dcfdb4d@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 12/05/2021 15:55, Steven Rostedt wrote:
> On Wed, 12 May 2021 15:51:52 +0200
> Jerome Marchand <jmarchan@redhat.com> wrote:
> 
>> Hi,
>>
>> Streams, and thus trace-cmd profile, are not working. A simple
>> "trace-cmd profile ls" command exit with the following message
>> "Creating stream for 0". I've been looking at it and the issue is that
>> tracecmd_read_headers() tries to read the cmdlines, cpus and options
>> sections that have not been written to the temporary file when called
>> from trace_stream_init().
>>
>> AFAICT, it is caused by the two following patches:
>>
>> commit 1eea02a4 ("trace-cmd: Write saved cmdlines in the trace file at
>> the end of the trace.") which moved the writing of cmdlines from
>> create_file_fd() to tracecmd_create_file_latency() and
>> tracecmd_append_cpu_data()
>>
>> commit 5d4d7ec3 ("trace-cmd: Move reading of trace.dat options to
>> tracecmd_read_headers()") which moved the reading of options and cpu
>> datas to tracecmd_read_headers().
>>
> 
> Thanks for the report. I'm not surprised, profiling and streams have not
> been given the love they deserve (been focusing on host/guest tracing
> recently).
> 
> Can you fill out a bug report on bugzilla?

Sure thing:
https://bugzilla.kernel.org/show_bug.cgi?id=213045

Jerome

> 
>    https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&list_id=1090417&product=Tools&resolution=---
> 
> Thanks!
> 
> -- Steve
> 

