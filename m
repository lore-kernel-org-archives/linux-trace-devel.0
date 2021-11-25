Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DA3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Nov 2021 14:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351550AbhKYOZd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Nov 2021 09:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355726AbhKYOXd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Nov 2021 09:23:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 884F061130;
        Thu, 25 Nov 2021 14:20:20 +0000 (UTC)
Date:   Thu, 25 Nov 2021 09:20:18 -0500
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
Message-ID: <20211125092018.17e36369@oasis.local.home>
In-Reply-To: <f815794d-bfb6-3e76-3572-3c1cc059c492@kernel.org>
References: <cover.1635535309.git.bristot@kernel.org>
        <1d9826696a1e8c3584158c0dd570b8b22db708db.1635535309.git.bristot@kernel.org>
        <20211124171212.537b43c3@gandalf.local.home>
        <20211124171503.584c8dd2@gandalf.local.home>
        <f815794d-bfb6-3e76-3572-3c1cc059c492@kernel.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 25 Nov 2021 14:45:30 +0100
Daniel Bristot de Oliveira <bristot@kernel.org> wrote:

> > Or do you think that 1d should be the default, and we have:
> > 
> > 	tracefs_hist_alloc()	-- 1d histogram
> > 	tracefs_hist_alloc_2d()	-- 2d histogram
> > 	tracefs_hist_alloc_nd()	-- Nd histogram?
> > 
> > ??  
> 
> IMHO, the function names in your second email sound more intuitive, i.e.,
> tracefs_hist_alloc()/tracefs_hist_alloc_2d()/tracefs_hist_alloc_nd().
> 
> > We haven't tagged it yet, so we could change it again (and then your code
> > will work as is).  
> 
> two birds with a single stone :-)

Just to confirm (confused by "second email" above), you prefer that we
update the API to:

	tracefs_hist_alloc()
	tracefs_hist_alloc_2d()
	tracefs_hist_alloc_nd()

Right?

Thanks,

-- Steve
