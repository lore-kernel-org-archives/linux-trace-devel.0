Return-Path: <SRS0=VTjS=25=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A7EC282DD
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jan 2020 20:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65EB820643
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jan 2020 20:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgAHUWz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 15:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgAHUWy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 15:22:54 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA8D20643;
        Wed,  8 Jan 2020 20:22:54 +0000 (UTC)
Date:   Wed, 8 Jan 2020 15:22:52 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] trace-cmd,kernel-shark: New libtracefs APIs for
 ftrace events and systems
Message-ID: <20200108152252.4dff956b@gandalf.local.home>
In-Reply-To: <20200106154058.60660-5-tz.stoyanov@gmail.com>
References: <20200106154058.60660-1-tz.stoyanov@gmail.com>
        <20200106154058.60660-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon,  6 Jan 2020 17:40:57 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The functionality related to ftrace events and systems
> is moved from trace-cmd application and libtracecmd to libtracefs.
> 
> The following libtracecmd APIs are removed:
>   tracecmd_read_page_record();
>   tracecmd_event_systems();
>   tracecmd_system_events();
>   tracecmd_local_plugins();
>   tracecmd_add_list();
>   tracecmd_free_list();
> 
> The following new library APIs are introduced:
>   tracefs_read_page_record();
>   tracefs_event_systems();
>   tracefs_system_events();
>   tracefs_local_plugins();

Hmm, we need to discuss plugins a bit more. I'm not sure they are
needed for either libtracecmd nor libtracefs. We have plugins for
libtraceevent which is just a better way to present the event, but I'm
imagining that plugins are going to be more specific to trace-cmd
directly. Maybe they can be packaged with libtracecmd, but I'm not
seeing a need for libtracefs.

What do you have in mind?

-- Steve


>   tracefs_iterate_raw_events();
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
> 
