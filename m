Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F02EC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20F8420674
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 14:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbfDIOy1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 10:54:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6853 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfDIOy1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 10:54:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 502048B13F;
        Tue,  9 Apr 2019 14:54:27 +0000 (UTC)
Received: from sandy.ghostprotocols.net (ovpn-112-34.phx2.redhat.com [10.3.112.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD4DE19C7F;
        Tue,  9 Apr 2019 14:54:26 +0000 (UTC)
Received: by sandy.ghostprotocols.net (Postfix, from userid 1000)
        id DD6345B81; Tue,  9 Apr 2019 11:54:23 -0300 (BRT)
Date:   Tue, 9 Apr 2019 11:54:23 -0300
From:   Arnaldo Carvalho de Melo <acme@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        linux-kernel@vger.kernel.org, tstoyanov@vmware.com,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tools lib traceevent: Fix missing equality check for
 strcmp
Message-ID: <20190409145423.GD2581@redhat.com>
References: <20190409091529.2686-1-rikard.falkeborn@gmail.com>
 <20190409092122.2e8f62f0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409092122.2e8f62f0@gandalf.local.home>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 09 Apr 2019 14:54:27 +0000 (UTC)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Tue, Apr 09, 2019 at 09:21:22AM -0400, Steven Rostedt escreveu:
> 
> Hi Rikard,
> 
> On Tue,  9 Apr 2019 11:15:29 +0200
> Rikard Falkeborn <rikard.falkeborn@gmail.com> wrote:
> 
> > There was a missing comparison with 0 when checking if type is "s64" or
> > "u64". Therefore, the body of the if-statement was entered if "type" was
> > "u64" or not "s64", which made the first strcmp() redundant since if
> > type is "u64", it's not "s64".
> > 
> > If type is "s64", the body of the if-statement is not entered but since the
> > remainder of the function consists of if-statements which will not be
> > entered if type is "s64", we will just return "val", which is correct,
> > albeit at the cost of a few more calls to strcmp(), i.e., it will behave
> > just as if the if-statement was entered.
> > 
> > If type is neither "s64" or "u64", the body of the if-statement will be
> > entered incorrectly and "val" returned. This means that any type that is
> > checked after "s64" and "u64" is handled the same way as "s64" and
> > "u64", i.e., the limiting of "val" to fit in for example "s8" is never
> > reached.
> > 
> > This was introduced in the kernel tree when the sources were copied from
> > trace-cmd in commit f7d82350e597 ("tools/events: Add files to create
> > libtraceevent.a"), and in the trace-cmd repo in 1cdbae6035cei ("Implement
> > typecasting in parser") when the function was introduced, i.e., it has
> > always behaved the wrong way.
> > 
> > Detected by cppcheck.
> 
> Nice. Thanks for this.
> 
> > 
> > Fixes: f7d82350e597 ("tools/events: Add files to create libtraceevent.a")
> > Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
> 
> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> Arnaldo,
> 
> Care to pull this in?

Sure, thanks.

- Arnaldo
 
> Thanks!
> 
> -- Steve
> 
> > ---
> > I have only compile tested the patch but it should be correct. I don't
> > know if any other problems will surface due to this though.
> > ---
> >  tools/lib/traceevent/event-parse.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> > index 87494c7c619d..981c6ce2da2c 100644
> > --- a/tools/lib/traceevent/event-parse.c
> > +++ b/tools/lib/traceevent/event-parse.c
> > @@ -2233,7 +2233,7 @@ eval_type_str(unsigned long long val, const char *type, int pointer)
> >  		return val & 0xffffffff;
> >  
> >  	if (strcmp(type, "u64") == 0 ||
> > -	    strcmp(type, "s64"))
> > +	    strcmp(type, "s64") == 0)
> >  		return val;
> >  
> >  	if (strcmp(type, "s8") == 0)
