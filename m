Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B020C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 26 Mar 2022 11:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiCZLPt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 26 Mar 2022 07:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbiCZLPq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 26 Mar 2022 07:15:46 -0400
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3830A1D0ED;
        Sat, 26 Mar 2022 04:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=In-Reply-To:Content-Type:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description; bh=9+MKtFBTci6HYjDnJvZMtyJ2h+z5/OZfk+RwU3mLwPc=; b=1nMTO
        TWdqh6uBgCHsmI/4O97ZB4Ok2Y/VfYL9uW1F/3xQ0N2Oc6t7bXmZttS1c97h4rVMKbjZk1YoyOVaU
        8GvmrcvkWyDQClTc07atla3Tcfe31ZRjgZ9P+OLK6DLDJx2ITG2y4WFgNRwkGBBVY0A4Wrmz9Pz5t
        0GImxJ4bjundB0iX6kkgM/ikws/TpbZ7hyaaq0QSDqyEuEA0KB+DkjO9mUczuxOaU3wB1/mhPjGTR
        ygV/GF0Cig3yubwhfH5R5xnLt67WcA2l+1D3bBtk26RYiRUoKVzw8sDSrjlOkhJL+27Z+CjIUNDpt
        0a4EU4zJMgpnEIb5iqoBvHP/grH+g==;
Received: from [81.174.171.191] (helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1nY4My-0006gt-0w; Sat, 26 Mar 2022 11:14:08 +0000
Date:   Sat, 26 Mar 2022 11:14:06 +0000
From:   John Keeping <john@metanate.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 09/12] trace-cmd analyze: Add wake up latency timings
Message-ID: <Yj71frLcA+W9hkMw@donbot>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
 <20220324025726.1727204-10-rostedt@goodmis.org>
 <Yj4ZPMJdz49eQy7I@donbot>
 <20220325161333.65ffb789@gandalf.local.home>
 <20220325163148.0bf4146b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325163148.0bf4146b@gandalf.local.home>
X-Authenticated: YES
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Mar 25, 2022 at 04:31:48PM -0400, Steven Rostedt wrote:
> On Fri, 25 Mar 2022 16:13:33 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > I'll fix it in v2.
> 
> BTW, I plan on rewriting a lot of this to move it into libtracecmd. That
> way other tools can easily extract data from it.
> 
> For example, instead of hard coding "page faults" and "wake ups" I plan on
> adding a way to register events to trigger on. Something like:
> 
>  tracecmd_analyze_register_event_timing(handle, name, start_event,
> 		 start_field, start_record, end_event, end_field,
> 		 end_record);
> 
> Where "start_record" and "end_record" is if the field is a task to record.
> 
> enum {
> 	TRACECMD_ANALYZE_FL_NONE,
> 	TRACECMD_ANALYZE_FL_PID,
> 	TRACECMD_ANALYZE_FL_PID_CPU,
> };
> 
> Thus, we could have:
> 
> 	tracecmd_analyze_register_event_timing(handle,
> 			"Wakeup", sched_waking,
> 			pid_field, TRACECMD_ANALYZE_FL_PID,
> 			sched_switch, next_pid,
> 			TRACECMD_ANALYZE_FL_PID_CPU);
> 
> Or something like the above, that will end up turning into the
> process_wakeup() function (and properly record the waking pid globally).

This sounds really neat.

I started having a look at whether it's possible to add an overview of
interrupts from irq:irq_handler_entry & irq:irq_handler_exit and I guess
that would fit in TRACECMD_ANALYZE_FL_NONE above, but it would be good
to have per-cpu stats for irqs as well so does that mean an additional
record type is needed?
