Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B24C4360F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24A9421736
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732463AbfBROiW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:38:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37550 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388328AbfBROhx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:37:53 -0500
Received: by mail-wr1-f67.google.com with SMTP id c8so18620134wrs.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:37:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=s2Pd3G1eXGIDbqNb2VlZOwfLj/Ul0YJIx8z2pdKPyd0=;
        b=MD/975nPAD6GnIsb2j0tt8heTbFwCJzUCccl7HZWGIXLubRYhFGokX5c9TdwvduzB0
         gved+hjO7tTbTsb8oWlbDnp9ZkSyXsEcELNdtg3gAqkrHfQTVIlbXSJuyCCF53Qtsf8r
         xiVdKDXjf3Gi/qZxvlpeucvlUyLeBRwoyli2M+a9SPRih1b7y9Pvif+S3rBHNnq6mZjG
         ONnSMJIDUVLEV6yRYihdvXHyXoqQDJO19OpoOc6s18gjTxxrApb+3MoPmemOALuAzcDi
         ZWYMQTDzHfVmtcAKtGEbWk/XpuAaqGiWtYiuMdLAqcMccZIvG4xJUvLeFpjCjcXIPkew
         ISxA==
X-Gm-Message-State: AHQUAuaXD0KARHswlTXs6Z/rC7iA3SPnZkPtCjs38Ip0EZBv8xlW7CB5
        jt+hMDIA+kRUackrl/3Qnw==
X-Google-Smtp-Source: AHgI3IYW+VSLCmSkCyvQ8oiU7CgEwvuXcrNKv8BFWyq5asDnktrV1xkCxuca7ppKxIBOc80VMstBAg==
X-Received: by 2002:adf:cc83:: with SMTP id p3mr16825228wrj.292.1550500670760;
        Mon, 18 Feb 2019 06:37:50 -0800 (PST)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id y22sm5293249wmj.6.2019.02.18.06.37.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 18 Feb 2019 06:37:50 -0800 (PST)
Date:   Mon, 18 Feb 2019 16:37:47 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 07/11] trace-cmd: Add `trace-cmd setup-guest`
 command
Message-ID: <20190218143746.GD11734@box>
References: <20190214141335.28144-1-kaslevs@vmware.com>
 <20190214141335.28144-8-kaslevs@vmware.com>
 <20190214154132.43082ece@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190214154132.43082ece@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 14, 2019 at 03:41:32PM -0500, Steven Rostedt wrote:
> On Thu, 14 Feb 2019 16:13:31 +0200
> Slavomir Kaslev <kaslevs@vmware.com> wrote:
> 
> > Add `trace-cmd setup-guest` command that creates the necessary FIFOs for tracing
> > a guest over FIFOs instead of vsockets.
> > 
> > Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> > ---
> >  tracecmd/Makefile              |   1 +
> >  tracecmd/include/trace-local.h |   6 ++
> >  tracecmd/trace-cmd.c           |   1 +
> >  tracecmd/trace-setup-guest.c   | 186 +++++++++++++++++++++++++++++++++
> >  tracecmd/trace-usage.c         |   8 ++
> >  5 files changed, 202 insertions(+)
> >  create mode 100644 tracecmd/trace-setup-guest.c
> > 
> > diff --git a/tracecmd/Makefile b/tracecmd/Makefile
> > index 865b1c6..d3e3080 100644
> > --- a/tracecmd/Makefile
> > +++ b/tracecmd/Makefile
> > @@ -35,6 +35,7 @@ TRACE_CMD_OBJS += trace-msg.o
> >  
> >  ifeq ($(VSOCK_DEFINED), 1)
> >  TRACE_CMD_OBJS += trace-agent.o
> > +TRACE_CMD_OBJS += trace-setup-guest.o
> >  endif
> >  
> >  ALL_OBJS := $(TRACE_CMD_OBJS:%.o=$(bdir)/%.o)
> > diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> > index 823d323..b23130e 100644
> > --- a/tracecmd/include/trace-local.h
> > +++ b/tracecmd/include/trace-local.h
> > @@ -14,6 +14,10 @@
> >  
> >  #define TRACE_AGENT_DEFAULT_PORT	823
> >  
> > +#define GUEST_PIPE_NAME		"trace-pipe-cpu"
> > +#define GUEST_DIR_FMT		"/var/lib/trace-cmd/virt/%s"
> > +#define GUEST_FIFO_FMT		GUEST_DIR_FMT "/" GUEST_PIPE_NAME "%d"
> > +
> >  extern int debug;
> >  extern int quiet;
> >  
> > @@ -68,6 +72,8 @@ void trace_listen(int argc, char **argv);
> >  
> >  void trace_agent(int argc, char **argv);
> >  
> > +void trace_setup_guest(int argc, char **argv);
> > +
> >  void trace_restore(int argc, char **argv);
> >  
> >  void trace_clear(int argc, char **argv);
> > diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
> > index 3ae5e2e..4da82b4 100644
> > --- a/tracecmd/trace-cmd.c
> > +++ b/tracecmd/trace-cmd.c
> > @@ -85,6 +85,7 @@ struct command commands[] = {
> >  	{"listen", trace_listen},
> >  #ifdef VSOCK
> >  	{"agent", trace_agent},
> > +	{"setup-guest", trace_setup_guest},
> >  #endif
> >  	{"split", trace_split},
> >  	{"restore", trace_restore},
> > diff --git a/tracecmd/trace-setup-guest.c b/tracecmd/trace-setup-guest.c
> > new file mode 100644
> > index 0000000..875ac0e
> > --- /dev/null
> > +++ b/tracecmd/trace-setup-guest.c
> > @@ -0,0 +1,186 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2019 VMware Inc, Slavomir Kaslev <kaslevs@vmware.com>
> > + *
> > + */
> > +
> > +#include <errno.h>
> > +#include <fcntl.h>
> > +#include <getopt.h>
> > +#include <grp.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <sys/stat.h>
> > +#include <unistd.h>
> > +
> > +#include "trace-local.h"
> > +#include "trace-msg.h"
> > +
> > +static int make_dir(const char *path, mode_t mode)
> > +{
> > +	char *buf, *end, *p;
> > +	int ret = 0;
> > +
> > +	buf = strdup(path);
> > +	end = buf + strlen(buf);
> > +
> > +	for (p = buf; p < end; p++) {
> > +		for (; p < end && *p == '/'; p++);
> > +		for (; p < end && *p != '/'; p++);
> 
> Why not:
> 	for (p = buf; p && *p; p++) {
> 
> 		for (; *p == '/'; p++);
> 		p = index(p, '/');
> 		if (p)
> 			*p = '\0';
> 			
> 
> > +
> > +		*p = '\0';
> > +		ret = mkdir(buf, mode);
> > +		if (ret < 0) {
> > +			if (errno != EEXIST) {
> > +				ret = -errno;
> > +				break;
> > +			}
> > +			ret = 0;
> > +		}
> 
> 		if (p)
> 			*p = '/';
> 
> ?
> 
> No need for "end".
> 
> -- Steve
> 
> > +		*p = '/';
> > +	}
> > +
> > +	free(buf);
> > +	return ret;
> > +}
> > +
> 

This won't work as proposed: `p` will be NULL on the last iteration but will
still get incremented from the outer for-loop and the check (p && *p) won't get
triggered (p == 0x01 in this case).

A fixed version might look like this:

static int make_dir(const char *path, mode_t mode)
{
	char buf[PATH_MAX+1], *p;
	int ret = 0;

	strncpy(buf, path, sizeof(buf));
	for (p = buf; *p; p++) {
		for (; *p == '/'; p++);
		p = strchr(p, '/');

		if (p)
			*p = '\0';
		ret = mkdir(buf, mode);
		if (ret < 0) {
			if (errno != EEXIST) {
				ret = -errno;
				break;
			}
			ret = 0;
		}
		if (!p)
			break;
		*p = '/';
	}

	return ret;
}

OTOH I find the original version much more readable:

static int make_dir(const char *path, mode_t mode)
{
	char buf[PATH_MAX+1], *end, *p;
	int ret = 0;

	end = stpncpy(buf, path, sizeof(buf));
	for (p = buf; p < end; p++) {
		for (; p < end && *p == '/'; p++);
		for (; p < end && *p != '/'; p++);

		*p = '\0';
		ret = mkdir(buf, mode);
		if (ret < 0) {
			if (errno != EEXIST) {
				ret = -errno;
				break;
			}
			ret = 0;
		}
		*p = '/';
	}

	return ret;
}

The intent behind `*p = '\0'; ... *p = '/';` is more clearly expressed in this
version without getting bogged down by strchr() edge case handling.

Since this is not on a performance critical path how about sticking to the more
readable of the two?

-Slavi
