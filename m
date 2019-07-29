Return-Path: <SRS0=wfEY=V2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 149D7C7618B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Jul 2019 17:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9A9B206E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 29 Jul 2019 17:01:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbfG2RBM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Jul 2019 13:01:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726190AbfG2RBM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Jul 2019 13:01:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B597206E0;
        Mon, 29 Jul 2019 17:01:11 +0000 (UTC)
Date:   Mon, 29 Jul 2019 13:01:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] trace-cmd: Move plugin options from trace-cmd to
 libtraceevent.
Message-ID: <20190729130109.782ff3a6@gandalf.local.home>
In-Reply-To: <20190726124308.18735-3-tz.stoyanov@gmail.com>
References: <20190726124308.18735-1-tz.stoyanov@gmail.com>
        <20190726124308.18735-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Jul 2019 15:43:07 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -29,18 +29,6 @@
>  int tracecmd_disable_sys_plugins;
>  int tracecmd_disable_plugins;
>  
> -static struct registered_plugin_options {
> -	struct registered_plugin_options	*next;
> -	struct tep_plugin_option			*options;
> -} *registered_options;
> -
> -static struct trace_plugin_options {
> -	struct trace_plugin_options	*next;
> -	char				*plugin;
> -	char				*option;
> -	char				*value;
> -} *trace_plugin_options;

Hmm, so this is identical to what's in lib/traceevent/event-plugin.c.

This doesn't affect this patch (and I may just take this patch as is),
but I'm thinking that we should make the plugins part of the tep
handler. That way, if you have two different tep handlers, each one
will need to register its own set of plugins.

We'll have to look to see if that's possible, because we will need to
do that for the application as a whole. Or perhaps we can add a
"tep_clone_plugin" option that allows a single "plugin" to be
registered to multiple tep handlers.

Again, this is a conversation not to really do with this patch, but
something to think about before releasing the libtraceevent library to
the wild.

-- Steve
