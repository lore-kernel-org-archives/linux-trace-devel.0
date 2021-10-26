Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969F2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 13:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7078260F90
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Oct 2021 13:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhJZNFH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Oct 2021 09:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230324AbhJZNFH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Oct 2021 09:05:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1100860E74;
        Tue, 26 Oct 2021 13:02:41 +0000 (UTC)
Date:   Tue, 26 Oct 2021 09:02:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Ingo Molnar <mingo@redhat.com>, Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 06/20] trace/osnoise: Allow multiple instances of the
 same tracer
Message-ID: <20211026090239.5ca7d350@gandalf.local.home>
In-Reply-To: <f30262dc-f1cf-4945-5a7d-5ecf5a0b5cc2@kernel.org>
References: <cover.1635181938.git.bristot@kernel.org>
        <69cbbd98cce2515c84127c8827d733dc87b04823.1635181938.git.bristot@kernel.org>
        <20211025220856.7fef7581@rorschach.local.home>
        <f30262dc-f1cf-4945-5a7d-5ecf5a0b5cc2@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 26 Oct 2021 10:38:27 +0200
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:


> >>   * osnoise_register_instance - register a new trace instance
> >>   *
> >> @@ -2048,6 +2066,16 @@ static int osnoise_workload_start(void)
> >>  {
> >>  	int retval;
> >>  
> >> +	/*
> >> +	 * Instances need to be registered after calling workload
> >> +	 * start. Hence, if there is already an instance, the
> >> +	 * workload was already registered. Otherwise, this
> >> +	 * code is on the way to register the first instance,
> >> +	 * and the workload will start.
> >> +	 */
> >> +	if (osnoise_has_registered_instances())
> >> +		return 0;  
> > 
> > Looking at how this is checked before being called, it really should
> > return -1, as it is an error if this is called with instances active.  
> 
> Hum.... maybe my explanation is not good enough. It is not a problem if it is
> called with active instances. It would be an error if the same instance was
> already registered at this point, but that was checked before. Here it is
> checking for other instances that should have enabled the workload.
> 
> Does updating the comment with the one below helps?

No need.


> >> @@ -2096,7 +2131,11 @@ static void osnoise_tracer_start(struct trace_array *tr)
> >>  {
> >>  	int retval;
> >>  
> >> -	if (osnoise_has_registered_instances())
> >> +	/*
> >> +	 * If the instance is already registered, there is no need to
> >> +	 * register it again.
> >> +	 */
> >> +	if (osnoise_instance_registered(tr))

My eyes missed that you removed the osnoise_has_registered_instances() for
the osnoise_instance_registered(tr), and thought you were doing the same
test twice.

My mistake. I need to not review patches at the end of the day when I'm
ready to go to sleep.

-- Steve
