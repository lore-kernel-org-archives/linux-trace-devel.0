Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36ABDC43334
	for <linux-trace-devel@archiver.kernel.org>; Sun, 10 Jul 2022 15:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiGJPmv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 10 Jul 2022 11:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGJPmt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 10 Jul 2022 11:42:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C7412A82;
        Sun, 10 Jul 2022 08:42:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66FD1B80AB1;
        Sun, 10 Jul 2022 15:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0595EC3411E;
        Sun, 10 Jul 2022 15:42:43 +0000 (UTC)
Date:   Sun, 10 Jul 2022 11:42:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tao Zhou <tao.zhou@linux.dev>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
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
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH V4 01/20] rv: Add Runtime Verification (RV) interface
Message-ID: <20220710114242.745d65b3@rorschach.local.home>
In-Reply-To: <YsrsL8zCNcwvdQS8@geo.homenetwork>
References: <cover.1655368610.git.bristot@kernel.org>
        <60548902dbccaa7ba420e40e46835693e27f643f.1655368610.git.bristot@kernel.org>
        <YsXLDvjHqOxYtckg@geo.homenetwork>
        <adbf8277-e680-9357-950d-22cf54b1f6ff@kernel.org>
        <YsrsL8zCNcwvdQS8@geo.homenetwork>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 10 Jul 2022 23:11:43 +0800
Tao Zhou <tao.zhou@linux.dev> wrote:

> The @*pos of enable_monitors_start() can not be -1 or other negative value.
> And I checked that the *pos is 0(right?). That is safe. Sorry for not being
> that ture and maybe this is a notice here. Because if it is a negative value,
> the returned m_def is a point to a data place 16 bytes before &rv_monitors_list.
> That is a not ture rv_monitors_list stucture data. But it is not possiable now.
> Maybe "inspired" from your question. Look it more, I image this simulation.
> If the monitor(and all is enabled) is more enough to let the *pos to increase
> to -1. And the returned m_def is last monitor that returned from enable_monitors_start().
> The enable_monitors_next() check from the last monitor and return NULL.
> Only show the last monitor. This will not really happen I think.
> But I am not focus enough to the seq file code or others now, so this may be
> more possible to be not right. Late reply continued from me..


So basically you are saying we should have:

> +static void *enabled_monitors_start(struct seq_file *m, loff_t *pos)
> +{
> +       struct rv_monitor_def *m_def;
> +       loff_t l;
> +
> +       mutex_lock(&rv_interface_lock);

	if (list_empty(&rv_monitors_list->list))
		return NULL;
?

Probably safer to have that.

-- Steve


> +       m_def = list_entry(&rv_monitors_list, struct rv_monitor_def, list);
> +
> +       for (l = 0; l <= *pos; ) {
> +               m_def = enabled_monitors_next(m, m_def, &l);
> +               if (!m_def)
> +                       break;
> +       }
> +
> +       return m_def;
> +}
