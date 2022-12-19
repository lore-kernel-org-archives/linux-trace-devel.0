Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C20C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Dec 2022 13:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbiLSNDn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Dec 2022 08:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbiLSNDm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Dec 2022 08:03:42 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62D01151
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Dec 2022 05:03:40 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4AD47375F9;
        Mon, 19 Dec 2022 13:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671455019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cLYOglSdqf/YnNaQD71U0xS+rewuv7zQO7y/cD15tSM=;
        b=yr3mSCVr6MYft7CB8wPGjRt6iSDRBbOL/dlbVVbGmNmWYtm/y62xOo1tA7RI5LqoT/s25F
        KhlnPuJsXD4d84IF24zBEJ2Zuedl/HMtff2mPvQul8+4uxnghKtp+BvQfVc/51j+uZscLH
        CU6gTgUKqCs12Bvu1SYcW/2+DKtd2jQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671455019;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cLYOglSdqf/YnNaQD71U0xS+rewuv7zQO7y/cD15tSM=;
        b=rMaoDEtMKrjPIIe1ZtMVBUVYQqlTBPsJIM9CRBMqa3CgQrfJ4lNxtTLs55tYRytLBGu17E
        5yxnG7/yFJh2P+Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3C8C213498;
        Mon, 19 Dec 2022 13:03:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4pK/DithoGPiDQAAMHmgww
        (envelope-from <dwagner@suse.de>); Mon, 19 Dec 2022 13:03:39 +0000
Date:   Mon, 19 Dec 2022 14:03:38 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [RFC v2] libtracefs: Add initial support for meson
Message-ID: <20221219130338.baygh3bm34x4t7dg@carbon.lan>
References: <20220707142744.8801-1-dwagner@suse.de>
 <20221125211946.4e066aed@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125211946.4e066aed@rorschach.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Nov 25, 2022 at 09:19:46PM -0500, Steven Rostedt wrote:
> > +libtraceevent_dep = dependency('libtraceevent', required: true)
> 
> Can the dependency also include a version? It will be needed here and
> in trace-cmd.

Sure, that is no problem, e.g.

  libtraceevent_dep = dependency('libtraceevent',
                                 version: '1.3',
                                 required: true)

