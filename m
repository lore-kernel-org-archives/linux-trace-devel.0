Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20C4C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Feb 2022 02:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiBLC4q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Feb 2022 21:56:46 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiBLC4q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Feb 2022 21:56:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E4F2E09B
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Feb 2022 18:56:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D898FB82E37
        for <linux-trace-devel@vger.kernel.org>; Sat, 12 Feb 2022 02:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49111C340EE;
        Sat, 12 Feb 2022 02:56:41 +0000 (UTC)
Date:   Fri, 11 Feb 2022 21:56:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd reset: Clear all dynamic events
Message-ID: <20220211215639.2bdffbee@rorschach.local.home>
In-Reply-To: <20220114105748.46761-1-tz.stoyanov@gmail.com>
References: <20220114105748.46761-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 14 Jan 2022 12:57:48 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +	/* Clear event probes first, as they may be attached to other dynamic event */
> +	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_EPROBE, true);
> +	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE |
> +				     TRACEFS_DYNEVENT_KRETPROBE |
> +				     TRACEFS_DYNEVENT_UPROBE |
> +				     TRACEFS_DYNEVENT_URETPROBE |
> +				     TRACEFS_DYNEVENT_SYNTH,
> +				     true);
>  }

I accepted this patch, but really, tracefs needs something to define:

	TRACEFS_DYNEVENT_ALL

as callers should not have to call out each type of dynamic event.
Especially when we are about to add new dynamic events, causing this to
break again.

Want to add that?

Thanks Tzvetomir,

-- Steve
