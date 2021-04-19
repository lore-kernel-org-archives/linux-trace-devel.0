Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121B3C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 12:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE5E2611F0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 12:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237650AbhDSMR3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 08:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239056AbhDSMR1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 08:17:27 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9498461002;
        Mon, 19 Apr 2021 12:16:57 +0000 (UTC)
Date:   Mon, 19 Apr 2021 08:16:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/3] trace-cmd list: Have -o read the options directory
 instead of file
Message-ID: <20210419081655.7a85047e@gandalf.local.home>
In-Reply-To: <CAPpZLN7MJUQS0xbDJSK2F+T6LdsLn3q_f4+jRTgiV+ODa+1uAg@mail.gmail.com>
References: <20210416172331.3870833-1-rostedt@goodmis.org>
        <20210416172331.3870833-2-rostedt@goodmis.org>
        <CAPpZLN7MJUQS0xbDJSK2F+T6LdsLn3q_f4+jRTgiV+ODa+1uAg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 19 Apr 2021 07:50:02 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> The libtracefs options APIs can be used, instead of walking through
> the directory:

No it can't! And this just confirms my fears about using the option mask
and not actually looking at what is on the system. We need a way to see
what's on the system and not just what libtracefs knows about.

> 
> struct tracefs_options_mask *all = tracefs_options_get_supported(NULL);
> struct tracefs_options_mask *enabled = tracefs_options_get_enabled(NULL);
> char *name;
> 
> for (int i = 1; i < TRACEFS_OPTION_MAX; i++) {
>         if (!tracefs_option_mask_is_set(all, i))
>                 continue;
>         name = tracefs_option_name(i);
>         if (!tracefs_option_mask_is_set(enabled, i))
>                 printf("%s\n", name);
>         else
>                 printf("no%s\n", name);
> }

The reason I wrote this was to test the func-no-repeat option that Yordan
wrote, and was sick of going to the /sys/kernel/tracing directory and doing
it by hand.

I want to know what the kernel supports, not what libtracefs supports!

-- Steve
