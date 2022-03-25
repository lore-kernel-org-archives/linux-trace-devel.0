Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3217C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Mar 2022 20:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbiCYUVE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbiCYUVE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 16:21:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D159159A49;
        Fri, 25 Mar 2022 13:19:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CC2D61D2A;
        Fri, 25 Mar 2022 20:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D3CC2BBE4;
        Fri, 25 Mar 2022 20:19:27 +0000 (UTC)
Date:   Fri, 25 Mar 2022 16:19:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Keeping <john@metanate.com>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 06/12] trace-cmd analyze: Add tracing of tasks and their
 states
Message-ID: <20220325161925.0b928da4@gandalf.local.home>
In-Reply-To: <Yj4Z39HsErMB73E9@donbot>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
        <20220324025726.1727204-7-rostedt@goodmis.org>
        <Yj4Z39HsErMB73E9@donbot>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 25 Mar 2022 19:37:03 +0000
John Keeping <john@metanate.com> wrote:

> > @@ -288,6 +337,24 @@ static void process_switch(struct analysis_data *data,
> >  		task->start_ts = record->ts;
> >  		cpu_data->current_pid = pid;
> >  
> > +		switch (task->last_state) {
> > +		case -1:
> > +			/* First time seen */
> > +			break;
> > +		case 0:
> > +			update_sched_timings(&task->preempt, record->ts);
> > +			break;
> > +		case 0x1:
> > +			update_sched_timings(&task->sleep, record->ts);
> > +			break;
> > +		case 0x2:
> > +			update_sched_timings(&task->blocked, record->ts);
> > +			break;
> > +		default:
> > +			update_sched_timings(&task->other, record->ts);
> > +		}
> > +		task->last_state = val & 0x1f;  
> 
> val is next_pid here, does last_state even need to be updated for the
> switched-to task?

-ECUTANDPASTE :-p

Thanks,

-- Steve
