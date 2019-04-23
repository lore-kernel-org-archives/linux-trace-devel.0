Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11BBC282DD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B930821773
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfDWNco (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbfDWNco (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:32:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 722CF214AE;
        Tue, 23 Apr 2019 13:32:43 +0000 (UTC)
Date:   Tue, 23 Apr 2019 09:32:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] trace-cmd: Load trace-cmd plugins from build folder,
 if exists
Message-ID: <20190423093241.12235bb8@gandalf.local.home>
In-Reply-To: <f9e75bf11ee9507ebe8b1e3d6c34c4db9322da97.camel@vmware.com>
References: <20190423095658.3907-1-tstoyanov@vmware.com>
        <f9e75bf11ee9507ebe8b1e3d6c34c4db9322da97.camel@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 23 Apr 2019 13:10:35 +0000
Slavomir Kaslev <kaslevs@vmware.com> wrote:

 
> > +static char *trace_util_get_source_plugins_dir(void)
> > +{
> > +	char *plugins = "/plugins";
> > +	char path[PATH_MAX+1];
> > +	int slash = 0;
> > +	int ret;
> > +
> > +	ret = readlink("/proc/self/exe", path, PATH_MAX);
> > +	if (ret > PATH_MAX || ret < 0)
> > +		return NULL;
> > +
> > +	while (ret) {
> > +		if ('/' == path[ret--])
> > +			slash++;
> > +		if (slash == 2) {
> > +			path[ret+1] = 0;
> > +			if (strlen(path) + strlen(plugins) > PATH_MAX)
> > +				break;
> > +			strcat(path, plugins);
> > +			return strdup(path);
> > +		}
> > +	}  
> 
> Looks good. I think that this while() loop can be simplified using the
> standard library to something like:
> 
> 	char resolved[PATH_MAX+1];
> 
> 	dirname(path);
> 	strcat(path, "/../plugins");
> 	if (!realpath(path, resolved))
> 		return NULL;
> 
> The realpath() above is also not strictly necessary.

Or:

	char *p;

	dirname(path);
	p = strrchr(path, '/');
	if (!p)
		return NULL;
	/* It's only in the source if we are in the tracecmd directory */
	if (strcmp(p, "/tracecmd") != 0)
		return NULL;

	strcpy(p, "/plugins");


-- Steve

