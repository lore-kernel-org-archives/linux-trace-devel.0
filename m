Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D0AC7EE2A
	for <linux-trace-devel@archiver.kernel.org>; Sat,  3 Jun 2023 02:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjFCCuS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 22:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjFCCuS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 22:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A261B3
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Jun 2023 19:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8683D6106E
        for <linux-trace-devel@vger.kernel.org>; Sat,  3 Jun 2023 02:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA26C433EF;
        Sat,  3 Jun 2023 02:50:15 +0000 (UTC)
Date:   Fri, 2 Jun 2023 22:50:09 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Check all strdup() return values
Message-ID: <20230602225009.10050479@rorschach.local.home>
In-Reply-To: <6f7e3c23-4e14-ea96-e8c3-d3bc0c192c91@web.de>
References: <20230602014539.013dceb2@rorschach.local.home>
        <6f7e3c23-4e14-ea96-e8c3-d3bc0c192c91@web.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 2 Jun 2023 17:52:27 +0200
Markus Elfring <Markus.Elfring@web.de> wrote:

> …
> > +++ b/lib/trace-cmd/trace-input.c  
> …
> > @@ -5967,9 +5974,15 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
> >  	new_handle->parent = handle;
> >  	new_handle->cpustats = NULL;
> >  	new_handle->hooks = NULL;
> > -	if (handle->uname)
> > +	if (handle->uname) {
> >  		/* Ignore if fails to malloc, no biggy */
> >  		new_handle->uname = strdup(handle->uname);
> > +		if (new_handle->uname == NULL) {
> > +			free(new_handle->trace_clock);
> > +			free(new_handle);
> > +			return NULL;
> > +		}
> > +	}
> >  	tracecmd_ref(handle);
> >
> >  	new_handle->fd = dup(handle->fd);  
> 
> Did the shown comment line become outdated with this change approach?

No, the comment is correct. Thanks for pointing that out. This is what
I get when I use scripts for changes.

> 
> 
> …
> > +++ b/tracecmd/trace-record.c  
> …
> > @@ -371,8 +373,11 @@ struct buffer_instance
> > *allocate_instance(const char *name) instance = calloc(1,
> > sizeof(*instance)); if (!instance)
> >  		return NULL;
> > -	if (name)
> > +	if (name) {
> >  		instance->name = strdup(name);
> > +		if (instance->name == NULL)
> > +			goto error;
> > +	}
> >  	if (tracefs_instance_exists(name)) {
> >  		instance->tracefs = tracefs_instance_create(name);
> >  		if (!instance->tracefs)  
> 
> I hope that more appropriate labels can be applied.
> 
> See also:
> * Improve exception handling in allocate_instance()
>   https://bugzilla.kernel.org/show_bug.cgi?id=217128
> 
> *
> https://wiki.sei.cmu.edu/confluence/display/c/MEM12-C.+Consider+using+a+goto+chain+when+leaving+a+function+on+error+when+using+and+releasing+resources#MEM12C.Considerusingagotochainwhenleavingafunctiononerrorwhenusingandreleasingresources-CompliantSolution%28POSIX,GotoChain%29
> 
> * Completion of error handling
>   https://bugzilla.kernel.org/show_bug.cgi?id=217126

For the application, this is good enough.

-- Steve
