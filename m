Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C997C3DA7D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 07:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbjAEHS4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 02:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjAEHSz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 02:18:55 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4315276E
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 23:18:53 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4A667263CA;
        Thu,  5 Jan 2023 07:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672903132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jAHGM8FOTk79wdNuyrvrPiHh+NeE41d9pUkbB1Rdh4s=;
        b=cEEBOaCuatwjiDQHQaQAlXLdfuWRAR2yvxHGh1vT7PfkYL37WovfrZMZMh07BSHU47yB9p
        wAm3XjA5JksGQG1/GC/CPB6fvzahXIRE9dnLu0rQazD0cMG2EQb90hN7ek29inppCDCh1Q
        t7xEusFTB7GmarGhowPYgH4z7qUhxpQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672903132;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jAHGM8FOTk79wdNuyrvrPiHh+NeE41d9pUkbB1Rdh4s=;
        b=22HrVISxSkGYgbuMu8ZetRSj7w+ol2M8Xa493Y+5tdQZgJA5tdrVgHUlvBdkz4WSHMvpwD
        qgt1GuP12j2d9gAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3E6CA13273;
        Thu,  5 Jan 2023 07:18:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5sI0D9x5tmOSewAAMHmgww
        (envelope-from <dwagner@suse.de>); Thu, 05 Jan 2023 07:18:52 +0000
Date:   Thu, 5 Jan 2023 08:18:51 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtracefs: Add initial support for meson
Message-ID: <20230105071851.24okzoqun6ednbmr@carbon.lan>
References: <20221228082927.3499-1-dwagner@suse.de>
 <20230104110916.4f652a96@gandalf.local.home>
 <20230104171939.huntmzkbpy5tvrjg@carbon.lan>
 <20230104124414.727545d4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104124414.727545d4@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 04, 2023 at 12:44:14PM -0500, Steven Rostedt wrote:
> On Wed, 4 Jan 2023 18:19:39 +0100
> Daniel Wagner <dwagner@suse.de> wrote:
 > setup. Basically with
> > 
> > 
> >   'meson setup .build --wrap-mode=forcefallback'
> > 
> > in trace-cmd meson would download, setup and build libtraceevent and libtracefs
> > within the trace-cmd build. This is makes the whole development process
> > between these project way smoother. And if you would configure the build
> > with
> 
> I'm not sure that would make it easier for me. I work on each separately.
> And I don't always want them linked together, but sometimes I do!

Meson doesn't force you here how you prefer you workflow. If you want to
stick with your development steps all should be fine. I just recommend to give
those subproject a try. IMO it makes things simpler, e.g. building all code in
debug mode and being able to single step through is nice. And if you find a bug
or want to change a line in the libraries, just change the line recompile the
main project and that's all. No installing or fiddling with some $PATHs. All works
out of the box.

> To
> control what gets linked to trace-cmd, I use dynamic libraries, and only
> install what I want to use there. That is, they really are three different
> projects! I use libtracefs on several other tools, not just trace-cmd.

Depending on the default settings, the libraries are either dynamically or
statically linked. Meson takes care of all those path issues. For example for
the nmve-cli project I have following linking situation:

$ ldd .build/nvme
        linux-vdso.so.1 (0x00007ffd9975f000)
        libnvme.so.1 => /home/wagi/work/nvme-cli/.build/subprojects/libnvme/src/libnvme.so.1 (0x00007fb934141000)
        libnvme-mi.so.1 => /home/wagi/work/nvme-cli/.build/subprojects/libnvme/src/libnvme-mi.so.1 (0x00007fb934135000)
        libjson-c.so.5 => /lib64/libjson-c.so.5 (0x00007fb9340fe000)
        libz.so.1 => /lib64/libz.so.1 (0x00007fb9340e2000)
        libc.so.6 => /lib64/libc.so.6 (0x00007fb933ee7000)
        libcrypto.so.3 => /lib64/libcrypto.so.3 (0x00007fb933a00000)
        libdbus-1.so.3 => /lib64/libdbus-1.so.3 (0x00007fb933e94000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fb934169000)
        libsystemd.so.0 => /lib64/libsystemd.so.0 (0x00007fb93392e000)
        libcap.so.2 => /lib64/libcap.so.2 (0x00007fb933e88000)
        libgcrypt.so.20 => /lib64/libgcrypt.so.20 (0x00007fb9337e5000)
        liblzma.so.5 => /lib64/liblzma.so.5 (0x00007fb933e54000)
        libzstd.so.1 => /lib64/libzstd.so.1 (0x00007fb933733000)
        liblz4.so.1 => /lib64/liblz4.so.1 (0x00007fb93370f000)
        libgpg-error.so.0 => /lib64/libgpg-error.so.0 (0x00007fb9336e9000)

In this scenario libnvme is linked in as dynamic library.

> >   'meson setup .build --wrap-mode=forcefallback --default-library=static'
> > 
> > would staticly link all subprojects into the trace-cmd binary.
> > 
> > I haven't added this part to the initial mesonizing of the projects. Keep
> > things simple to begin with.
> 
> For the environment that we require a static build, that isn't really
> needed. It would only make the initial setup easier, but that's a one time
> deal. After that, everything is automated.

Before you spend too much time in writing scripts aroudn Meson, you should
really have a look at subproject. You get the dependencies management for little
costs.
