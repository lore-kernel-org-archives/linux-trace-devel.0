Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46259C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 24 Dec 2022 10:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiLXKgy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 24 Dec 2022 05:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiLXKgx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 24 Dec 2022 05:36:53 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6051DEBE
        for <linux-trace-devel@vger.kernel.org>; Sat, 24 Dec 2022 02:36:52 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4AEF026996;
        Sat, 24 Dec 2022 10:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671878211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SKWMCukFiW+QNyVN/gLuEp0As8kG70gVkW1JlllZyZQ=;
        b=XegCDmK6CtfOxrtY49MJrO+y6anPE4IPFTJ04qHHu/63pyi65OdEFrYKcdqg9oauMwWSi6
        AcQyJMPjIElmxXGJWW9StARB5TDlp8lgGdMYh8IsXY4/X/7WEZhUA9XpeDhCNxXv6l2IrU
        +9hMRvzpq4L27nWLYsWvHnuqQjcvg8k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671878211;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SKWMCukFiW+QNyVN/gLuEp0As8kG70gVkW1JlllZyZQ=;
        b=+KKJnv3o5nRyOO+ZnN99GKIqkOT3ZMn6B7/1M27MvoEc9J8+mjaFm5auKc6ByiZ/KieO+k
        aSooyjg6KKW9KlCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3E47713489;
        Sat, 24 Dec 2022 10:36:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iagxD0PWpmNiAgAAMHmgww
        (envelope-from <dwagner@suse.de>); Sat, 24 Dec 2022 10:36:51 +0000
Date:   Sat, 24 Dec 2022 11:36:50 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] trace-cmd: Add initial support for meson
Message-ID: <20221224103650.qpz3hqlkgvkexq6h@carbon.lan>
References: <20221221170844.10977-1-dwagner@suse.de>
 <20221221170844.10977-3-dwagner@suse.de>
 <20221223000338.19bacc93@rorschach.local.home>
 <20221223073243.bjjstqyueyseluic@carbon.lan>
 <20221223120851.5c3ad824@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223120851.5c3ad824@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Dec 23, 2022 at 12:08:51PM -0500, Steven Rostedt wrote:
> On Fri, 23 Dec 2022 08:32:43 +0100
> Daniel Wagner <dwagner@suse.de> wrote:
> 
> > > And since this holds libtracecmd, does it really need a dependency?  
> > 
> > IIRC, I saw that the CFLAGS from libtraceevent are used for the
> > trace-cmd, but I might just miss something. If trace-cmd doesn't use
> > libtraceevent or libtracefs directly than it should be possible to drop
> > these direct dependencies.
> 
> No, I believe that trace-cmd still uses libtracefs and libtraceevent
> directly.

I did try to build without listing the direct dependency, the build
failed because the compiler didn't find the libraries header files. I
think we need to leave them. Though with the current approach to trigger
the static libtraceevent directly from trace-cmd we need it those anyway.
