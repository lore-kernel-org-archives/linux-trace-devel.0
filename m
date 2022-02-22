Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94DEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 14:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiBVOAw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232635AbiBVOAu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 09:00:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73060127D5A
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 06:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FEA961456
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 14:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A473C340E8;
        Tue, 22 Feb 2022 14:00:22 +0000 (UTC)
Date:   Tue, 22 Feb 2022 09:00:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs
 sources
Message-ID: <20220222090021.3f2ba377@rorschach.local.home>
In-Reply-To: <c2b27dce-96fb-176e-51b9-df6f1ce760fa@gmail.com>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
        <20220218225058.12701-2-beaub@linux.microsoft.com>
        <dba49d0e-cac5-5945-e02e-b45a6d751032@gmail.com>
        <20220221175720.GA1738@kbox>
        <20220221141625.60a7db50@rorschach.local.home>
        <c2b27dce-96fb-176e-51b9-df6f1ce760fa@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Feb 2022 08:27:31 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> I have one last question. Do you consider as a valid use case that
> the library must support, someone to do a just 'test" without writing
> after this, or to "write" without testing first?

Actually, that's a very good point.

I was thinking that I didn't like the "test" name, and was thinking of
having it be:

	if (tracefs_user_event_enabled(event)) {
		tracefs_user_event_record(event, ...);
	}

But I think you have a good point. Perhaps we should just have:

	tracefs_user_event_trace(event, ...);

and it do all the work. But it would need to be a macro, that does:

#define tracefs_user_event_trace(event, ...)			\
	do {							\
		if (tracefs_user_event_enabled(event)) {	\
			tracefs_user_event_record(event, ##__VA_ARGS); \
		}						\
	} while (0)

Because we do not want to have the compiler process the arguments when
the event is not enabled. That would be too much overhead.

But as a macro, it would work.

Thoughts?

-- Steve
