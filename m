Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A093C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhKXWSa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344119AbhKXWSQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:18:16 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16D4F61039;
        Wed, 24 Nov 2021 22:15:05 +0000 (UTC)
Date:   Wed, 24 Nov 2021 17:15:03 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Tao Zhou <tao.zhou@linux.dev>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V7 05/14] rtla/osnoise: Add the hist mode
Message-ID: <20211124171503.584c8dd2@gandalf.local.home>
In-Reply-To: <20211124171212.537b43c3@gandalf.local.home>
References: <cover.1635535309.git.bristot@kernel.org>
        <1d9826696a1e8c3584158c0dd570b8b22db708db.1635535309.git.bristot@kernel.org>
        <20211124171212.537b43c3@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Nov 2021 17:12:12 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > +	/*
> > +	 * Set the size of the bucket.
> > +	 */
> > +	bucket_size = params->output_divisor * params->bucket_size;
> > +	snprintf(buff, sizeof(buff), "duration.buckets=%d", bucket_size);
> > +
> > +	data->trace_hist = tracefs_hist_alloc(tool->trace.tep, "osnoise", "sample_threshold",
> > +			buff, TRACEFS_HIST_KEY_NORMAL);  
> 
> FYI, we changed the API (haven't tagged it yet, so we can do that :-) and
> the above needs to be:
> 
> 	data->trace_hist = tracefs_hist1d_alloc(tool->trace.tep, "osnoise", "sample_threshold",

Or do you think that 1d should be the default, and we have:

	tracefs_hist_alloc()	-- 1d histogram
	tracefs_hist_alloc_2d()	-- 2d histogram
	tracefs_hist_alloc_nd()	-- Nd histogram?

??

We haven't tagged it yet, so we could change it again (and then your code
will work as is).

-- Steve
