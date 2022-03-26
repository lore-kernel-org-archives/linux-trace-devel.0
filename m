Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 062FBC433FE
	for <linux-trace-devel@archiver.kernel.org>; Sat, 26 Mar 2022 11:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiCZLIs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 26 Mar 2022 07:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbiCZLIq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 26 Mar 2022 07:08:46 -0400
Received: from metanate.com (unknown [IPv6:2001:8b0:1628:5005::111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FFC25E33E;
        Sat, 26 Mar 2022 04:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=metanate.com; s=stronger; h=In-Reply-To:Content-Type:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description; bh=i0g1TxuA47APANXBd0Ol7ZElqB1oZ1dp5JFxJAp42Pw=; b=S0uEk
        zCL+YTrXlNtTGKSlIrvS7Mbyw1akQT2+1e7djWRmTG6vOuXfGj8Owl3sj1//x4RRr+H5R8BXoZWcL
        rkeYdrfFZG4bacvnorWK/za4GzJY4Fp1wX5KCIrop+TRn1Gl9+iJ0l8CZc8nDjoVjV8EjiFDk/4nw
        E4TJplDk+aTg/2fvht3OOtlDWc9f245Uokst8swBkGetyah668zsqepkquaOtZCncfR0qGAuG1OJx
        sia6ONN/Y4p9gQTLxcWVze2UYyIcxz8FHelKSWoqwmPuGFl2KsHxbYGFKXP6wG4VrW5nYRIFjpva1
        ZKxurUcqMlfN8YcspccOzcagzAbVQ==;
Received: from [81.174.171.191] (helo=donbot)
        by email.metanate.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <john@metanate.com>)
        id 1nY4G8-0006Zj-Qq; Sat, 26 Mar 2022 11:07:04 +0000
Date:   Sat, 26 Mar 2022 11:07:03 +0000
From:   John Keeping <john@metanate.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 03/12] trace-cmd analyze: Show how much tasks run on each
 CPU
Message-ID: <Yj7z1zaDDlyHdg39@donbot>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
 <20220324025726.1727204-4-rostedt@goodmis.org>
 <Yj4ZuJxzT1oV8zhh@donbot>
 <20220325161819.36de3bce@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325161819.36de3bce@gandalf.local.home>
X-Authenticated: YES
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Mar 25, 2022 at 04:18:19PM -0400, Steven Rostedt wrote:
> On Fri, 25 Mar 2022 19:36:24 +0000
> John Keeping <john@metanate.com> wrote:
> 
> > On Wed, Mar 23, 2022 at 10:57:17PM -0400, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > > 
> > > Display for each CPU that was traced, the amount of time tasks ran on
> > > them. Listing the tasks from the longest runner to the least.
> > > 
> > > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > > ---
> > > +	for (i = 0; i < nr_tasks; i++) {
> > > +		task = cpu_tasks[i]->task;
> > > +
> > > +		if (!i) {
> > > +			printf("    Task name        PID \t     Run time\n");
> > > +			printf("    ---------        --- \t     --------\n");
> > > +		}
> > > +		printf("%16s %8d\t",
> > > +		       tep_data_comm_from_pid(tep, task->pid),
> > > +		       task->pid);
> > > +		print_time(cpu_tasks[i]->runtime, '_');
> > > +		printf(" (%%%lld)\n", (task->runtime * 100) / total_time);  
> > 
> > Is there a reason for using the CPU-specific runtime for the value and
> > the total runtime for the percentage?
> > 
> > I expected the percentage to be the percentage of this CPU's time spend
> > running the task.
> 
> We modify it so that each CPU has the same run time, unless there's missed
> events at the start (later patches), and then we change total_time to be
> the total time of the events on the CPU and not the entire trace.

I think we're talking about different things here, I probably wasn't
entirely clear about this.  It's the numerator of this division that I'm
concerned about and I wonder if this should be:

	(cpu_tasks[i]->runtime * 100) / total_time

If total_time is 10 seconds and there's a task A which runs on CPU0 for
2 seconds and CPU1 for 1 second then I expect to see:

	CPU 0
	A	2.000  (20%)

	CPU 1
	A	1.000  (10%)

But at the moment both of those lines will give 30% (although the actual
run times are correct).
