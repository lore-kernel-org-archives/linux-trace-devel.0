Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B6AC54EBD
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 16:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjAIQhD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 11:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjAIQhC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 11:37:02 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7004415F27
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 08:37:01 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E374120C8B;
        Mon,  9 Jan 2023 16:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673282219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pUSiIehxOeZNkTWpwxV0zhyG+mggIj4Q4R5A0Lv9noo=;
        b=iqtwgN3KdTuWt19/6mkQ8qeVaEtOqUMwI4GFmizK1jwGsI0M5RmQunc3yYSkD8E3bUM5Cv
        J1pYv4IXgxkFg+CSN/xTeCdDgj13X8g6ETAifojqBS/j7R+aWpTNmAEwZqMsJdgta5gWcZ
        qTcbqDa29kgCP6rFr5NUnC/+c/NHDk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673282219;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pUSiIehxOeZNkTWpwxV0zhyG+mggIj4Q4R5A0Lv9noo=;
        b=ZuJXl9jV6vtKkJMJa2/IYK5Y0aJ50zSUz+yaRLkFBmpcNpqri5TGVjwbF8xCsQnE2W6dF5
        /jhUdxyWe4y/1xAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D62FC13583;
        Mon,  9 Jan 2023 16:36:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yQtCNKtCvGOPeAAAMHmgww
        (envelope-from <dwagner@suse.de>); Mon, 09 Jan 2023 16:36:59 +0000
Date:   Mon, 9 Jan 2023 17:36:59 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6] libtraceevent: Add initial support for meson
Message-ID: <20230109163659.lddjs6zb45t32hyj@carbon.lan>
References: <20230105121144.11829-1-dwagner@suse.de>
 <20230109105616.168057c3@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109105616.168057c3@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 09, 2023 at 10:56:16AM -0500, Steven Rostedt wrote:
> Is the html files suppose to be there?

Don't know, I wasn't able to figure out the install path by
reading the Makefile. Where should they go?
