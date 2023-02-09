Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A42C61DA4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Feb 2023 09:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBIJiI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Feb 2023 04:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBIJiH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Feb 2023 04:38:07 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BE25EF92
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Feb 2023 01:38:07 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E55435C649;
        Thu,  9 Feb 2023 09:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675935485; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hTAOlF/DDS1f0X0ftd9BFnadwYgk7ZLOKmbKHC5Axs4=;
        b=P2KkKc2tGjy3gy0aLgUnEOe/9S8dU8gsnq6CaAepJO+y+58XshoNHrsZfOzfw7DUcJwU0u
        W6/rNrEJnDYxTDZuTldJfGBxomdhS08xJ/zRslyKSHHYvGOBCA9GI+DpyozXYjClbJJrJF
        w4Ksp0KK27yORuN1hpBr9oy8O8tW39I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675935485;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hTAOlF/DDS1f0X0ftd9BFnadwYgk7ZLOKmbKHC5Axs4=;
        b=mdebNf2Nqh4IykA85GnjBa02RebnP6+P07Pg+eer4GXvkDRUeVfs5XQEtepHySW37N+MBj
        /Yht1jHJantjR3AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D64E4138E4;
        Thu,  9 Feb 2023 09:38:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sZJFNP2+5GN2CwAAMHmgww
        (envelope-from <dwagner@suse.de>); Thu, 09 Feb 2023 09:38:05 +0000
Date:   Thu, 9 Feb 2023 10:38:05 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v7 0/2] Add initial support for meson
Message-ID: <20230209093805.rg4sc3652in7smok@carbon.lan>
References: <20230208091204.7443-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208091204.7443-1-dwagner@suse.de>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Feb 08, 2023 at 10:12:02AM +0100, Daniel Wagner wrote:
> The libtracecmd.pc didn't list the subdir 'trace-cmd' which caused
> our kernelshard builds to fail.

FWIW, I've updated the Tumbleweed packages (libtraceevent, libtracefs,
libtracecmd, trace-cmd) to build with Meson and everything looks good now. As
indicated there was only small fallout in our kernelshark build but that is now
fixed with this latest version of these patches here. So all v7 of the patches
are also properly tested in a productive environment.

All these changes don't touch the existing Makefiles, so there is zero chance
that existing build setups break with adding the Meson build files. Obviously,
there will be additional work to keep both builds working, though I don't expect
it should be much after this initial work to get it going.

Steven, any chance you are going to apply them any time soon?
