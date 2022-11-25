Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEAAC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Nov 2022 10:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKYKbv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Nov 2022 05:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiKYKbu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Nov 2022 05:31:50 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8D545090
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Nov 2022 02:31:49 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A16B821AAD;
        Fri, 25 Nov 2022 10:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1669372308; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dj5St2Ny7Bvv3KHhPgG2RHPF93P2HcX/mVzN5ygXprU=;
        b=e1g8eYvsg31HVeiDm13yUCU9Rc5N1ZjbY6j+7tgHyLS3HE+6fVxsOd4YSSTdKPqKaYY1U6
        2LVe9Ldj76rzMU/iU62sL2nMuXaSdMMltSFzI+9etI3D/KyiAobct2IyYdimfkXU/d3Yum
        H+1OHYpOOlq7LZr7j1WjjaTVZqzEVbc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1669372308;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dj5St2Ny7Bvv3KHhPgG2RHPF93P2HcX/mVzN5ygXprU=;
        b=MKEV52z7+Ld3Uew7mwgotVmqOP7A3yMABJxPva87rblJEBIRhStUhYi4g1medOjtt4bIuS
        UeUxpstFj1JnbCDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 747BD13A08;
        Fri, 25 Nov 2022 10:31:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id g9/YF5SZgGOlbAAAMHmgww
        (envelope-from <dwagner@suse.de>); Fri, 25 Nov 2022 10:31:48 +0000
Date:   Fri, 25 Nov 2022 11:31:47 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     factory@lists.opensuse.org, linux-trace-devel@vger.kernel.org
Subject: Re: trace-cmd build fails due to due make 'not recursively expanding'
Message-ID: <20221125103147.arrsukzbgiegfux5@carbon>
References: <20221125092058.poa4hzmz4mve7otm@carbon>
 <1o2r1723-o3o5-3p83-8131-896soq68o76@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1o2r1723-o3o5-3p83-8131-896soq68o76@vanv.qr>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Nov 25, 2022 at 11:15:38AM +0100, Jan Engelhardt wrote:
> 
> On Friday 2022-11-25 10:20, Daniel Wagner wrote:
> >
> >trace-cmd stop building and due to make getting stuck in loop
> >and complaining with:
> >
> >  $ make -d
> >  Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
> >
> >I don't really know what's going on. Any ideas?
> 
> https://lists.opensuse.org/archives/list/factory@lists.opensuse.org/thread/FPNDORIL6NDJD3HFQ76LQBIRBCWVG6TV/
> (I already informed Steven last night via email. / Wasn't aware there 
> is a linux-trace-devel@)

Oops, didn't check the factory mailing list first. So there is no easy
workaround.

FWIW, I've got a bunch of initial Meson patches for libtraceevent and
libtracefs. I suppose I should also look at trace-cmd. Steven told me
that he will look at those patches but not before the holiday season.

Daniel
