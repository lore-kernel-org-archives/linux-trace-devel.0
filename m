Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D357EC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Dec 2022 07:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiLWHcr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 02:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiLWHcr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 02:32:47 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A689816488
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Dec 2022 23:32:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 94F414EA84;
        Fri, 23 Dec 2022 07:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671780763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MrOzujZqIM6/APiEoFtpY/Hbc3xZrCBINENoA3OEl48=;
        b=TSPDLoiRK8NQzcCXc/eQ0s1SHuAUChTQ4zZrbRapFNeDp/e9CVHLoDHfnx2Lj1+9i5Wsv5
        wS7UyrS3W9+zCkAM0UP6J7ulSeV4hyBVQb2iihUTyBBTWp1FSM4/KLn3e1LL8Dfg3OCCuq
        wquJgC5aAnvX10Qv6RwIpmIGgwWAgWA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671780763;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MrOzujZqIM6/APiEoFtpY/Hbc3xZrCBINENoA3OEl48=;
        b=teq2ODD0T4n/K26LytJdz/NHJAb/8w1gY4xRrJO7uOG13w7Z1+prnyI3yDqVbFRy1GZevE
        AeErU+m7AX1OBgDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 86CE613913;
        Fri, 23 Dec 2022 07:32:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /InaIJtZpWOqQAAAMHmgww
        (envelope-from <dwagner@suse.de>); Fri, 23 Dec 2022 07:32:43 +0000
Date:   Fri, 23 Dec 2022 08:32:43 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] trace-cmd: Add initial support for meson
Message-ID: <20221223073243.bjjstqyueyseluic@carbon.lan>
References: <20221221170844.10977-1-dwagner@suse.de>
 <20221221170844.10977-3-dwagner@suse.de>
 <20221223000338.19bacc93@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223000338.19bacc93@rorschach.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Dec 23, 2022 at 12:03:38AM -0500, Steven Rostedt wrote:
> On Wed, 21 Dec 2022 18:08:44 +0100
> Daniel Wagner <dwagner@suse.de> wrote:
> 
> > Add support for building the project with meson.
> > 
> > trace-cmd depends on a statically linked libtracecmd
> > (e.g. trace_perf_open, trace_perf_close, trace_perf_init).
> > 
> > That means before kicking off the trace-cmd build a statically build
> > libtracecmd needs to be available:
> > 
> >   cd lib
> >   meson setup --prefix=/tmp/trace-cmd --default-library=static .build
> >   meson compile -C .build
> >   meson install -C .build
> > 
> 
> I get this:
> 
>    Run-time dependency audit found: NO (tried pkgconfig and cmake)
> 
>    meson.build:77:0: ERROR: Dependency "audit" not found, tried pkgconfig and cmake
> 
> audit is an optional dependency. Is there a way to do that? And add
> defines set if it is not?

Yes sure. I've just got it wrong in the meson_option.txt file:

instead

  option('audit', type : 'boolean', value : true,
         description : 'build with audit support')

it should be

  option('audit', type : 'boolean', value : false,
         description : 'build with audit support')

Then this here

  audit_dep = dependency('audit', required: get_option('audit'))

will not fail. Though if the system has audit-devel install it will
still use it (this is a Meson feature).

> What's the reason for the "get_option('audit')"?

Oh, you are right. we could just do

  audit_dep = dependency('audit', required: false)

here.

> Doesn't seem to be working as expected.

There is one thing to keep in mind. If you don't want Meson to use a
dependency 'required: false' will not do the trick. This has been
discussed in github issues in the Meson project many times and the
outcome is that is on purpose. There are workaround for this but I
expect that Meson's developer would tell us it's wrong to workaround :)

> > +libtraceevent_dep = dependency('libtraceevent', version: '>= 1.7.0', required: true)
> > +libtracefs_dep = dependency('libtracefs', version: '>= 1.6.3', required: true)
> > +libtracecmd_dep = dependency('libtracecmd', version: '>= 1.3.0', required: true,
> 
> I'm guessing you just looked at the latest version and added them?

Yes, that's correct.

> Min versions are:
> 
>   libtraceevent is 1.5
>   libtracefs 1.6

Okay, I'll change this accordingly.

> And since this holds libtracecmd, does it really need a dependency?

IIRC, I saw that the CFLAGS from libtraceevent are used for the
trace-cmd, but I might just miss something. If trace-cmd doesn't use
libtraceevent or libtracefs directly than it should be possible to drop
these direct dependencies.

Daniel
