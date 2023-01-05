Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8332BC3DA7D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 07:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjAEHFg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 02:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjAEHFf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 02:05:35 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A614FD46
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 23:05:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CCE8D6B407;
        Thu,  5 Jan 2023 07:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672902331; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GuwSDtT6s1MF4BabWkhS9CQgxB1l3Sfs4+qFFq8ZstQ=;
        b=Qb2dC8ythNBtQFmRVSJiYk3o3col7eVkPFnRjeFyLGxAonq1u9oTfRyPDtD15w9HjroBgG
        iMP4fNKJkim2+l9zBYxNPBh/mBx7HIvwYwlh3KWv5MqReLfioGggq7Smz44cUOhfTIZDmg
        +qDJzYXsWt8fJcT75TqbQ009h+yiZ8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672902331;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GuwSDtT6s1MF4BabWkhS9CQgxB1l3Sfs4+qFFq8ZstQ=;
        b=HXW7u5z+OMHmGMgPxPad6IaqzOTO180qz466V/s+bT0mlXeMPFZKCVlo6N+x5a+10UiL3w
        PzK1+5NsgGlXuwCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BE5E013273;
        Thu,  5 Jan 2023 07:05:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mGlpLrt2tmM+dgAAMHmgww
        (envelope-from <dwagner@suse.de>); Thu, 05 Jan 2023 07:05:31 +0000
Date:   Thu, 5 Jan 2023 08:05:31 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtraceevent: Add initial support for meson
Message-ID: <20230105070531.p5z6czgflrljrnpq@carbon.lan>
References: <20221228082906.3272-1-dwagner@suse.de>
 <20230104104526.067d42f5@gandalf.local.home>
 <20230104170559.kn2j3abp22l56chq@carbon.lan>
 <20230104123143.405dcc5e@gandalf.local.home>
 <20230104123456.70202ea9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104123456.70202ea9@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 04, 2023 at 12:34:56PM -0500, Steven Rostedt wrote:
> On Wed, 4 Jan 2023 12:31:43 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 4 Jan 2023 18:05:59 +0100
> > Daniel Wagner <dwagner@suse.de> wrote:
> > 
> > > > It's still missing the building of the static library libtraceevent.a.    
> > > 
> > > This is controlled via 'meson setup --default-library {shared, static, both}'.  
> > 
> > Can we make it default to 'both' ?
> 
> Actually, I'm working on adding a Makefile that controls all this. I can
> make that do the "both"

Sure, the defaults are controlled via the project() command:

project(
    'libtraceevent', ['c'],
    meson_version: '>= 0.50.0',
    license: 'LGPL-2.1',
    version: '1.7.0',
    default_options: [
      'c_std=gnu99',
      'buildtype=debug',
      'default_library=both',
      'prefix=/usr/local',
      'warning_level=1',
    ]
)
