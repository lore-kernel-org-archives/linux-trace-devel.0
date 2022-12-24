Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E66C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 24 Dec 2022 19:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiLXTQ0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 24 Dec 2022 14:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLXTQZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 24 Dec 2022 14:16:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D0865BE
        for <linux-trace-devel@vger.kernel.org>; Sat, 24 Dec 2022 11:16:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FDE160B46
        for <linux-trace-devel@vger.kernel.org>; Sat, 24 Dec 2022 19:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F11CC433EF;
        Sat, 24 Dec 2022 19:16:22 +0000 (UTC)
Date:   Sat, 24 Dec 2022 14:16:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH v4] libtraceevent: Add initial support for meson
Message-ID: <20221224141620.5f44a6fb@rorschach.local.home>
In-Reply-To: <20221224153225.ojre2c3fxktfxtj2@carbon.lan>
References: <20221220180840.32586-1-dwagner@suse.de>
        <20221224153225.ojre2c3fxktfxtj2@carbon.lan>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 24 Dec 2022 16:32:25 +0100
Daniel Wagner <dwagner@suse.de> wrote:

> During my packaging attempt I found out that the man pages are installed
> into subdirs. So I started to look into the this and ... let's say it's
> complicated.

Oh, to make your life easier. That shouldn't happen.

> 
> For example libtraceevent-func_apis.txt list a few function which are
> also listed in libtraceevent-func_find.txt. The Makefile uses these
> function as build names but, if we have two targets with the same name
> one will overwrite the other. make seems to tolerate something like
> this. Meson doesn't.

That's actually a mistake :-/

The asciidoc complains whenever a man page has more than 9 functions
described, so I have to break them up when I add more related APIs.

I probably missed removing some of the old functions when I did that
here.

> 
> I am playing with various ideas how we could handle this. Currently, I
> think the best way is to distinguish the different source txt files. So
> we have files which are for generating a mans per function (1:n)
> and we have txt files which are general documentation (1:1).

The real fix is to remove the tep_find_function() and
tep_find_function_address() from libtraceevent-func_apis.txt.

-- Steve
