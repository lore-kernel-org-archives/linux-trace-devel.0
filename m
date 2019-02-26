Return-Path: <SRS0=LjSD=RB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5860C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 16:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8012421848
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Feb 2019 16:55:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CvT130GL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfBZQzW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 11:55:22 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42184 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbfBZQzV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 11:55:21 -0500
Received: by mail-pl1-f196.google.com with SMTP id v11so1092576plg.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 26 Feb 2019 08:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fQeiu6J69YqJzyIRwfGd8b7/XDf6mrByo/ZW4UlJOJc=;
        b=CvT130GLizj5Kh5o8mUSKUg2BLWKKLFb+q1S6h0zMQqB5eVssMqwXTY7s6j1m8GEas
         EPVbKWku5I6nBbXewZkmVSBc8AxYiwDW6susZn2LEZ9KRXv0V8GYSYkr/DhQJ+eiiAnT
         2yhbvwA+PImz9YVLfdkEmhlcOmBhJ3l/hHazfcusiSELk5IaHavgL5ytUGsZvYfdtoir
         aLxrkZn/pJWxYAt1OqBbV33tYT3o8NuP46l5+fAj5/0NjkXcOnedhhlYegaMgV4rrN8l
         HMznw0fJn/yhGpSC454mOYIHfYBT0kkxWXmKF3GMRyZpRIJvwGnRH01646oyPcuvNf/r
         HSlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fQeiu6J69YqJzyIRwfGd8b7/XDf6mrByo/ZW4UlJOJc=;
        b=grhgXokiD1bdzGwhQsahd6uADnghacTsHftf+rf/HneYp/R/KcG0eLqSkllNeEf3Dt
         rLyPOT6RyONAXUHQ3q+J6yrK+NPjegTDHr0owCMutGOb2vqbAposXdZQS+W2dMyy4vZ7
         HVieWc3+wHKy8DKQ0c3o/+d0XdhgE4jraw3Aq27eRZv8yMMxLafq0TWS8xsiFy/VsBxw
         fPJ3NG+evKgRaBLHSNj+hg1/JU7SkKEN1Eqo8K4EgGmzN+Frbf651wEPkU+EEpS0DFje
         +xbkyz6G+mDmLYU7VfZO463+NPITVIdn+eXnt1aJXCwYw63XCqMS2JN/5TFuwhUi9l6b
         gZcQ==
X-Gm-Message-State: AHQUAub4WMzgBCj14AKDI2E7E6rHz+e4NMQiPDOdw7S77kOGdhV8QLhj
        wGyBrqisbKDGKWer0YAT5Ag=
X-Google-Smtp-Source: AHgI3IbgQoLVRqhFgoTQ4UrDdBjFxZ90uJb2cbpm9wJSK+nHwJfB/Qvc/tsf1ZewdLHqsIEfwvfefg==
X-Received: by 2002:a17:902:7798:: with SMTP id o24mr10860852pll.212.1551200120995;
        Tue, 26 Feb 2019 08:55:20 -0800 (PST)
Received: from [10.1.163.123] ([208.91.3.26])
        by smtp.gmail.com with ESMTPSA id k64sm42529741pfj.69.2019.02.26.08.55.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 08:55:20 -0800 (PST)
Subject: Re: Kernel-shark and sched_switch
To:     Phil Auld <pauld@redhat.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>
References: <20190226143516.GE8239@pauld.bos.csb>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <46038f10-1e77-ac2f-7c32-e96f8fcb28b0@gmail.com>
Date:   Tue, 26 Feb 2019 08:55:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190226143516.GE8239@pauld.bos.csb>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Phil,
Thank you very much for your feedback! It is really valuable for us.

I have one idea what may cause this misbehavior. The sched_events plugin 
deals not only with the sched_switch events but also with the different 
wakeup events and if you don't have any wakeup event enabled when you 
recorded the trace data (no wakeup event in your trace.dat file), the 
plugin will fail to initialize. This is not how it should work and 
fixing this issue is in my to-do list since quite some time.

Would you please try recording the trace data with all sched events 
enabled and then check if plugin does something or not.

Again, thank you very much for your feedback!
cheers,
Yordan


On 26.02.19 г. 6:35 ч., Phil Auld wrote:
> Hi,
> 
> 	I'm using kernel-shark to visualize some scheduler traces. I noticed that the visualization
> does not handle the sched_switch events as well as it might. The switch event is colored with the
> task being switched from, since that's the pid of the event itself.  But this has the effect of leaving
> the wrong colored task "running" in the visualization until the next event by that task.  If that next
> event is a sched_switch again you can have a case where the exact opposite of what happened is being
> visualized in kernel-shark. I could post a screenshot that illustrates this if that helps. Didn't want
> to add a binary attachment to my first post.  It is especially glaring when switching to/from idle.
> 
> I've tried both with and without the sched_events plugin enabled.  There was no difference I could see.
> 
> I'm not the slightest bit familiar with the code here, but I imagine there could be a way to get the pid
> from the next_pid field when the event is SchedEvent::Switch instead of the general PID field.
> 
> 
> If this is not of general interest I'd be happy to make the change only in my tree if anyone has a pointer
> or two on where to start.
> 
> 
> 
> 
> Cheers,
> Phil
> 
> 
