Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C919CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Apr 2022 20:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347823AbiDRU4H (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 16:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbiDRU4G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 16:56:06 -0400
X-Greylist: delayed 586 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Apr 2022 13:53:26 PDT
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FCE22BD7
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Apr 2022 13:53:26 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4KhzRW3NyFz9sRj;
        Mon, 18 Apr 2022 22:43:35 +0200 (CEST)
Date:   Mon, 18 Apr 2022 22:43:29 +0200
From:   Hagen Paul Pfeifer <hagen@jauu.net>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v8 00/12] user_events: Enable user processes to create
 and write to trace events
Message-ID: <Yl3NcRRIJMrd0WZu@laniakea>
References: <20211216173511.10390-1-beaub@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216173511.10390-1-beaub@linux.microsoft.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

* Beau Belgrave | 2021-12-16 09:34:59 [-0800]:

>The typical scenario is on process start to mmap user_events_status. Processes
>then register the events they plan to use via the REG ioctl. The ioctl reads
>and updates the passed in user_reg struct. The status_index of the struct is
>used to know the byte in the status page to check for that event. The
>write_index of the struct is used to describe that event when writing out to
>the fd that was used for the ioctl call. The data must always include this
>index first when writing out data for an event. Data can be written either by
>write() or by writev().

Hey Beau, a little bit late to the party. A few questions from my side: What
are the exact weak points of USDT compared to User Events that stand in the
way of further extend USDT (in a non-compatible way, sure, just as an
different approach!)? The nice thing about USDT is that I can search for all
possible probes of the system via "find / | readelf | ". Since they are listed
in a dedicated ELF section (.note.stapsdt) - they are visible & transparent. I
can also map a hierarchy/structure in Executable/DSO via clever choice of
names. The big disadvantage of USDT is the lack of type information, but from
a registration, explicit point of view, they are nice.

Or in other words: why not extends the USDT approach? Why not

u32 val = 23;
const char *garbage = "tracestring";

DYNAMIC_TRACE_PROBE2("foo:bar", val, u32, garbage, cstring);


Sure, the argument names, here "val" and "garbage" should also be saved. I
also like the "just one additional header to the project to get things
running" (#include "sdt.h"). Sure, a DYNAMIC_TRACE_IS_ACTIVE("foo:bar") would
be great. But in fact we have never needed that in the past.


hgn

