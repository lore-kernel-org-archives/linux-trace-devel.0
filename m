Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C53C5479D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Jan 2023 17:16:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbjAIRQF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Jan 2023 12:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237369AbjAIRPk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Jan 2023 12:15:40 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E8D17E3D
        for <linux-trace-devel@vger.kernel.org>; Mon,  9 Jan 2023 09:15:23 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5617B1FECE;
        Mon,  9 Jan 2023 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673284522; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eFG8RX230b0OJI+ULnDIuSKtC51SSSEPmiR1zHc30+Q=;
        b=ykOaSi9trHAUvxjVYXa5y4CkzfjtGGTQP8epJhdSpDlvla5S5yJorUuCv64UQJk5nvypGr
        1ZImgCp2h/cRVB5javkcA10IdTzVxCPKXzFuOj2p9FjZ1FvQHhdFKMFZJCiPfGpYDiHoNS
        zwzULzOLAzQxmuPJpwgRriHiiQouEjQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673284522;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eFG8RX230b0OJI+ULnDIuSKtC51SSSEPmiR1zHc30+Q=;
        b=HEfuziwo5vBG0uSAiUbbbiQQVYRa2mzy392nse9myf2oRVAY9Lv4YsOGf4+MEdsCCiJbN3
        mus60jReGtUe+aCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47A43134AD;
        Mon,  9 Jan 2023 17:15:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KxR5EapLvGNNDwAAMHmgww
        (envelope-from <dwagner@suse.de>); Mon, 09 Jan 2023 17:15:22 +0000
Date:   Mon, 9 Jan 2023 18:15:21 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6] libtraceevent: Add initial support for meson
Message-ID: <20230109171521.6pk2ukuimtfzreg3@carbon.lan>
References: <20230105121144.11829-1-dwagner@suse.de>
 <20230109105616.168057c3@gandalf.local.home>
 <20230109163659.lddjs6zb45t32hyj@carbon.lan>
 <20230109114247.4cc214ff@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109114247.4cc214ff@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 09, 2023 at 11:42:47AM -0500, Steven Rostedt wrote:
> On Mon, 9 Jan 2023 17:36:59 +0100
 After doing an install with the Makefiles:
> 
> # ls -l /usr/local/share/doc/libtraceevent-doc/

Okay, that's easy to fix

--- a/meson_options.txt
+++ b/meson_options.txt
@@ -4,7 +4,7 @@

 option('plugindir', type : 'string',
        description : 'set the plugin dir')
-option('htmldir', type : 'string', value : '',
+option('htmldir', type : 'string', value : 'share/doc/libtraceevent-doc',
        description : 'directory for HTML documentation')
 option('asciidoctor', type : 'boolean', value: false,
        description : 'use asciidoctor instead of asciidoc')

Is anything which I need to update?
