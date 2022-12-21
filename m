Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA9FDC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 21 Dec 2022 10:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiLUKwS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 21 Dec 2022 05:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiLUKwR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Dec 2022 05:52:17 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27AF41902F
        for <linux-trace-devel@vger.kernel.org>; Wed, 21 Dec 2022 02:52:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 962CB6B7C7;
        Wed, 21 Dec 2022 10:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671619934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RSEFxPVgXizRRfDvKJiVsoeW7dVah7qEnF4brNMaGN4=;
        b=t2oUv17iEXJYzhd83DioahTBqV0BWuZa7lj0pSCgMIiOqjtt0iQ0GNOoSYV/YmJo88PgiE
        axqpnZ1vxEt+76bBAGVkqqJZAz/r4BlZNSjuBWkCxBj6c1pBd0YLO0p2EHVyoO5rRB7kRh
        rTsXyGU3xmxAz+rbZtE7e4ngsvPGebk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671619934;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RSEFxPVgXizRRfDvKJiVsoeW7dVah7qEnF4brNMaGN4=;
        b=QqGP3ghuJ7tmRpno09uAixM9XkpHq//aJhYx10rr+mZ49QxyyDyOhQoHj+n37NgRtjttcb
        ufQcmugPkUs9OGBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8A74C1390E;
        Wed, 21 Dec 2022 10:52:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ceLEIV7lomPdMQAAMHmgww
        (envelope-from <dwagner@suse.de>); Wed, 21 Dec 2022 10:52:14 +0000
Date:   Wed, 21 Dec 2022 11:52:14 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3] libtracefs: Add initial support for meson
Message-ID: <20221221105112.evdhp3b2zivk2daf@carbon.lan>
References: <20221220180524.29722-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220180524.29722-1-dwagner@suse.de>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Dec 20, 2022 at 07:05:24PM +0100, Daniel Wagner wrote:
> +pkg = import('pkgconfig')
> +pkg.generate(libtracefs,

+    subdirs: 'libtracefs',

Forgot to to add this here. with this in place I was able to build
a mesonized libtracecmd project

> +    filebase: meson.project_name(),
> +    name: meson.project_name(),
> +    version: meson.project_version(),
> +    description: 'Manage trace fs',
> +    url: 'https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/',
> +)
