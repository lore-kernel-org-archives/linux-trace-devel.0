Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4895C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Mar 2022 20:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbiCYUT6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiCYUT5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 16:19:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9C05748C;
        Fri, 25 Mar 2022 13:18:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 650DC61D01;
        Fri, 25 Mar 2022 20:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BF8C2BBE4;
        Fri, 25 Mar 2022 20:18:21 +0000 (UTC)
Date:   Fri, 25 Mar 2022 16:18:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Keeping <john@metanate.com>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 03/12] trace-cmd analyze: Show how much tasks run on
 each CPU
Message-ID: <20220325161819.36de3bce@gandalf.local.home>
In-Reply-To: <Yj4ZuJxzT1oV8zhh@donbot>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
        <20220324025726.1727204-4-rostedt@goodmis.org>
        <Yj4ZuJxzT1oV8zhh@donbot>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 25 Mar 2022 19:36:24 +0000
John Keeping <john@metanate.com> wrote:

> On Wed, Mar 23, 2022 at 10:57:17PM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > Display for each CPU that was traced, the amount of time tasks ran on
> > them. Listing the tasks from the longest runner to the least.
> > 
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > ---
> > +	for (i = 0; i < nr_tasks; i++) {
> > +		task = cpu_tasks[i]->task;
> > +
> > +		if (!i) {
> > +			printf("    Task name        PID \t     Run time\n");
> > +			printf("    ---------        --- \t     --------\n");
> > +		}
> > +		printf("%16s %8d\t",
> > +		       tep_data_comm_from_pid(tep, task->pid),
> > +		       task->pid);
> > +		print_time(cpu_tasks[i]->runtime, '_');
> > +		printf(" (%%%lld)\n", (task->runtime * 100) / total_time);  
> 
> Is there a reason for using the CPU-specific runtime for the value and
> the total runtime for the percentage?
> 
> I expected the percentage to be the percentage of this CPU's time spend
> running the task.

We modify it so that each CPU has the same run time, unless there's missed
events at the start (later patches), and then we change total_time to be
the total time of the events on the CPU and not the entire trace.

-- Steve
