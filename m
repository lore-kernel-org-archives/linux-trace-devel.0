Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70412C56201
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 19:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3FC22222F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 19:03:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.b="oprDb/vh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbgKTTDC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 14:03:02 -0500
Received: from mail.efficios.com ([167.114.26.124]:32996 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730102AbgKTTDC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 14:03:02 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id C55562F9F4E;
        Fri, 20 Nov 2020 14:03:00 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id efI1kqa5NS0P; Fri, 20 Nov 2020 14:03:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 85C2C2F9DD3;
        Fri, 20 Nov 2020 14:03:00 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 85C2C2F9DD3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1605898980;
        bh=2lWBfeEhSCmcICw5sckC5DFcqjwL1tQ46GUr03zBoRc=;
        h=To:From:Message-ID:Date:MIME-Version;
        b=oprDb/vh7lPPgtKDZqjAvIuEoT58VHdNjoqUercMdAjHdATesmTQ6windEMggp7xO
         v/3QfyKx4YTohnvueyiYTGgNkyXU+yBZEaeSy458nJdVnEe8bK8O7GwYPNRlb1AJPI
         u24T8/gbU2my0Hmj+ijn3tPguIwL3HmW9i8Y20bDsmZy0xc4qOeXbbN76eLViNpAlR
         lGTBVXEBK49yz9irWolKvS6wVzm8nFt1V/H1K5z33Klk0G1Rnen3HII9XOR7n3Nkml
         m5566RRm4Jv5Y10yG/iIQSDMNNNvK1NLxivoW/TD7hcrT/O9XasYOAIoWzD2rwYA1o
         kDf/rx7CgBAXA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id McLHzE25gGeN; Fri, 20 Nov 2020 14:03:00 -0500 (EST)
Received: from [172.16.0.90] (192-222-181-218.qc.cable.ebox.net [192.222.181.218])
        by mail.efficios.com (Postfix) with ESMTPSA id 4E9E32F9D49;
        Fri, 20 Nov 2020 14:03:00 -0500 (EST)
Subject: Re: Duplicate fields in event format of `regcache_sync `
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <53fe53a9-0589-2bc6-1883-6f696fdee9ac@efficios.com>
 <20201120134746.61626e57@gandalf.local.home>
From:   Philippe Duplessis-Guindon <pduplessis@efficios.com>
Message-ID: <76339068-99fe-53f8-c292-8b73900159b5@efficios.com>
Date:   Fri, 20 Nov 2020 14:03:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201120134746.61626e57@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Sorry Steven I forgot to reply all.
This is the original message:
Perfect,

I can prepare a patch, I think this would be a good learning opportunity 
for me.


Thank you,

Philippe

On 2020-11-20 1:47 p.m., Steven Rostedt wrote:
> On Fri, 20 Nov 2020 12:50:33 -0500
> Philippe Duplessis-Guindon <pduplessis@efficios.com> wrote:
> 
>> Hi,
>>
>> I am doing an ftrace plugin for Babeltrace 2 [1], and while I was
>> parsing the event fields I had an error saying that `regcache_sync` has
>> 2 fields named `type`. The problem seems to come from the
>> drivers/base/regmap/trace.h file [2]. This is the patch where this was
>> added: [3]. The `int field` type is not assigned, so I was wondering if
>> it is normal that the field is there.
>>
>> This is the format of this event:
>>
>> $ sudo cat /sys/kernel/debug/tracing/events/regmap/regcache_sync/format
>> name: regcache_sync
>> ID: 1216
>> format:
>>     field:unsigned short common_type;    offset:0;    size:2;    signed:0;
>>     field:unsigned char common_flags;    offset:2;    size:1;    signed:0;
>>     field:unsigned char common_preempt_count; offset:3; size:1;signed:0;
>>     field:int common_pid;    offset:4;    size:4;    signed:1;
>>
>>     field:__data_loc char[] name;    offset:8;    size:4;    signed:1;
>>     field:__data_loc char[] status;    offset:12;    size:4;    signed:1;
>>     field:__data_loc char[] type;    offset:16;    size:4;    signed:1;
>>     field:int type;    offset:20;    size:4;    signed:1;
>>
>>     print fmt: "%s type=%s status=%s", __get_str(name), __get_str(type),
>> __get_str(status)
>>
> 
> It looks like dumb luck that this ever worked. :-/
> 
> The correct fix is to nuke that "int type" field. It's not even assigned.
> 
> Thanks for pointing this out.
> 
> -- Steve
> 
> 
>> Thank you,
>>
>> Philippe
>>
>>
>> [1] https://babeltrace.org/
>>
>> [2]
>> https://github.com/torvalds/linux/blob/master/drivers/base/regmap/trace.h#L129
>>
>> [3]
>> https://github.com/torvalds/linux/commit/593600890110c02eb471cf844649dee213870416
> 
