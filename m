Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23EDC636CD
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Feb 2023 13:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjBGNs3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Feb 2023 08:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjBGNs2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Feb 2023 08:48:28 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEB06193
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Feb 2023 05:48:27 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 429E93F337;
        Tue,  7 Feb 2023 13:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675777706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KYebRqSkqqLvamRJT2XNF+RJJal6czYFS1uXT69ligg=;
        b=RGpFgUMrU2SxqLStR/YqEQqWDbb1BWTPYPKpK9+mkxUsZOQ/DgNxe2bvWuBxRCKpYLuFaf
        iRas9pBNGncLywVEh1UXiPDxVDgT8ClmMX6Ly63eMim0MGyvxMEjQibZNBu0O/bI5wFU0Z
        HQIrxpV+U/GLousrS8SnCl8ZcisavJc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675777706;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KYebRqSkqqLvamRJT2XNF+RJJal6czYFS1uXT69ligg=;
        b=3uaBD8P/5Bfh/rROFYfQC+IJGcy2/Zf+KtloXhJ4dFnN/KhS9kiB55M2DRn+60Tj479YTv
        0sUVTqT3Hd2WNyDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 34241139ED;
        Tue,  7 Feb 2023 13:48:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YPChDKpW4mMTewAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 07 Feb 2023 13:48:26 +0000
Date:   Tue, 7 Feb 2023 14:48:25 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v6 0/2] Add initial support for meson
Message-ID: <20230207134825.uexdcqlopkuqehuy@carbon.lan>
References: <20230207124634.6515-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207124634.6515-1-dwagner@suse.de>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Feb 07, 2023 at 01:46:32PM +0100, Daniel Wagner wrote:
> This version brings a few cleanups on the documentation intallation path
> and pkg-config depenedency updates.
> 
> Changes:
> 
> v6:
>   - lib: isntall trace-cmd.h directly in /usr/include and not subdir
>     trace-cmd. kernelshark builds breaks otherwise

No, this is not the real problem. The Makefile also installs it under
/usr/include/trace-cmd.
