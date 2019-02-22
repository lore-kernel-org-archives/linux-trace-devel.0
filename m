Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377DBC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 19:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 012922070B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 19:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfBVTWt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 14:22:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbfBVTWt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 14:22:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C181120700;
        Fri, 22 Feb 2019 19:22:48 +0000 (UTC)
Date:   Fri, 22 Feb 2019 14:22:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] trace-cmd: Implemented new lib API:
 tracecmd_local_events_system()
Message-ID: <20190222142247.12e4b47c@gandalf.local.home>
In-Reply-To: <20190222155100.GA14440@box>
References: <20190222142836.12596-1-tstoyanov@vmware.com>
        <20190222142836.12596-2-tstoyanov@vmware.com>
        <20190222155100.GA14440@box>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 22 Feb 2019 17:51:04 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> > @@ -1189,7 +1161,16 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
> >  		if (strcmp(name, ".") == 0 ||
> >  		    strcmp(name, "..") == 0)
> >  			continue;
> > -
> > +		if (sys_names) {
> > +			i = 0;
> > +			while (sys_names[i]) {
> > +				if (strcmp(name, sys_names[i]) == 0)
> > +					break;
> > +				i++;
> > +			}
> > +			if (sys_names[i] == NULL)
> > +				continue;
> > +		}  
> 
> I think this would be better done in a separate function, say:
> 
> static bool contains(const char *name, const char **names)
> {
> 	while (*names) {
> 		if (strcmp(name, *names++) == 0)
> 			return true;
> 	}
> 	return false;
> }
> 
> and then simply have
> 
> if (sys_names && !contains(name, sys_names))
> 	continue;

Actually, I would argue just to make it a for loop.

	for (i = 0; sys_names[i]; i++) {
		if (strcmp(name, sys_names[i]) == 0)
			goto found;
	}
	continue;
found:

But if you really want the helper function, then have it check
sys_names too.

static bool contains(const char *name, const char * const * names)
{
	if (!names)
		return false;
	for (; *names; names++)
		if (strcmp(name, *names) == 0)
			return true;
	return false;
}

	if (!contains(name, sys_names))

-- Steve

> 
> here.
> 
> >  		sys = append_file(events_dir, name);
> >  		ret = stat(sys, &st);
> >  		if (ret < 0 || !S_ISDIR(st.st_mode)) {
> > @@ -1217,6 +1198,58 @@ int tracecmd_fill_local_events(const char *tracing_dir, struct tep_handle *peven
> >  	return ret;
> >  }
