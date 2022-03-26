Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FDB3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 26 Mar 2022 15:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiCZPSQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 26 Mar 2022 11:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbiCZPSP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 26 Mar 2022 11:18:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ED71ED;
        Sat, 26 Mar 2022 08:16:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D228FB801B9;
        Sat, 26 Mar 2022 15:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0BBC2BBE4;
        Sat, 26 Mar 2022 15:16:35 +0000 (UTC)
Date:   Sat, 26 Mar 2022 11:16:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Keeping <john@metanate.com>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 03/12] trace-cmd analyze: Show how much tasks run on
 each CPU
Message-ID: <20220326111632.09424859@rorschach.local.home>
In-Reply-To: <Yj7z1zaDDlyHdg39@donbot>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
        <20220324025726.1727204-4-rostedt@goodmis.org>
        <Yj4ZuJxzT1oV8zhh@donbot>
        <20220325161819.36de3bce@gandalf.local.home>
        <Yj7z1zaDDlyHdg39@donbot>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 26 Mar 2022 11:07:03 +0000
John Keeping <john@metanate.com> wrote:

> > > > +		print_time(cpu_tasks[i]->runtime, '_');
> > > > +		printf(" (%%%lld)\n", (task->runtime * 100) / total_time);    
> > > 
> > > Is there a reason for using the CPU-specific runtime for the value and
> > > the total runtime for the percentage?
> > > 
> > > I expected the percentage to be the percentage of this CPU's time spend
> > > running the task.  
> > 
> > We modify it so that each CPU has the same run time, unless there's missed
> > events at the start (later patches), and then we change total_time to be
> > the total time of the events on the CPU and not the entire trace.  
> 
> I think we're talking about different things here, I probably wasn't
> entirely clear about this.  It's the numerator of this division that I'm
> concerned about and I wonder if this should be:
> 
> 	(cpu_tasks[i]->runtime * 100) / total_time

Ah, I did misunderstand you. Yes, that's a typo. Thanks for pointing
that out. I'll go fix it.

-- Steve


