Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DA1C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 15:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbiBVPmU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiBVPmT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 10:42:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A2F2C67B
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 07:41:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5EFB4CE175A
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 15:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70835C340F3;
        Tue, 22 Feb 2022 15:41:50 +0000 (UTC)
Date:   Tue, 22 Feb 2022 10:41:48 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs
 sources
Message-ID: <20220222104148.2d4b6905@gandalf.local.home>
In-Reply-To: <49f2d343-c265-6ebe-413e-c0d76e6c1cb9@gmail.com>
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
        <20220218225058.12701-2-beaub@linux.microsoft.com>
        <dba49d0e-cac5-5945-e02e-b45a6d751032@gmail.com>
        <20220221175720.GA1738@kbox>
        <20220221141625.60a7db50@rorschach.local.home>
        <c2b27dce-96fb-176e-51b9-df6f1ce760fa@gmail.com>
        <20220222090021.3f2ba377@rorschach.local.home>
        <49f2d343-c265-6ebe-413e-c0d76e6c1cb9@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 22 Feb 2022 16:25:35 +0200
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> I personally think that, using variadic arguments in library APIs is a
> not a good idea, because this enforces that the caller must know the
> number of those arguments at compile time.
> 
> For me the original solution that uses an array of items is better.
> Or maybe we can have both as 2 different APIs.

Actually, I was using the va_args as an example. I really didn't care about
the implementation of the arguments, except that they need to be added
after the enable check.

For now, lets just keep the two functions to check for the event being
enabled and recording. I think the last names were the way to go:

	tracefs_user_event_enabled();
	tracefs_user_event_record();

And keep the record using the array. If we want a macro, we could do:

#define tracefs_user_event_trace(event, ...)				\
	do {								\
		if (tracefs_user_event_enabled(event)) {		\
			struct tracefs_uevent_item items[] = {		\
				##__VA_ARGS__,				\
				{ TRACEFS_UEVENT_END },			\
			}						\
			tracefs_user_event_record(event, items);	\
		}							\
	} while (0)

And the user could have:

	tracefs_user_event_trace(event,
		{ TRACEFS_UEVENT_vstring, strlen(msg)+1, .data = msg });

Again, for those that do not want compile time knowledge of the arguments,
you just use the normal interface, and those that want the helper, to use
the macro.

-- Steve

