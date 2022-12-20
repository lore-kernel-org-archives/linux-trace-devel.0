Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B071C4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Dec 2022 21:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiLTVfR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 16:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiLTVfQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 16:35:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACA5CE0A
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 13:35:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85777615B7
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 21:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79240C433EF;
        Tue, 20 Dec 2022 21:35:13 +0000 (UTC)
Date:   Tue, 20 Dec 2022 16:35:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mike Frysinger <vapier@google.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Ross Zwisler <zwisler@google.com>
Subject: Re: [PATCH] libtraceevent: Have 32 bit compile with
 -D_FILE_OFFSET_BITS=64
Message-ID: <20221220163511.3acc06ff@gandalf.local.home>
In-Reply-To: <CAAbOScks--ApY2b+4voM73PSx5dL1rLU7R3=8Bs66HDKN-6LMA@mail.gmail.com>
References: <20221219173414.032e2124@gandalf.local.home>
        <CAAbOScnLETawvZYhZnhVMP_rs6tYEty1-LcWGD9JcQX5tbQW5A@mail.gmail.com>
        <20221220160002.1a34d937@gandalf.local.home>
        <CAAbOScks--ApY2b+4voM73PSx5dL1rLU7R3=8Bs66HDKN-6LMA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 20 Dec 2022 16:29:49 -0500
Mike Frysinger <vapier@google.com> wrote:

> i am certainly by no means an expert in this codebase.  from glancing
> at it, the impact is that people won't be able to load any plugins
> right ?  that's where stat() & readdir() appear to be used (the dirent
> returned by readdir has both ino_t & off_t in it).

If the plugins are not added, it will just not format some of the trace
events properly.

The plugins are used for better pretty printing the data, otherwise it just
prints out the field contents in their raw formats.

-- Steve
