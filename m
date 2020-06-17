Return-Path: <SRS0=X5V/=76=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21A2C433DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jun 2020 15:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7B7A2088E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jun 2020 15:57:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IVCVjIgE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgFQP5S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jun 2020 11:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQP5S (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jun 2020 11:57:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B682C06174E;
        Wed, 17 Jun 2020 08:57:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d128so2563977wmc.1;
        Wed, 17 Jun 2020 08:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DPYEaqvboOq3vVXpr0SVzkHdJeFjNIYuoipT0CUi7IQ=;
        b=IVCVjIgEN2rICb/1zX0GWflranzjc2mfan24VIDBAwz74IhPICS0RvzKm463Y/2qTZ
         b1xVAk40/eA8WJLHe98UDP7GsoSLLq6t39pHrBFq7n/2RhoJAJkPXdmyLQBcinIvl3gj
         dJE2ODMID+PY76b84VydfQGSeJM64btlqEFbYlRh6AcbbmFVsugQxhOkz4aRMJ+fK/e5
         Ho1VpkVkkmEB94S0SVfc9G2A80/wsn1xz+aUHp9Zz5H+AX8/c4Xwkspfuin5cgweBUvk
         qz0f8XKDjb0naggYYZ1/r14YHsTKOq9VICuvO6Y8f1TXxMgX5L63SYag1DsJuuKLolYq
         m/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DPYEaqvboOq3vVXpr0SVzkHdJeFjNIYuoipT0CUi7IQ=;
        b=JNqefWQmXrhkFGQukNK0SgZ37OFF1Ws8VR9HEiWN+35956xU0zhTxFhFmhn3CsMqSO
         qHMln6+IKxY7fBvyiNaHO3SYCKdjI4IW8IS8q0EQ/I/zinHqt4jhqdbJp3OFSA/lRMNo
         WGBnqOPrNE7R+oe6g/k0+0MwuQ0KwmX5mIuwnp8D/axaXenXHGw9pKiau8i0z0j+t4Pw
         8AUokpDMEp7pZmecAHQ/l/rN1NUpLdItgJFGYFQCQ+yqbX+I+Q+f+rczCw9IPcz62cJ7
         6qGr4BJwAzPHTh80c7w/ahlsyAejujM4MEAkc2N6ngzpwT4zulClQb1wGtigljBrKMKd
         nx/Q==
X-Gm-Message-State: AOAM532CkN7mVivq+bpKkghASUmWfa25i7Ent6mDBuk3W2WpkOSuvIra
        OwhL55VDaQV6ROb3tRxhCw8=
X-Google-Smtp-Source: ABdhPJxCEvdhf7ds2vPANkipXPKUG+mX0ad3r+U6XPKvaBT6olfs/Fw5mUgRtq29XvP02EJ+l5zPxA==
X-Received: by 2002:a7b:cb56:: with SMTP id v22mr9474364wmj.180.1592409435377;
        Wed, 17 Jun 2020 08:57:15 -0700 (PDT)
Received: from ?IPv6:2003:d7:b711:be00:e0b4:8ebe:881b:bf72? (p200300d7b711be00e0b48ebe881bbf72.dip0.t-ipconnect.de. [2003:d7:b711:be00:e0b4:8ebe:881b:bf72])
        by smtp.gmail.com with ESMTPSA id f11sm63081wrj.2.2020.06.17.08.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 08:57:14 -0700 (PDT)
Subject: Re: [PATCH] tracing/boottime: Fix kprobe multiple events
To:     Steven Rostedt <rostedt@goodmis.org>,
        Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
Cc:     linux-kernel@vger.kernel.org, mingo@redhat.com,
        linux-trace-devel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Masami Hiramatsu <mhiramat@kernel.org>
References: <20200617140817.17161-1-sascha.ortmann@stud.uni-hannover.de>
 <20200617110521.7ed41fdd@oasis.local.home>
 <20200617110617.2a06c143@oasis.local.home>
From:   Maximilian Werner <maximilian.werner96@gmail.com>
Message-ID: <3e6495df-065f-34c5-8e21-65764c79d6ca@gmail.com>
Date:   Wed, 17 Jun 2020 17:57:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200617110617.2a06c143@oasis.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We are a group of students from Leibniz University Hannover and
this patch is part of a project of ours. That's why both of us
signed this off.

Should we have added Masami to Cc? He didn't appear in the
get_maintainer script.

-- Maximilian & Sascha

On 17.06.20 17:06, Steven Rostedt wrote:
> On Wed, 17 Jun 2020 11:05:21 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> On Wed, 17 Jun 2020 16:08:17 +0200
>> Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de> wrote:
>>
>>> Fix boottime kprobe events to add multiple events even if one fails
>>> and report probe generation failures.
>>>
>>> As an example, when we try to set multiprobe kprobe events in
>>> bootconfig like this:
>>>
>>> ftrace.event.kprobes.vfsevents {
>>> 	probes = "vfs_read $arg1 $arg2,,
>>>                   !error! not reported;?", // leads to error
>>> 		 "vfs_write $arg1 $arg2"
>>> }
>>>
>>> this will not work like expected. After commit
>>> da0f1f4167e3af69e1d8b32d6d65195ddd2bfb64 ("tracing/boottime:
>>> Fix kprobe event API usage"), the function
>>> trace_boot_add_kprobe_event will not produce any error message,
>>> aborting the function and stopping subsequent probes from getting
>>> installed when adding a probe fails at kprobe_event_gen_cmd_start.
>>> Furthermore, probes continue when kprobe_event_gen_cmd_end fails
>>> (and kprobe_event_gen_cmd_start did not fail). In this case the
>>> function even returns successfully when the last call to
>>> kprobe_event_gen_cmd_end is successful.
>>>
>>> The behaviour of reporting and aborting after failures is not
>>> consistent.
>>>
>>> The function trace_boot_add_kprobe_event now continues even when
>>> one of the multiple events fails. Each failure is now reported
>>> individually. Since the function can only return one result to the
>>> caller, the function returns now the last failure (or none, if
>>> nothing fails).
>>>
>>> Cc: linux-kernel@i4.cs.fau.de
>>> Signed-off-by: Maximilian Werner <maximilian.werner96@gmail.com>
>>> Signed-off-by: Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
>>
>> Why the double signed off by?
>>
>> Masami, I'm fine with this, but needs your review.
> 
> [ It appears that Masami wasn't in the Cc ]
> 
> 
>>
>> -- Steve
>>
>>> ---
>>>   kernel/trace/trace_boot.c | 16 +++++++++++-----
>>>   1 file changed, 11 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
>>> index 9de29bb45a27..dbb50184e060 100644
>>> --- a/kernel/trace/trace_boot.c
>>> +++ b/kernel/trace/trace_boot.c
>>> @@ -95,18 +95,24 @@ trace_boot_add_kprobe_event(struct xbc_node *node, const char *event)
>>>   	struct xbc_node *anode;
>>>   	char buf[MAX_BUF_LEN];
>>>   	const char *val;
>>> +	int error = 0;
>>>   	int ret = 0;
>>>   
>>>   	xbc_node_for_each_array_value(node, "probes", anode, val) {
>>>   		kprobe_event_cmd_init(&cmd, buf, MAX_BUF_LEN);
>>>   
>>> -		ret = kprobe_event_gen_cmd_start(&cmd, event, val);
>>> -		if (ret)
>>> -			break;
>>> +		error = kprobe_event_gen_cmd_start(&cmd, event, val);
>>> +		if (error) {
>>> +			pr_err("Failed to generate probe: %s\n", buf);
>>> +			ret = error;
>>> +			continue;
>>> +		}
>>>   
>>> -		ret = kprobe_event_gen_cmd_end(&cmd);
>>> -		if (ret)
>>> +		error = kprobe_event_gen_cmd_end(&cmd);
>>> +		if (error) {
>>>   			pr_err("Failed to add probe: %s\n", buf);
>>> +			ret = error;
>>> +		}
>>>   	}
>>>   
>>>   	return ret;
>>
> 
