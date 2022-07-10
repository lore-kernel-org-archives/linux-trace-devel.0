Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E0C8C43334
	for <linux-trace-devel@archiver.kernel.org>; Sun, 10 Jul 2022 15:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiGJPKn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 Jul 2022 11:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJPKm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 Jul 2022 11:10:42 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5BFBC3D;
        Sun, 10 Jul 2022 08:10:40 -0700 (PDT)
Date:   Sun, 10 Jul 2022 23:11:43 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657465838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0UOCOqJq0ioAcZ5Z49JdedUtI2TrrKl6ffe5dJ/eKU0=;
        b=f3Sg3+lNmVYNGh4qBcAkegLpjMfHkxPjWwgJ8gYk+HVK33HzO7TrwHBMouuCTkQ1ahIdkL
        Z9zQyXF/zkK7wIbBppISjObH8xuJ/Jj7boCwWyQbwC38n7puW4pPkqLozvuY3jP9IhnFMc
        fEnXcokjwQtIQenDMAceop9E6vEXdHE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Tao Zhou <tao.zhou@linux.dev>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Gabriele Paoloni <gpaoloni@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org, Tao Zhou <tao.zhou@linux.dev>
Subject: Re: [PATCH V4 01/20] rv: Add Runtime Verification (RV) interface
Message-ID: <YsrsL8zCNcwvdQS8@geo.homenetwork>
References: <cover.1655368610.git.bristot@kernel.org>
 <60548902dbccaa7ba420e40e46835693e27f643f.1655368610.git.bristot@kernel.org>
 <YsXLDvjHqOxYtckg@geo.homenetwork>
 <adbf8277-e680-9357-950d-22cf54b1f6ff@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adbf8277-e680-9357-950d-22cf54b1f6ff@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Jul 08, 2022 at 04:39:47PM +0200,
Daniel Bristot de Oliveira wrote:

> Hey Tao!
> 
> On 7/6/22 19:49, Tao Zhou wrote:
> >> +static void *enabled_monitors_start(struct seq_file *m, loff_t *pos)
> >> +{
> >> +	struct rv_monitor_def *m_def;
> >> +	loff_t l;
> >> +
> >> +	mutex_lock(&rv_interface_lock);
> >> +	m_def = list_entry(&rv_monitors_list, struct rv_monitor_def, list);
> > I realized this m_def is not real but vain. Is it possible the loop is
> > skiped and just return m_def that is not valid.
> 
> that is empty... not a problem.
> 
> I am not seeing (the possible) problem here. Could you simulate/reproduce the problem?

The @*pos of enable_monitors_start() can not be -1 or other negative value.
And I checked that the *pos is 0(right?). That is safe. Sorry for not being
that ture and maybe this is a notice here. Because if it is a negative value,
the returned m_def is a point to a data place 16 bytes before &rv_monitors_list.
That is a not ture rv_monitors_list stucture data. But it is not possiable now.
Maybe "inspired" from your question. Look it more, I image this simulation.
If the monitor(and all is enabled) is more enough to let the *pos to increase
to -1. And the returned m_def is last monitor that returned from enable_monitors_start().
The enable_monitors_next() check from the last monitor and return NULL.
Only show the last monitor. This will not really happen I think.
But I am not focus enough to the seq file code or others now, so this may be
more possible to be not right. Late reply continued from me..

Thanks,
Tao
