Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8210CC4708D
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Jan 2023 17:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbjADRTn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 12:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjADRTn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 12:19:43 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B062DF61
        for <linux-trace-devel@vger.kernel.org>; Wed,  4 Jan 2023 09:19:42 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E1FB23FF6C;
        Wed,  4 Jan 2023 17:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672852779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rm37F8inNP/eh2uod2wnPwVeOwdqGoq4mYFN0xJ3jK4=;
        b=RcxD8jOokn6+b6UGMrtyyLGdDRzHMq7tRCb/L3v+4fBRAs7ctdcpcCpMAKmr6fr7re/Cbn
        uk3HP6SwGeWJs80PnIFf20AXvvM5e1fzE1rAwaCj+hfydC7h/f4HLWq+CFYLManLvULENE
        jqFCQx7nNncBXSlIP0xiut0QIg7wMtg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672852779;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Rm37F8inNP/eh2uod2wnPwVeOwdqGoq4mYFN0xJ3jK4=;
        b=shprsexoNAjJ/ON8DI3Qc2odcvZQiIgCE9pooajorODGOyP2aOR2rR9j+c2LG91OGnHnGZ
        6P9CWZzpPvM0uECQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D43241342C;
        Wed,  4 Jan 2023 17:19:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id V4zAMyu1tWOOKgAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 04 Jan 2023 17:19:39 +0000
Date:   Wed, 4 Jan 2023 18:19:39 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5] libtracefs: Add initial support for meson
Message-ID: <20230104171939.huntmzkbpy5tvrjg@carbon.lan>
References: <20221228082927.3499-1-dwagner@suse.de>
 <20230104110916.4f652a96@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104110916.4f652a96@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jan 04, 2023 at 11:09:16AM -0500, Steven Rostedt wrote:
 This also doesn't build the static library libtracefs.a.
> 
> We have environments that we need to build trace-cmd statically. As
> trace-cmd depends on libtraceevent and libtracefs, that means both need a
> static library as well.

Configure the build with

  'meson setup .build --default-library=both'

Though, we could add libtraceevent and libracefs as subprojects to trace-cmd
which avoids all the hassle to install libtraceevent and libtracefs
independenly from trace-cmd. It also takes care of all the dependency
setup. Basically with


  'meson setup .build --wrap-mode=forcefallback'

in trace-cmd meson would download, setup and build libtraceevent and libtracefs
within the trace-cmd build. This is makes the whole development process
between these project way smoother. And if you would configure the build
with

  'meson setup .build --wrap-mode=forcefallback --default-library=static'

would staticly link all subprojects into the trace-cmd binary.

I haven't added this part to the initial mesonizing of the projects. Keep
things simple to begin with.
