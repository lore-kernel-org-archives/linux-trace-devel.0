Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71834C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:24:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4712120851
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbfBROYN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:24:13 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42955 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390291AbfBROYL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:24:11 -0500
Received: by mail-wr1-f65.google.com with SMTP id r5so5202635wrg.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:24:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BzQPtrhbDWsBc+cvpFtHSY9uxzqp4tdKEP1QkhNAbWU=;
        b=dClAq+naGP1/IknbWPgpPI5hgjV0bTftJEhg4a/nOMBxCYHSw8jf1cQn9p+/ujAAWL
         xN02cVOv2SGrbRvWQM8OHXwmS1kapamw9QqbNda7gIVBywx28mKP8rdjKIvJFeDqUO5f
         kYnpJCm6Z7j3xnbRgBdRMQbb3E+1csQbqdA2PtssaQ2Nx7jZnyxIStnOtXN65UJ0gQV4
         z78zWICZQZZBQ7cM86Bsp9CalWRim8qJ2W8Keo4GHJF/2YRv3cwXLZiH7CdJ028pT+Xc
         LuvwgMgUW0uUZOAy+VOrehO+tGYYtksDUVR4RAzR5489WLFKuy6av8ZMJPc+3r1AS3Ux
         qrHQ==
X-Gm-Message-State: AHQUAuY/9X7sJL6LZoe5WlXHCrBvaQLaB5pd+ZU6NQo1ZiRyko2Pys7X
        V9Jm5dJB9WG+ccG326FsFbRIwFU=
X-Google-Smtp-Source: AHgI3Ian4eESgp6nxFGHY8+TTnXNWITSp+11eK59oV/DQbKm+52uA3WJc0Oz7INDkl0snXujI5WXJw==
X-Received: by 2002:adf:efca:: with SMTP id i10mr16923439wrp.265.1550499850016;
        Mon, 18 Feb 2019 06:24:10 -0800 (PST)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id t4sm12746809wrb.64.2019.02.18.06.24.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 18 Feb 2019 06:24:09 -0800 (PST)
Date:   Mon, 18 Feb 2019 16:24:02 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 04/11] trace-cmd: Add buffer instance flags for
 tracing in guest and agent context
Message-ID: <20190218142401.GA11734@box>
References: <20190214141335.28144-1-kaslevs@vmware.com>
 <20190214141335.28144-5-kaslevs@vmware.com>
 <20190214150520.3c6bb8ac@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190214150520.3c6bb8ac@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 14, 2019 at 03:05:20PM -0500, Steven Rostedt wrote:
> On Thu, 14 Feb 2019 16:13:28 +0200
> Slavomir Kaslev <kaslevs@vmware.com> wrote:
> 
> > Add BUFFER_FL_GUEST and BUFFER_FL_AGENT flags to differentiate when
> > trace-record.c is being called to trace guest or the VM tracing agent.
> > 
> > Also disable functions talking to the local tracefs when called in recording
> > guest instances context.
> > 
> > Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> > ---
> >  tracecmd/include/trace-local.h |  2 ++
> >  tracecmd/trace-record.c        | 55 ++++++++++++++++++++++++++++++++--
> >  2 files changed, 55 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> > index a1a06e9..f19c8bb 100644
> > --- a/tracecmd/include/trace-local.h
> > +++ b/tracecmd/include/trace-local.h
> > @@ -149,6 +149,8 @@ char *strstrip(char *str);
> >  enum buffer_instance_flags {
> >  	BUFFER_FL_KEEP		= 1 << 0,
> >  	BUFFER_FL_PROFILE	= 1 << 1,
> > +	BUFFER_FL_GUEST		= 1 << 2,
> > +	BUFFER_FL_AGENT		= 1 << 3,
> >  };
> >  
> >  struct func_list {
> > diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> > index 8beefab..107d3d1 100644
> > --- a/tracecmd/trace-record.c
> > +++ b/tracecmd/trace-record.c
> > @@ -781,6 +781,9 @@ static void __clear_trace(struct buffer_instance *instance)
> >  	FILE *fp;
> >  	char *path;
> >  
> > +	if (instance->flags & BUFFER_FL_GUEST)
> > +		return;
> > +
> >  	/* reset the trace */
> >  	path = get_instance_file(instance, "trace");
> >  	fp = fopen(path, "w");
> > @@ -1264,6 +1267,9 @@ set_plugin_instance(struct buffer_instance *instance, const char *name)
> >  	char *path;
> >  	char zero = '0';
> >  
> > +	if (instance->flags & BUFFER_FL_GUEST)
> > +		return;
> > +
> >  	path = get_instance_file(instance, "current_tracer");
> >  	fp = fopen(path, "w");
> >  	if (!fp) {
> > @@ -1360,6 +1366,9 @@ static void disable_func_stack_trace_instance(struct buffer_instance *instance)
> >  	int size;
> >  	int ret;
> >  
> > +	if (instance->flags & BUFFER_FL_GUEST)
> > +		return;
> > +
> >  	path = get_instance_file(instance, "current_tracer");
> >  	ret = stat(path, &st);
> >  	tracecmd_put_tracing_file(path);
> 
> 
> I think we should add a:
> 
> #define is_guest(instance) ((instance)->flags & BUFFER_FL_GUEST)
> 
> Helper macro here, and all these should be turned into:
> 
> 	if (is_guest(instance))
> 		return;
> 
> Less error prone, and looks cleaner.
> 
> We could add a is_agent() too in later patches.

Makes sense. I added both is_agent and is_guest for the next iteration of this
patchset.
