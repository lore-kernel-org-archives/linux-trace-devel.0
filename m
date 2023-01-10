Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360E5C678DA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Jan 2023 14:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbjAJOIp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Jan 2023 09:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238694AbjAJOIT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Jan 2023 09:08:19 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079523F44D;
        Tue, 10 Jan 2023 06:08:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6B29B37475;
        Tue, 10 Jan 2023 14:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673359695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sv/PHQAJi+4R1VBVhi7QSMTp9YQ1AH/mV1OBDhctDnc=;
        b=ltB2z9V5Tq7NOk7QDyvjB26tL1XwS8OKUhR5u1Z38uZrm4J65DBSqOHNkGCD3hMDYoQbhS
        QGGNklV+5dzTx73xllnXjiEVoGIxZ9Vmuhb/REdfqzvKTaGMeCgWnp32htK4kWs0aXNdGb
        WUOQ++s0MpJr0OmfnSEWCD6PYSedeEA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673359695;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sv/PHQAJi+4R1VBVhi7QSMTp9YQ1AH/mV1OBDhctDnc=;
        b=N+n+xbFUYOZgMSvKcNytBAsdggWIF5lN73Mb/SeVEyeVVxJGEPqdwnWB5U9UX5rCqxk2w7
        +AcXnCCKzunLaeBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5DAE11358A;
        Tue, 10 Jan 2023 14:08:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0RjYFk9xvWP6UgAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 10 Jan 2023 14:08:15 +0000
Date:   Tue, 10 Jan 2023 15:08:14 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/rtla: Explicitly list libtraceevent dependency
Message-ID: <20230110140814.2yz4if2e2fasnu7t@carbon.lan>
References: <20230110131805.16242-1-dwagner@suse.de>
 <42d1e999-79a6-94dc-cc88-77520ddce068@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42d1e999-79a6-94dc-cc88-77520ddce068@kernel.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jan 10, 2023 at 02:55:03PM +0100, Daniel Bristot de Oliveira wrote:
> On 1/10/23 14:18, Daniel Wagner wrote:
> > The current libtracefs.pkg file lists the dependency on
> > libtraceevent ("pkg-config --libs libtracefs" -> "-ltracefs
> > -ltraceevent").
> > 
> > Dan Nicholson's Guide to pkg-config[1] stats that "Libs: The link
> > flags specific to this package and any required libraries that don't
> > support pkg-config". Thus the current libtracefs.pkg is not correct.
> > 
> > rtla is depending on libtraceevent but it doesn't express this in
> > 'pkg-config' part to retrieve the correct build flags.
> > 
> > In order to be able to update the "Libs:" section in the libtracefs
> > project we need to list the dependency explicitly to avoid future linker
> > failures.
> 
> I am ok with it. Steve?

FWIW, this is change is also backwards compatible, meaning if you have system
which has a libtracefs.pkg installed which lists libtraceevent in its Libs:
section the 'pkg-config --libs libtracefs libtraceevent' command will return the
identically string which is '-ltracefs -ltraceevent'.
