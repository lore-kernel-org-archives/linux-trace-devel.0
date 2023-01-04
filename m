Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F2EC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235253AbjADRGI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbjADRGH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:06:07 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6609C382
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:06:01 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1491B400A0;
        Wed,  4 Jan 2023 17:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672851960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sVc1PQTcArL/yd7AHz5+cDQ4E1y71txoE3ajTOeA6ec=;
        b=fnUYqB89OUgtlIQTqdlKB2Sl6lxPX9/+/tPm5SIh75JQadRK6aIxVeE6WSHZTdJv+GUAe/
        zTK6XvMW52A7QvF9JoiqlbafCdfuxlNn/Qb4W/ll4iyzDm3IHDVSmTtPR4rZblLCG5PDH3
        hzGzAWdc/KIp6AREJLKNHR4RSJHDgK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672851960;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sVc1PQTcArL/yd7AHz5+cDQ4E1y71txoE3ajTOeA6ec=;
        b=Oj1ZHAZthxkx/NyxcN894z8c1TCUBqxpa1hHfoSrwtSLyfjPB1cymdFO6VlLOy175gB10V
        zMjxi4B4OrzMfxBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 086DC1342C;
        Wed,  4 Jan 2023 17:06:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sHkFAvixtWNPJAAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 04 Jan 2023 17:06:00 +0000
Date:   Wed, 4 Jan 2023 18:05:59 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtraceevent: Add initial support for meson
Message-ID: <20230104170559.kn2j3abp22l56chq@carbon.lan>
References: <20221228082906.3272-1-dwagner@suse.de>
 <20230104104526.067d42f5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104104526.067d42f5@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 04, 2023 at 10:45:26AM -0500, Steven Rostedt wrote:
> On Wed, 28 Dec 2022 09:29:06 +0100
> Daniel Wagner <dwagner@suse.de> wrote:
> 
> > Introduce Meson as build framework for building libtraceevent. This
> > lives besides the Makefiles until all the expected initial fallouts
> > have been dealed with.
> > 
> > The build steps are:
> > 
> >   # configure using .build as build directory and install destination
> >   # /tmp/test
> >   meson --prefix=/tmp/libtraceevent .build
> > 
> >   # trigger the build
> >   ninja -C .build
> > 
> >   # install the library
> >   ninja -C .build install
> > 
> > In case you want to build/install the documentation the setup is
> > 
> >   meson -Ddocs-build=true .build
> > 
> > Signed-off-by: Daniel Wagner <dwagner@suse.de>
> > ---
> 
> It's still missing the building of the static library libtraceevent.a.

This is controlled via 'meson setup --default-library {shared, static, both}'.
