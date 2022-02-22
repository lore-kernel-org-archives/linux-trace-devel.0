Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D03C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 17:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiBVRfQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 12:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiBVRfP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 12:35:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A8516FDD2
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 09:34:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D989661336
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 17:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3BCC340E8;
        Tue, 22 Feb 2022 17:34:48 +0000 (UTC)
Date:   Tue, 22 Feb 2022 12:34:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] libtracefs: Add APIs for user_events to
 libtracefs
Message-ID: <20220222123447.244b8f57@gandalf.local.home>
In-Reply-To: <20220218225058.12701-1-beaub@linux.microsoft.com>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 18 Feb 2022 14:50:55 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> New APIs added:

Beau,

I'm not sure what you work load is, but if you can get out a v2 today (or
tomorrow), that would be great. I want to release libtracefs 1.3 in the
next couple of days, and I'm only holding it off to include these APIs.

At the moment, libtracefs looks good to go!

Thanks,

-- Steve
