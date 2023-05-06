Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAC7C77B75
	for <linux-trace-devel@archiver.kernel.org>; Sat,  6 May 2023 22:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjEFWfj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 6 May 2023 18:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEFWfi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 6 May 2023 18:35:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C4815EEA
        for <linux-trace-devel@vger.kernel.org>; Sat,  6 May 2023 15:35:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 138D7226AD;
        Sat,  6 May 2023 22:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683412536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bCwNTLE+nedloPj9AKGfQ1eLAiuP7943cQs31+kpQNU=;
        b=d0nZxXqpwP98svE1OBYyF+GBscn/qXKxDWGRR0DmSebweHmNmNqvR4J60be83PuZZfm0q0
        hd1tMgs4OP51hVE2DeKWY0t7+/UCKTEVPgG596vc0MHOb1xO1hMUSXfgm9DuH7Z6dIbnRr
        cMiLR8bBZMRgkb2RT2U3Ag0a3hgWL9E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683412536;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bCwNTLE+nedloPj9AKGfQ1eLAiuP7943cQs31+kpQNU=;
        b=SE1lLFlxTClO++Ry1/EQOXnCuyasxdN3dg0QGUNtl/TTEOXsf8Yi3ANfOqTyPXSuUyLb3w
        bfjpnoy5xP8rlEBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D1FED1346B;
        Sat,  6 May 2023 22:35:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K/WRLTfWVmS1ZAAAMHmgww
        (envelope-from <krisman@suse.de>); Sat, 06 May 2023 22:35:35 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH trace-cmd v2 0/3] trace-cmd filtering
Organization: SUSE
References: <20230330185211.5604-1-krisman@suse.de>
Date:   Sat, 06 May 2023 18:35:34 -0400
In-Reply-To: <20230330185211.5604-1-krisman@suse.de> (Gabriel Krisman
        Bertazi's message of "Thu, 30 Mar 2023 15:52:08 -0300")
Message-ID: <87ild584w9.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Gabriel Krisman Bertazi <krisman@suse.de> writes:

> Hi Steve,

I wanted to ping you regarding this patchset.  Do you intend to take
this as-is?

Thanks!

>
> This implements my fix to restore single input filtering behavior
> (bz217038) and adds support for global filters, as you requested.
>
> On another topic, a current behavior that seems weird in my opinion is
> that the following negates the second filter as well.
>
>   "trace-cmd -i trace.dat.1 -v -F tp1 -i trace.dat.2 -F tp2"
>
> I'd prefer that -v would apply only to the following -F. It'd allow me
> to do:
>
>   "trace-cmd -v -F 'mm_page_alloc' -i trace.dat.1 -i trace.dat.2 ... \
>              -i trace.dat.10 -F 'mm_page_alloc:order==1'"
>
> It obviously breaks the interface, so I didn't implement it here.  Would
> like to hear your input, though.  We could have a new syntax:
>
>   "trace-cmd ! -F tp1 -F tp2 ! -F tp3"
>
> Thanks,
>
> Gabriel Krisman Bertazi (3):
>   trace-cmd report: Ensure filter is applied to single input file
>   trace-cmd-report: Support global filters
>   documentation: trace-cmd-report: Document filter scope
>
>  .../trace-cmd/trace-cmd-report.1.txt          |  8 +++-
>  tracecmd/trace-read.c                         | 45 ++++++++++++-------
>  2 files changed, 34 insertions(+), 19 deletions(-)

-- 
Gabriel Krisman Bertazi
