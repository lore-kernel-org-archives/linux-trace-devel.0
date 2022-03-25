Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CFAC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Mar 2022 20:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiCYUPM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 16:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiCYUPL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 16:15:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E969BB0D;
        Fri, 25 Mar 2022 13:13:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 679A861D27;
        Fri, 25 Mar 2022 20:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3980DC2BBE4;
        Fri, 25 Mar 2022 20:13:35 +0000 (UTC)
Date:   Fri, 25 Mar 2022 16:13:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Keeping <john@metanate.com>
Cc:     linux-trace-devel@vger.kernel.org, williskung@google.com,
        kaleshsingh@google.com, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 09/12] trace-cmd analyze: Add wake up latency timings
Message-ID: <20220325161333.65ffb789@gandalf.local.home>
In-Reply-To: <Yj4ZPMJdz49eQy7I@donbot>
References: <20220324025726.1727204-1-rostedt@goodmis.org>
        <20220324025726.1727204-10-rostedt@goodmis.org>
        <Yj4ZPMJdz49eQy7I@donbot>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 25 Mar 2022 19:34:20 +0000
John Keeping <john@metanate.com> wrote:

> > +static void process_wakeup(struct analysis_data *data,
> > +			   struct tep_handle *tep,
> > +			   struct tep_record *record)
> > +{
> > +	struct cpu_data *cpu_data = &data->cpu_data[record->cpu];
> > +	struct task_cpu_item *cpu_task;
> > +	struct task_item *task;
> > +	unsigned long long val;
> > +	int pid;
> > +
> > +	tep_read_number_field(data->wakeup_pid, record->data, &val);
> > +	pid = val;
> > +	cpu_task = get_cpu_task(cpu_data, pid);  
> 
> Should this use get_task() instead of get_cpu_task()?
> 
> I was trying this out and it provides a great overview of a trace but I
> found it strange that tasks affine to CPU N were also appearing in the
> list for CPU M.

Yes, you are correct, because I noticed the same issue :-D

I'll fix it in v2.

Thanks,

-- Steve

