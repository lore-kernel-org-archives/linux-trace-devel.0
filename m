Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00E4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Feb 2022 04:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiBKEA0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 23:00:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiBKEA0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 23:00:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C5B5F84;
        Thu, 10 Feb 2022 20:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2021B827BA;
        Fri, 11 Feb 2022 04:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF800C340E9;
        Fri, 11 Feb 2022 04:00:22 +0000 (UTC)
Date:   Thu, 10 Feb 2022 23:00:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     mhiramat@kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 00/12] user_events: Enable user processes to create
 and write to trace events
Message-ID: <20220210230021.3baf81ce@rorschach.local.home>
In-Reply-To: <20220118204326.2169-1-beaub@linux.microsoft.com>
References: <20220118204326.2169-1-beaub@linux.microsoft.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 18 Jan 2022 12:43:14 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> User mode processes that wish to use trace events to get data into
> ftrace, perf, eBPF, etc are limited to uprobes today. The user events
> features enables an ABI for user mode processes to create and write to
> trace events that are isolated from kernel level trace events. This
> enables a faster path for tracing from user mode data as well as opens
> managed code to participate in trace events, where stub locations are
> dynamic.

So I finished my review, and I'm currently added it to my queue that
I'm running through my tests.

Before I accept it though, I would really like you to send patches to
linux-trace-devel@vger.kernel.org that add an API to libtracefs:

  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/

Something where users do not need to know about ioctls, or iovecs, etc.

struct tracefs_user_event *
     tracefs_user_event_register(const char *name,
		enum tracefs_uevent_type type,
		char *field, ...);

Where tracefs_uevent_type can be:

enum tracefs_uevent_type {
	TRACEFS_UEVENT_END,
	TRACEFS_UEVENT_u8,
	TRACEFS_UEVENT_s8,
	TRACEFS_UEVENT_u16,
	...
};

  uevent = tracefs_user_event_register("test",
		TRACEFS_UEVENT_u64, "count",
		TRACEFS_UEVENT_string, "name",
		TRACEFS_UEVENT_array, 16, "array",
		TRACEFS_UEVENT_END);

and that will do the ioctl to register the event, with the given types
and fields.

  struct tracefs_user_event_status *ustatus;

  ustatus = tracefs_user_event_status();  // does the mmap.


Then we could also have:

  if (tracefs_user_event_test(ustatus, uevent))
	tracefs_user_event_write(uevent, 64, "string", { 16 byte data });

The ustatus will be the mmap and the uevent will have the information
to know where on the mmap to test for the event.

As for the write, the types are saved, and the write function will have
variable arguments defined by the tracefs_user_event_register().

I think having that interface in libtracefs, would make this easy to
use for everyone.

-- Steve

