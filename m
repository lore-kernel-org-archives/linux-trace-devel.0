Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA6EC4167B
	for <linux-trace-devel@archiver.kernel.org>; Sat, 24 Dec 2022 10:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiLXKe2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 24 Dec 2022 05:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiLXKe1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 24 Dec 2022 05:34:27 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B64DEB0
        for <linux-trace-devel@vger.kernel.org>; Sat, 24 Dec 2022 02:34:26 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5A79926989;
        Sat, 24 Dec 2022 10:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671878063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C0aNn6Vs8q7gTD82eALMp745No1YA34wNubY/Tyvjz0=;
        b=0T9V7SJk3MkxuczFk+JID88tdt0R1Cn1iI7rKAOH0va+yEO/OkCpmgGYGjIxlT+kvNRs+F
        Tvw34XIeLuWp8LZ8G4UTjarG+Gmg7JmTgjcOLIWRatIecnWM8w7LFJ1ItHM8a9+eBK0SXJ
        qC+bUNg0tRq7x69WSe53E0bAA8T41pU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671878063;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C0aNn6Vs8q7gTD82eALMp745No1YA34wNubY/Tyvjz0=;
        b=0lM41kMidmszQpVR9igsHf72Wt9ODlTNRv29b/PKlnvGL16Fk+PvBR6HAS7qQkXNQOOxVH
        f4TEzCNZcujIkeAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4C01913918;
        Sat, 24 Dec 2022 10:34:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K/N1Eq/VpmO7AQAAMHmgww
        (envelope-from <dwagner@suse.de>); Sat, 24 Dec 2022 10:34:23 +0000
Date:   Sat, 24 Dec 2022 11:34:22 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] trace-cmd: Add initial support for meson
Message-ID: <20221224103422.pqpfhlarvv3fbqu5@carbon.lan>
References: <20221223101502.12269-1-dwagner@suse.de>
 <20221223101502.12269-3-dwagner@suse.de>
 <20221223111820.07213749@gandalf.local.home>
 <20221223112425.55aab646@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223112425.55aab646@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Dec 23, 2022 at 11:24:25AM -0500, Steven Rostedt wrote:
> On Fri, 23 Dec 2022 11:18:20 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > As a work around. But now I get this:
> > 
> > ../tracecmd/trace-profile.c:13:10: fatal error: libaudit.h: No such file or directory
> >    13 | #include <libaudit.h>
> >       |          ^~~~~~~~~~~~
> > 
> > 
> > We're missing the -DNO_AUDIT added when not there, as that file has:
> 
> I guess something like this is needed?

As we write the config.h file and include it via -I<path>/config.h per
command line as it should be enough. I look into it why it doesn't work
here.
