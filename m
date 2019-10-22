Return-Path: <SRS0=a4XR=YP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19F4CA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 17:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D33DF20B7C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 17:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfJVRr6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 13:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727152AbfJVRr6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 13:47:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DFAE20B7C;
        Tue, 22 Oct 2019 17:47:57 +0000 (UTC)
Date:   Tue, 22 Oct 2019 13:47:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v12 5/9] trace-cmd: Refactored few functions in
 trace-record.c
Message-ID: <20191022134756.26aa6903@gandalf.local.home>
In-Reply-To: <20190828085746.26231-6-tz.stoyanov@gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
        <20190828085746.26231-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Aug 2019 11:57:42 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Patch looks good. Just need some fixes in the change log.

Subject: "trace-cmd: Refactored some functions in trace-record.c"

> 
> In order to reuse the code inside the trace-cmd application, few

 "a few"

> functions from trace-record.c are refactored:
>   - make_instances() and tracecmd_remove_instances() are splited.

 "are split"

> New ones are created: tracecmd_make_instance() and tracecmd_remove_instance(),

 "Following functions were added to export static functionality:
    tracecmd_make_instance()
    tracecmd_remove_instance()"


> which are visible outside the trace-record.c

 "outside of trace-record.c"

>   - Following functions are made non-static: tracecmd_init_instance()
> get_instance_dir(), write_instance_file(), write_tracing_on(),
> tracecmd_set_clock()

Make the above more a visible list.

    - The following functions are made non-static:
         tracecmd_init_instance()
         get_instance_dir()
         write_instance_file()
         write_tracing_on()
         tracecmd_set_clock()

And don't be afraid to add empty lines between these bullet points. It
makes it easier to read. Whitespace can be your friend ;-)

>   - New function is implemented: tracecmd_local_cpu_count(), an internal
> API to get local_cpu_count.

Turn the above into:

    - Created a new function:
        tracecmd_local_cpu_count() - an internal API to get the
                                     local_cpu_count.


Note, if you do bullet lists, please keep everything aligned, and space
out the bullet list.

Instead of:

>>>>
  - Following functions are made non-static: tracecmd_init_instance()
get_instance_dir(), write_instance_file(), write_tracing_on(),
tracecmd_set_clock()
  - New function is implemented: tracecmd_local_cpu_count(), an internal
API to get local_cpu_count.
<<<<

Have:

>>>>
  - Following functions are made non-static: tracecmd_init_instance()
    get_instance_dir(), write_instance_file(), write_tracing_on(),
    tracecmd_set_clock()

  - New function is implemented: tracecmd_local_cpu_count(), an internal
    API to get local_cpu_count.
<<<<

Much easier to read.

Proper spacing is critical for change logs. It makes things stand out
much easier when scanning a "git log" looking for something specific.
When there's a lot of text bound together, it's much harder to find
something unless you know exactly what to search for via a search
string.

Thanks!

-- Steve


> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  tracecmd/include/trace-local.h |  9 ++++
>  tracecmd/trace-record.c        | 88 +++++++++++++++++++---------------
>  2 files changed, 59 insertions(+), 38 deletions(-)
> 
