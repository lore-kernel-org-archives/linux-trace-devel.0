Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AD2C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 24 Dec 2022 10:32:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiLXKc4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 24 Dec 2022 05:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiLXKcz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 24 Dec 2022 05:32:55 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F7DDE87
        for <linux-trace-devel@vger.kernel.org>; Sat, 24 Dec 2022 02:32:55 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E045033D5F;
        Sat, 24 Dec 2022 10:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671877972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9mX0OjGWEl3UdNLOzx2JC0lh/+dcQbagjg2tnqAueFA=;
        b=ktIKIGMITYdF2tYix7qusqRcmUKGL9qi9zCjBTnBqhRFzEx4AKi/TH/TdCNTwLDmpcK/0i
        /ZpHxB2213DwOCbxxeHkiglxJTm0rVMjFYli5sE8WP+6oCTcPyk9KEiUSPr/fT1y1Hv6Fy
        3TsaDQtOYrpvAyQ51knV438udBfBDng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671877972;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9mX0OjGWEl3UdNLOzx2JC0lh/+dcQbagjg2tnqAueFA=;
        b=MwmfemizSyIa4ZgXgQKSgALnh5kjU3Kk43gtej0Hb4NP+390h5UX+LY7+gmBFstWXfDFPF
        18fbSnHGBuUKrLCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D3D8113918;
        Sat, 24 Dec 2022 10:32:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QBqrM1TVpmNHAQAAMHmgww
        (envelope-from <dwagner@suse.de>); Sat, 24 Dec 2022 10:32:52 +0000
Date:   Sat, 24 Dec 2022 11:32:52 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] libtracecmd: Add initial support for meson
Message-ID: <20221224103252.zwrnfq65dcuigoek@carbon.lan>
References: <20221223101502.12269-1-dwagner@suse.de>
 <20221223101502.12269-2-dwagner@suse.de>
 <20221223142543.3c5029a3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221223142543.3c5029a3@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Dec 23, 2022 at 02:25:43PM -0500, Steven Rostedt wrote:
> On Fri, 23 Dec 2022 11:15:01 +0100
> Daniel Wagner <dwagner@suse.de> wrote:
> 
> > +++ b/lib/meson.build
> > @@ -0,0 +1,109 @@
> > +# SPDX-License-Identifier: LGPL-2.1
> > +#
> > +# Copyright (c) 2022 Daniel Wagner, SUSE LLC
> > +
> > +project(
> > +    'libtrace-cmd', ['c'],
> > +    meson_version: '>= 0.50.0',
> > +    license: 'GPL-2.0',
> > +    version: '1.3.0',
> > +    default_options: [
> > +      'c_std=gnu99',
> > +      'buildtype=release',
> 
> The default buildtype should be debug. If someone downloads the source,
> they are probably going to debug it. I found this annoying when I went to
> use gdb, and there were no symbols present.

Makes sense. I'll update it accordingly.
