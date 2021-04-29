Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D4EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3848161158
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhD2NR3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 09:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231343AbhD2NR3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 09:17:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9982C61158;
        Thu, 29 Apr 2021 13:16:42 +0000 (UTC)
Date:   Thu, 29 Apr 2021 09:16:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/6] trace-cmd library: Bump the trace file version to 7
Message-ID: <20210429091640.27dde3d8@gandalf.local.home>
In-Reply-To: <CAPpZLN5g3ySyo-sWpB9nyumRzQCLngzbwHeG6b1Z8YVW1augCg@mail.gmail.com>
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
        <20210422071718.483383-2-tz.stoyanov@gmail.com>
        <20210428211920.001a66c8@oasis.local.home>
        <CAPpZLN5g3ySyo-sWpB9nyumRzQCLngzbwHeG6b1Z8YVW1augCg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Apr 2021 06:43:54 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> On Thu, Apr 29, 2021 at 4:19 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Thu, 22 Apr 2021 10:17:13 +0300
> > "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
> >  
> > > Adding a compression of the trace.dat file will change its structure.
> > > These changes are not backward compatible, the old trace-cmd binaries
> > > will not be able to read compressed trace files. Bumping the version to
> > > 7 will prevent old trace-cmd to read such files.  
> >
> > But this series doesn't add anything to the file that breaks the
> > version. The version should be updated with the patch that breaks the
> > backward compatibility. of the file, not before.
> >  
> I need the new version before the compression changes, because there
> is logic which relies on the new version. There is a check whether to
> read / write compression data based on the new file version. I was
> wondering if to put all changes into a single patchset, version +
> compression. Decided to split in two, although there is no sense to
> bump the version without adding a compression.

The file should stay at version 6 unless it has something that old
trace-cmd can not read.

Right now, with this patch, if I record a trace.dat file, and I port the
version check to older trace-cmd, it will think it can not read this file,
even though there's nothing in this file.

In fact, it should write version 6 until it writes something that is not
supported by version 6.

It will still need to be able to write version 6 files. In fact that's one
of the requirements here. That we allow trace-cmd to create older versions
if it does not use the features of the the new version.

-- Steve
