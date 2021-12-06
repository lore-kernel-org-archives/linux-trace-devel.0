Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BC9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Dec 2021 14:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344671AbhLFO7E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 09:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344670AbhLFO7E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 09:59:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBA5C061746
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 06:55:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B302B810B3
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 14:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3614C341C1;
        Mon,  6 Dec 2021 14:55:32 +0000 (UTC)
Date:   Mon, 6 Dec 2021 09:55:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v5 04/25] trace-cmd library: Add internal helper
 function for writing headers before file sections
Message-ID: <20211206095531.55f8b0b8@gandalf.local.home>
In-Reply-To: <CAPpZLN77x4P=p=DKvj4NMvv4LvVTpcfepFMbc_a-EwBzTkrWGQ@mail.gmail.com>
References: <20211111150900.86585-1-tz.stoyanov@gmail.com>
        <20211203203553.5bc05010@gandalf.local.home>
        <CAPpZLN77x4P=p=DKvj4NMvv4LvVTpcfepFMbc_a-EwBzTkrWGQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 6 Dec 2021 05:25:56 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> The only reason to have a string is for "trace-cmd dump" - to be able
> to dump some description for unknown sections, we discussed that in
> the past. But now when I'm looking at that again - there is no sense
> to have it only for that reason, the ID is enough. I can remove the
> string from the header.

I think we also discussed it for when a new section was added that wasn't
known to the current trace-cmd, that it could give a more useful message.
i.e. "This version of trace-cmd does not handle 'New feature here', please
upgrade your trace-cmd". 

That way, the user would at least know why that new feature is not being
processed.

-- Steve
