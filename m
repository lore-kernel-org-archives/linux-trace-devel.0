Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5AFC3DA7D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Dec 2022 07:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiL0HeS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Dec 2022 02:34:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiL0HeR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Dec 2022 02:34:17 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F2F10DE
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Dec 2022 23:34:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EABCB6046B;
        Tue, 27 Dec 2022 07:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672126453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cSapgxGBbNXBtEtGxnZp/q8WQXxBoze/oo8V2GaJSCw=;
        b=VDWR9p6g8iyHWFiDebkjlevi+P457k0nTHAPexHDX56YIfXnv6MRT4UqAZ1iKV84Q7bjDv
        EYA6PGG+LhF25hV4WTirt1fFPIeYvsZaHdo24IRNjPM5D52G+2syJCjylvTjGs13hY/xnV
        ZVm9EJ4+50qJO6fuqml7ygFqD6yAdek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672126453;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cSapgxGBbNXBtEtGxnZp/q8WQXxBoze/oo8V2GaJSCw=;
        b=k8+7TXV11eifb8A4845jGOQ5mFAMOpG6ivjZu5445WC0fOwTrXcNoW56DYdVFMkqsh5j38
        wErbi8sXFByiO5Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DD60413913;
        Tue, 27 Dec 2022 07:34:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1EUDNvWfqmPRYgAAMHmgww
        (envelope-from <dwagner@suse.de>); Tue, 27 Dec 2022 07:34:13 +0000
Date:   Tue, 27 Dec 2022 08:34:13 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH v4] libtraceevent: Add initial support for meson
Message-ID: <20221227073413.z3furikgl7cnshka@carbon.lan>
References: <20221220180840.32586-1-dwagner@suse.de>
 <20221224153225.ojre2c3fxktfxtj2@carbon.lan>
 <20221224141620.5f44a6fb@rorschach.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221224141620.5f44a6fb@rorschach.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Dec 24, 2022 at 02:16:20PM -0500, Steven Rostedt wrote:
> On Sat, 24 Dec 2022 16:32:25 +0100
> Daniel Wagner <dwagner@suse.de> wrote:
> 
> > During my packaging attempt I found out that the man pages are installed
> > into subdirs. So I started to look into the this and ... let's say it's
> > complicated.
> 
> Oh, to make your life easier. That shouldn't happen.

To be honest most of the Meson stuff was pretty easy to get sorted
out. Generating documentation seems to be a good source of troubles. I
had also headache to sort this out for libnvme/nvme-cli.

> > For example libtraceevent-func_apis.txt list a few function which are
> > also listed in libtraceevent-func_find.txt. The Makefile uses these
> > function as build names but, if we have two targets with the same name
> > one will overwrite the other. make seems to tolerate something like
> > this. Meson doesn't.
> 
> That's actually a mistake :-/
> 
> The asciidoc complains whenever a man page has more than 9 functions
> described, so I have to break them up when I add more related APIs.
> 
> I probably missed removing some of the old functions when I did that
> here.

Ah, that explains it.

> > I am playing with various ideas how we could handle this. Currently, I
> > think the best way is to distinguish the different source txt files. So
> > we have files which are for generating a mans per function (1:n)
> > and we have txt files which are general documentation (1:1).
> 
> The real fix is to remove the tep_find_function() and
> tep_find_function_address() from libtraceevent-func_apis.txt.

Right, let me add this fix then.

Anyway, I got a new version almost ready. I try to package it with the
current version, verifying I got it sorted out.
