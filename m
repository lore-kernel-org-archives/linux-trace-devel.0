Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A3DC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 17:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64B7620842
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 17:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfCERMy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 12:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727739AbfCERMx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 12:12:53 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E08612064A;
        Tue,  5 Mar 2019 17:12:52 +0000 (UTC)
Date:   Tue, 5 Mar 2019 12:12:51 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     Yordan Karadzhov <ykaradzhov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark: Fix a memory leak in the sched_events
 plugin
Message-ID: <20190305121251.1145b84f@gandalf.local.home>
In-Reply-To: <20190305155627.GB19674@box>
References: <20190305143924.11056-1-ykaradzhov@vmware.com>
        <20190305143924.11056-3-ykaradzhov@vmware.com>
        <20190305155627.GB19674@box>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 5 Mar 2019 17:56:28 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> On Tue, Mar 05, 2019 at 04:39:23PM +0200, Yordan Karadzhov wrote:
> > When the sched_events plugin fails to initialize not all the
> > memory allocated for the context of the plugin is freed properly.
> > The problem gets fixed by using the free_context helper function
> > defined in the previous patch.
> > 
> > Fixes: 4f392730e ("kernel-shark-qt: Make Sched event plugin use ...")
> > Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> > ---
> >  kernel-shark/src/plugins/sched_events.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel-shark/src/plugins/sched_events.c b/kernel-shark/src/plugins/sched_events.c
> > index 0d6de2d..fe13e6a 100644
> > --- a/kernel-shark/src/plugins/sched_events.c
> > +++ b/kernel-shark/src/plugins/sched_events.c
> > @@ -74,8 +74,12 @@ static bool plugin_sched_init_context(struct kshark_context *kshark_ctx)
> >  
> >  	event = tep_find_event_by_name(plugin_ctx->pevent,
> >  				       "sched", "sched_switch");
> > -	if (!event)
> > +	if (!event) {
> > +		plugin_free_context(plugin_ctx);
> > +		plugin_sched_context_handler = NULL;
> > +  
> 
> Nit: drop the above empty line?

Yeah, it would be better to do that. But for now, I'll take the patch
anyway. Perhaps clean it up later.

> 
> >  		return false;
> > +	}
> >  
> >  	plugin_ctx->sched_switch_event = event;
> >  	plugin_ctx->sched_switch_next_field =
> > @@ -320,11 +324,8 @@ static int plugin_sched_init(struct kshark_context *kshark_ctx)
> >  {
> >  	struct plugin_sched_context *plugin_ctx;
> >  
> > -	if (!plugin_sched_init_context(kshark_ctx)) {
> > -		free(plugin_sched_context_handler);
> > -		plugin_sched_context_handler = NULL;
> > +	if (!plugin_sched_init_context(kshark_ctx))
> >  		return 0;
> > -	}
> >  
> >  	plugin_ctx = plugin_sched_context_handler;  
> 
> Looks good to me.
> 
> Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Thanks Slavomir!

-- Steve
