Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAE6C2BB86
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 02:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AD7A2076D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 02:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403915AbgDNB76 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:59:58 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:22422 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727867AbgDNB75 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Apr 2020 21:59:57 -0400
X-IronPort-AV: E=Sophos;i="5.72,381,1580745600"; 
   d="scan'208";a="88984692"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 14 Apr 2020 09:59:53 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 4E67649DF135;
        Tue, 14 Apr 2020 09:49:22 +0800 (CST)
Received: from [10.167.220.69] (10.167.220.69) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 14 Apr 2020 09:59:50 +0800
Message-ID: <5E951914.70104@cn.fujitsu.com>
Date:   Tue, 14 Apr 2020 09:59:48 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.2; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tracing: Fix the race between registering 'snapshot'
 event trigger and triggering 'snapshot' operation
References: <20200413071252.13720-1-yangx.jy@cn.fujitsu.com> <20200413110207.01a48591@gandalf.local.home>
In-Reply-To: <20200413110207.01a48591@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.220.69]
X-ClientProxiedBy: G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) To
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206)
X-yoursite-MailScanner-ID: 4E67649DF135.AAE37
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2020/4/13 23:02, Steven Rostedt wrote:
> On Mon, 13 Apr 2020 15:12:52 +0800
> Xiao Yang<yangx.jy@cn.fujitsu.com>  wrote:
>
>> Traced event can trigger 'snapshot' operation(i.e. calls snapshot_trigger()
>> or snapshot_count_trigger()) when register_snapshot_trigger() has completed
>> registration but doesn't allocate spare buffer for 'snapshot' event trigger.
>> 'snapshot' operation always detects the lack of allocated buffer in the rare
>> case so make register_snapshot_trigger() allocate spare buffer first.
>>
>> trigger-snapshot.tc in kselftest reproduces the issue on slow vm:
>> -----------------------------------------------------------
>> cat trace
>> ...
>> ftracetest-3028  [002] ....   236.784290: sched_process_fork: comm=ftracetest pid=3028 child_comm=ftracetest child_pid=3036
>>       <...>-2875  [003] ....   240.460335: tracing_snapshot_instance_cond: *** SNAPSHOT NOT ALLOCATED ***
>>       <...>-2875  [003] ....   240.460338: tracing_snapshot_instance_cond: *** stopping trace here!   ***
>> -----------------------------------------------------------
>>
>> Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
>> ---
>>   kernel/trace/trace_events_trigger.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
>> index dd34a1b46a86..00e54cdcef3e 100644
>> --- a/kernel/trace/trace_events_trigger.c
>> +++ b/kernel/trace/trace_events_trigger.c
>> @@ -1088,9 +1088,13 @@ register_snapshot_trigger(char *glob, struct event_trigger_ops *ops,
>>   			  struct event_trigger_data *data,
>>   			  struct trace_event_file *file)
>>   {
>> -	int ret = register_trigger(glob, ops, data, file);
>> +	int alloc_ret, ret;
>>
>> -	if (ret>  0&&  tracing_alloc_snapshot_instance(file->tr) != 0) {
>> +	alloc_ret = tracing_alloc_snapshot_instance(file->tr);
>> +
>> +	ret = register_trigger(glob, ops, data, file);
>> +
>> +	if (ret>  0&&  alloc_ret != 0) {
>>   		unregister_trigger(glob, ops, data, file);
>>   		ret = 0;
>>   	}
>
>
> Why register if the allocation failed? Just switch the logic:
>
> 	int ret = tracing_alloc_snapshot_instance(file->tr);
>
> 	if (ret != 0)
> 		return 0;
>
> 	return register_trigger(glob, ops, data, file);
Hi Steve,

It looks simpler and better.
I think we can drop the unnecessary ret variable as well.

Thanks,
Xiao Yang
>
>
> -- Steve
>
>
> .
>



