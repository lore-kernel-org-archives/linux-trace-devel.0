Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E58C001DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 02:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjHHCgW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 7 Aug 2023 22:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjHHCgW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 7 Aug 2023 22:36:22 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0150DB8;
        Mon,  7 Aug 2023 19:36:19 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RKcgY0pQgz1Z1cH;
        Tue,  8 Aug 2023 10:33:29 +0800 (CST)
Received: from [10.174.176.219] (10.174.176.219) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 10:36:17 +0800
Subject: Re: How to solve the coupling between libtraceevent and kernel trace?
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     <mchehab@kernel.org>, <linux-trace-users@vger.kernel.org>,
        <linux-trace-devel@vger.kernel.org>,
        "Fangxiuning (Jack, EulerOS)" <fangxiuning@huawei.com>
References: <4767bcf3-589a-9dfb-5b45-9ac9279f08e6@huawei.com>
 <20230804121531.06f7bf0e@gandalf.local.home>
 <47475eaa-229e-f1bd-dcc7-31427f130ca3@huawei.com>
 <20230807210937.3ece4d63@gandalf.local.home>
From:   Lv Ying <lvying6@huawei.com>
Message-ID: <03d598ef-864d-c6d7-2c6f-65744b32eb2d@huawei.com>
Date:   Tue, 8 Aug 2023 10:36:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20230807210937.3ece4d63@gandalf.local.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.219]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven:

On 2023/8/8 9:09, Steven Rostedt wrote:
> On Sat, 5 Aug 2023 11:57:48 +0800
> Lv Ying<lvying6@huawei.com>  wrote:
> 
>> I find this kernel
>> patch(https://lore.kernel.org/all/477b362dba1ce7fab9889a1a8e885a62c472f041.1516069914.git.tom.zanussi@linux.intel.com/T/#u)
>> change TIME_STAMP to 8 bytes. Maybe this commit is the first time
>> RINGBUF_TYPE_TIME_STAMP is really implemented in the kernel.
> Yes, I know what caused the breakage.
> 
>> When rasdaemon use old libtrace(12 byte version of TIME_STAMP) on newer
>> kernel(8 bytes version of RINGBUF_TYPE_TIME_STAMP). Libtrace takes too
>> long to parse timestamp events and appends the first 4 bytes of the next
>> trace event as the last 4 bytes of the timestamp event. Such wrong
>> parsing will lead to completely wrong parsing of the adjacent trace
>> event field. For example, in rasdaemon we have a situation like this,
>> libtrace parse devlink_health_report trace event next timestamp trace
>> event as block_rq_complete trace event, which will cause coredump in
>> block_rq_complete rasdaemon handler.
>>>> So if libtraceevent is released out of(independent) kernel, how does
>>>> libtraceevnt to keep compatible with the running kernel(maybe not the
>>>> newest)?
>>>>   
>>> Now that it has been implemented, it's not going to change. 8 bytes is now
>>> an API. Any more updates should not cause a problem with libtraceevent as
>>> there's many more tools that depend on it working. And the fact that it is
>>> no longer in the kernel, guarantees more that the interface will remain
>>> stable.
>>>    
>> I am worried similar libtraceevent-kernel compatibility problem. I think
>> it's a good way to sort out the interfaces that libtraceevent depends on
>> the kernel and add test cases to determine whether libtraceevent can run
>> on the current kernel, or to know which interfaces do not match.
>>
>>> rasdaemon should be using the external libtraceevent library because it
>>> will be able to get more information out of any new data. Newer kernels
>>> should not break existing libtracevent, but it may just skip over new
>>> features.
>>>
>>> -- Steve
>>>
>>> .
>>>    
>> rasdaemon now use the external libtraceevent, but rasdaemon will be
>> shipped in many version OS by OSV, so how to ensure that rasdaemon runs
>> correctly on various kernel versions using external libtraceevent needs
>> to be considered.
>>

> The latest libtraceevent and libtracefs should work with all previous
> versions of the kernel. TIMESTAMP was not implemented in the kernel when
> kbuffer.c added it. That was my mistake and it will not happen again.
> 
> trace-cmd uses the latest libtracevent and libtracefs, and it works on
> kernels back to 2.6.32 (when tracing was added). Using the latest
> libtraceevent will work on all older kernels.
> 
> All should be good. What exactly are you worried about?


I didn't know much about kernel tracefs before, so I thought there was a 
compatibility problem like timestamp. After your answer, I know that 
timestamp is an exception. I can now happily use libtraceevent directly 
on different versions of the kernel.

Thanks again for your answer :)

-- 
Thanks!
Lv Ying
