Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545EEC636D4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Feb 2023 16:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjBGQTy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 11:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbjBGQTt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 11:19:49 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB56861B5
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Feb 2023 08:19:48 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 98AE13E952;
        Tue,  7 Feb 2023 16:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675786787; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1tR2j99D2WwqcZbWMVklq6h3kN+9nQqBtBHMyRkm5IM=;
        b=NDvecDzZM0mtJFlfUmxZvfeEarnH0pbZ/DUmmNYETGiMgbITypZ/0Zm0v+XkcUBBIqm+sf
        Cgrcmcb07UF9AEkrhGI7mjv6FCWfNHk4eS/yTQi6ZT0SibUjJh0gf57oCdhgOidE5h4aty
        i+2t/4PhYthXCAURcPF1MrpVpb9pq7w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675786787;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1tR2j99D2WwqcZbWMVklq6h3kN+9nQqBtBHMyRkm5IM=;
        b=fuWHOVjWx52O+4iKa90swd68t2YE4Sp6/bvBUfw6RUAGjYOpdx9fRZKvZjrE0cVSJGeFWN
        BmRSMtUetNj0JBAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8B5B3139ED;
        Tue,  7 Feb 2023 16:19:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UmXaISN64mOwQAAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 07 Feb 2023 16:19:47 +0000
Date:   Tue, 7 Feb 2023 17:19:47 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 0/2] Add initial support for meson
Message-ID: <20230207161947.ju3fl7k7isffqeuo@carbon.lan>
References: <20230207124634.6515-1-dwagner@suse.de>
 <20230207134825.uexdcqlopkuqehuy@carbon.lan>
 <20230207101001.5ef90b44@gandalf.local.home>
 <20230207154546.zqfq27swtc66ar2v@carbon.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207154546.zqfq27swtc66ar2v@carbon.lan>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 07, 2023 at 04:45:47PM +0100, Daniel Wagner wrote:
> On Tue, Feb 07, 2023 at 10:10:01AM -0500, Steven Rostedt wrote:
> > On Tue, 7 Feb 2023 14:48:25 +0100
> > Daniel Wagner <dwagner@suse.de> wrote:
> > 
> > > On Tue, Feb 07, 2023 at 01:46:32PM +0100, Daniel Wagner wrote:
> > > > This version brings a few cleanups on the documentation intallation path
> > > > and pkg-config depenedency updates.
> > > > 
> > > > Changes:
> > > > 
> > > > v6:
> > > >   - lib: isntall trace-cmd.h directly in /usr/include and not subdir
> > > >     trace-cmd. kernelshark builds breaks otherwise  
> > > 
> > > No, this is not the real problem. The Makefile also installs it under
> > > /usr/include/trace-cmd.
> > 
> > But `pkg-config --cflags libtracecmd` should give the right path:
> > 
> >   -I/usr/include/trace-cmd -I/usr/include/tracefs -I/usr/include/traceevent
> > 
> > This is the way it's always been. Why are your kernelshark builds breaking?
> 
> Not sure what's happening. I've build and installed the library with make
> and the kernelshark configuration step still fails. I see the following
> output (make and meson):
> 
> $ cmake -S . -B foo --debug-find
> Running with debug output on for the `find` commands.

There is something wierd going with the libtracecmd build in our build system.
It produces a libtrace-cmd.pc and not a libtracecmd.pc file but this was
with the v2 version of the meson patches. Doesn't happen with libtracecmd v5.

In short, just ignore v6.
