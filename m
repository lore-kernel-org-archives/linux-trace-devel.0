Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3DEEB64DD
	for <linux-trace-devel@archiver.kernel.org>; Sat,  5 Aug 2023 03:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjHED55 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Aug 2023 23:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjHED5y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Aug 2023 23:57:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE7913E;
        Fri,  4 Aug 2023 20:57:53 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RHpcJ5SlGztRhG;
        Sat,  5 Aug 2023 11:54:24 +0800 (CST)
Received: from [10.174.176.219] (10.174.176.219) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sat, 5 Aug 2023 11:57:48 +0800
Subject: Re: How to solve the coupling between libtraceevent and kernel trace?
To:     Steven Rostedt <rostedt@goodmis.org>, <mchehab@kernel.org>
CC:     <linux-trace-users@vger.kernel.org>,
        <linux-trace-devel@vger.kernel.org>,
        "Fangxiuning (Jack, EulerOS)" <fangxiuning@huawei.com>
References: <4767bcf3-589a-9dfb-5b45-9ac9279f08e6@huawei.com>
 <20230804121531.06f7bf0e@gandalf.local.home>
From:   Lv Ying <lvying6@huawei.com>
Message-ID: <47475eaa-229e-f1bd-dcc7-31427f130ca3@huawei.com>
Date:   Sat, 5 Aug 2023 11:57:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20230804121531.06f7bf0e@gandalf.local.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.219]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven:

Sorry for the same message, I failed to add Mauro to the discussion, so 
I resend the same thread.

On 2023/8/5 0:15, Steven Rostedt wrote:
> On Fri, 4 Aug 2023 17:52:48 +0800
> Lv Ying <lvying6@huawei.com> wrote:
> 
>> Hi, all:
>>
>> I am a rasdaemon developer which depeneds on libtraceevent to parse
>> kernel trace events. There is coupling between libtraceevnt and kernel
>> trace, if something in libtraceevent and kernel does not match, which
>> will cause libtraceevent parse wrong thing. e.g
>> https://github.com/mchehab/rasdaemon/pull/98
>>
>> We also encounter similar problem:
>> * libtrace(old) KBUFFER_TYPE_TIME_STAMP size = 12
>> * kernel(new) KBUFFER_TYPE_TIME_STAMP size = 8
>> Such mismatch will cause strange behavior when parsing trace events.
> 
> So what happened was the old 12 byte version of TIME_STAMP was never
> actually implemented in the kernel. When we finally got around to
> implementing it, we only needed 8 bytes for it, so it became 8 bytes.
> 
> I made the mistake of adding that code in kbuffer.c before it was ever
> implemented in the kernel and said it would be 12 bytes.
> 
I find this kernel 
patch(https://lore.kernel.org/all/477b362dba1ce7fab9889a1a8e885a62c472f041.1516069914.git.tom.zanussi@linux.intel.com/T/#u) 
change TIME_STAMP to 8 bytes. Maybe this commit is the first time 
RINGBUF_TYPE_TIME_STAMP is really implemented in the kernel.

When rasdaemon use old libtrace(12 byte version of TIME_STAMP) on newer 
kernel(8 bytes version of RINGBUF_TYPE_TIME_STAMP). Libtrace takes too 
long to parse timestamp events and appends the first 4 bytes of the next 
trace event as the last 4 bytes of the timestamp event. Such wrong 
parsing will lead to completely wrong parsing of the adjacent trace 
event field. For example, in rasdaemon we have a situation like this, 
libtrace parse devlink_health_report trace event next timestamp trace 
event as block_rq_complete trace event, which will cause coredump in 
block_rq_complete rasdaemon handler.
>>
>> So if libtraceevent is released out of(independent) kernel, how does
>> libtraceevnt to keep compatible with the running kernel(maybe not the
>> newest)?
>>
> 
> Now that it has been implemented, it's not going to change. 8 bytes is now
> an API. Any more updates should not cause a problem with libtraceevent as
> there's many more tools that depend on it working. And the fact that it is
> no longer in the kernel, guarantees more that the interface will remain
> stable.
> 
I am worried similar libtraceevent-kernel compatibility problem. I think 
it's a good way to sort out the interfaces that libtraceevent depends on 
the kernel and add test cases to determine whether libtraceevent can run 
on the current kernel, or to know which interfaces do not match.

> rasdaemon should be using the external libtraceevent library because it
> will be able to get more information out of any new data. Newer kernels
> should not break existing libtracevent, but it may just skip over new
> features.
> 
> -- Steve
> 
> .
> 
rasdaemon now use the external libtraceevent, but rasdaemon will be 
shipped in many version OS by OSV, so how to ensure that rasdaemon runs 
correctly on various kernel versions using external libtraceevent needs 
to be considered.

-- 
Thanks!
Lv Ying
