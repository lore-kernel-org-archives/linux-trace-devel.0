Return-Path: <SRS0=vd9q=V3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94228C433FF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 20:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 630C920693
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Jul 2019 20:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfG3UGF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 16:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbfG3UGE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 16:06:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF61C20659;
        Tue, 30 Jul 2019 20:06:03 +0000 (UTC)
Date:   Tue, 30 Jul 2019 16:06:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Changes in few libtraceevent APIs
Message-ID: <20190730160602.15ed9b20@gandalf.local.home>
In-Reply-To: <20190730125028.24789-1-tz.stoyanov@gmail.com>
References: <20190730125028.24789-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 30 Jul 2019 15:50:25 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Before releasing libtraceevent as a standalone library, few
> APIs must be changed:
>  - Event printing interface is redesigned, to be more simple
>    and user friendly. Now the tep_print_event() API can be used 
>    to print various event information. All other event print APIs
>    are removed.
>  - Changed the user's plugin directory to 
>    ~/.local/lib/traceevent/plugins/ to be XDG compliant.

BTW, the other two patches look good. Let's send a v2 of all the
patches with the comments in the first patch addressed.

Thanks Ceco!

-- Steve


> 
> [
>  v2 canges:
>   - the user's plugin directory changed from 
>  ~/.config/traceevent/plugins/ to ~/.local/lib/traceevent/plugins/, 
>  as suggested by Patrick McLean.
> ]
> 
> Tzvetomir Stoyanov (3):
>   tools/lib/traceevent, tools/perf: Changes in tep_print_event_* APIs
>   tools/lib/traceevent: Remove tep_register_trace_clock()
>   tools/lib/traceevent: Change user's plugin directory
> 
>  tools/lib/traceevent/Makefile            |   6 +-
>  tools/lib/traceevent/event-parse-api.c   |  40 ---
>  tools/lib/traceevent/event-parse-local.h |   6 -
>  tools/lib/traceevent/event-parse.c       | 308 +++++++++++++----------
>  tools/lib/traceevent/event-parse.h       |  29 +--
>  tools/lib/traceevent/event-plugin.c      |   2 +-
>  tools/perf/builtin-kmem.c                |   3 +-
>  tools/perf/util/sort.c                   |   3 +-
>  tools/perf/util/trace-event-parse.c      |   2 +-
>  9 files changed, 197 insertions(+), 202 deletions(-)
> 

