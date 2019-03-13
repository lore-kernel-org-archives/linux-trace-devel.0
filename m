Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45744C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AD07206DF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfCMP4M (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfCMP4M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:56:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBA75206BA;
        Wed, 13 Mar 2019 15:56:11 +0000 (UTC)
Date:   Wed, 13 Mar 2019 11:56:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 14/15] tools/lib/traceevent: Change description of
 few APIs
Message-ID: <20190313115609.19fbe483@gandalf.local.home>
In-Reply-To: <20181130225832.39b2a90d@vmware.local.home>
References: <20181128090711.17792-1-tstoyanov@vmware.com>
        <20181128090711.17792-15-tstoyanov@vmware.com>
        <20181130224301.1828d3b1@vmware.local.home>
        <20181130225832.39b2a90d@vmware.local.home>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Ping.

-- Steve


On Fri, 30 Nov 2018 22:58:32 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 30 Nov 2018 22:43:01 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> > > index 7b26b9e3a4ba..aed098f29b66 100644
> > > --- a/tools/lib/traceevent/event-parse.c
> > > +++ b/tools/lib/traceevent/event-parse.c
> > > @@ -6441,7 +6441,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct tep_event *event,
> > >   * @record: The record with the field name.
> > >   * @err: print default error if failed.
> > >   *
> > > - * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
> > > + * Returns: 1 on success, -1 field not found, or 0 if buffer is full.    
> > 
> > Actually, it looks like it returns the length written on success.  
> 
> And this actually changed by your update to trace_seq_printf() in patch
> 11.
> 
> Luckily, it appears that the only use cases just check for the -1. :-)
> 
> -- Steve
> 
> >   
> > >   */
> > >  int tep_print_num_field(struct trace_seq *s, const char *fmt,
> > >  			struct tep_event *event, const char *name,
> > > @@ -6473,7 +6473,7 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
> > >   * @record: The record with the field name.
> > >   * @err: print default error if failed.
> > >   *
> > > - * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
> > > + * Returns: 1 on success, -1 field not found, or 0 if buffer is full.    
> > 
> > This too.  

