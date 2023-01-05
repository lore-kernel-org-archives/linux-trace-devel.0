Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45852C3DA7A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 14:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjAEOla (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 09:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjAEOl3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 09:41:29 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695C5E61
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 06:41:26 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 61BB224423;
        Thu,  5 Jan 2023 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672929683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=arU2IB6DqWXrcbHdJ5wGvgOLrlzMcadcOizW2VMtu8M=;
        b=N21xZ0amvTuJA5sSUF3BXhTRO/D84xlNt6fe5TmM8u39L4fM6YG5gHlKmm8TbO1UUKcIt4
        MD24wzqWoKmv2CEsDpAZWaEpdR8j2Hm2PiXmtRn4CR/r5ZeQ05Ven2yQGT24RU2GaaETY9
        NnVv8dCheTO9DnDVkl4+WNmv42kB3uw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672929683;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=arU2IB6DqWXrcbHdJ5wGvgOLrlzMcadcOizW2VMtu8M=;
        b=0cI2Y/254KOvU6zRPw6NaI7H68o48Kn2LjjC7HutX4W6ZqxNRUhfUPx3Yw/d1LuWPITefD
        RHVuVUCYOujxebDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 55678138DF;
        Thu,  5 Jan 2023 14:41:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id N1LMFJPhtmNhEwAAMHmgww
        (envelope-from <dwagner@suse.de>); Thu, 05 Jan 2023 14:41:23 +0000
Date:   Thu, 5 Jan 2023 15:41:22 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtracefs: Add initial support for meson
Message-ID: <20230105144122.gus5jxbqcbyfaq3x@carbon.lan>
References: <20221228082927.3499-1-dwagner@suse.de>
 <20230104110916.4f652a96@gandalf.local.home>
 <20230104171939.huntmzkbpy5tvrjg@carbon.lan>
 <20230104124414.727545d4@gandalf.local.home>
 <20230105071851.24okzoqun6ednbmr@carbon.lan>
 <20230105085102.0a9c464b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105085102.0a9c464b@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

> > Meson doesn't force you here how you prefer you workflow. If you want to
> > stick with your development steps all should be fine. I just recommend to give
> > those subproject a try. IMO it makes things simpler, e.g. building all code in
> > debug mode and being able to single step through is nice. And if you find a bug
> > or want to change a line in the libraries, just change the line recompile the
> > main project and that's all. No installing or fiddling with some $PATHs. All works
> > out of the box.
> 
> I get that now with my current setup. I only install with debug options,
> and use gdb in emacs. It walks through the library code, and will go into
> different paths automatically. I only need to install the code I change
> (sure, I need to go into that path to do so). But as I've been using
> libtracefs and libtraceevent for other tooling, I really don't want it part
> of the trace-cmd repo, or in the build path.

Right, in this case I should avoid breaking your working setup :) Anyway, let's
get first the initial setup working before doing fancy stuff.

> > > For the environment that we require a static build, that isn't really
> > > needed. It would only make the initial setup easier, but that's a one time
> > > deal. After that, everything is automated.  
> > 
> > Before you spend too much time in writing scripts aroudn Meson, you should
> > really have a look at subproject. You get the dependencies management for little
> > costs.
> 
> The above mentioned static environment build is done via portage.

I've build the openSUSE packages using with Meson (just exchanged the build
instruction) and the tools didn't complain. So I think most of the problems
should be resolved. But experience tells me, there is always one bug more.

Daniel
