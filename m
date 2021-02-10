Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254E3C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 15:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D459464DDA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 15:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhBJPjb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Feb 2021 10:39:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230263AbhBJPja (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Feb 2021 10:39:30 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB6264DDA;
        Wed, 10 Feb 2021 15:38:48 +0000 (UTC)
Date:   Wed, 10 Feb 2021 10:38:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH][WIP]libtracefs:New API to enable the filtering of
 functions
Message-ID: <20210210103846.1ccbc4f1@gandalf.local.home>
In-Reply-To: <CAK7tX=YfQ4SGdUu3ac7bwRw0jGKBzgrNGtVib6VfrBUYEdJj2g@mail.gmail.com>
References: <CAK7tX=angRdxNdg2yNnss-NuBm+i-Y3unyT6BaeY0Quj-QB+UA@mail.gmail.com>
        <CAPpZLN7ysUKXLXwCbkfq+-OMhzUOXtDam+937gquDX4uT_nTHQ@mail.gmail.com>
        <20210209115855.37826f7f@gandalf.local.home>
        <CAK7tX=YfQ4SGdUu3ac7bwRw0jGKBzgrNGtVib6VfrBUYEdJj2g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 11 Feb 2021 08:33:50 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

> By this you mean to say like, we have to do the filter functions
> validation in the API?
> or
> shall we continue with tzvetomir idea (I mean depending on the kernel
> validation)?

I mean write to the file, and if it errors, then do our own operations on
it. This would need to be documented in the man page for this function.


For example:

   filter = "sched*"

would write into the file, which the kernel should turn into a selection of
all functions that start with "sched".

But if you had:

   filter = "sched_feat_[^w].*"

Which would set "sched_feat_open" and "sched_feat_show" but not
"sched_feat_write". Since it is a regex and not a glob expression, it will
fail the filter.

 fd = open("set_ftrace_filter", O_WRONLY);
 write(fd, "sched_feat_[^w].*", 7);

Will return an error of EINVAL. When that happens, you should run this
through the regex exec, and then use the result to find all the matches.

Note, it should be implied that if the regex does not start with "^" and
end with "$", then that should be added too.

  "sched_feat_[^w].*" turns into "^sched_feat_[^w].*$"

before processing it into the regex.

You may be asking, what if someone wants to add something that is a regex,
but also acceptable as a glob?

Let's say you want "_*acpi_device_uevent_modalias", where you want:

 "__acpi_device_uevent_modalias" and "acpi_device_uevent_modalias"

But the glob would only select "__acpi_device_uevent_modalias"

To force the regex, the user should just add "^" to the beginning of the
string.

Thus "_*acpi_device_uevent_modalias" wont work as expected, but
"^_*acpi_device_uevent_modalias" will.

Make sense?

-- Steve

