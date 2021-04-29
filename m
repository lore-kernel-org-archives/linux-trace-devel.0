Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE7EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 03:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D906E613CC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 03:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbhD2DxD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 23:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbhD2DxD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 23:53:03 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7108AC06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 20:52:16 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so10173205pjh.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 20:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z6qWfQVr8rc02/F1XiCKJu5Lus1pPEmJMulWtMrOeSY=;
        b=ml80iTCpn6pzObESAyL3YHB3PGE1DCglGxNLfxvAWGE71Q1rGeVZxPh4f2FfXtvARO
         gZImconsR1/4jDoVe+ZBXL/QMYtmKETmVJ4F4fK39z5OK9wWfGUfOviqYzI6dnj4laEO
         VFCc+Z9tri7yXqPyEfqU/ZWm3noVj3Zixi/WPIq/XjrOezk2r7yxK59v5T92DzIKS+3N
         6c+oWZKMz4N4xiwjJmf6NeoKvtvNhn3jLcTbOR9RHPCrh771poBoYA1YcDrkU/Tijukc
         2ZGI49lcCYBytUMekyjlrApFtl9pwOU/9USAOEARQoKY8QPzRmNVdNmj7UHHtEmfLQ6D
         fapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z6qWfQVr8rc02/F1XiCKJu5Lus1pPEmJMulWtMrOeSY=;
        b=ELCRgDIv9z2S2GGF+zuc6ZbEI8sx5Zebwj8RXa1p26CRTqK+8K1F+lddsBvuY05PoN
         jfhDh3WT1EF68uQOHdYZV/9E6MDAJ/b6kdgpmoGyRh2P0P+5CpaQP2Z6yWL/SkCXxJ3k
         GoTrH0z0cqYsHIordFVwMey7xc/T1lepWcIBeT0Z2mJgpP38I7O/QUAkgZS0Jva2xkcM
         llnHBlt6G3gJ2JDX6X+Booyc7K/GnI+qs/ubjBl1ymwcnoX89fnrk4epD9CpIjZILJur
         STXX/DznvC8B+27UqR0HaAfX+vyYdzIIIbxPsIIQEOGYTirCOsyJF/QFIkq+Mv2VkylA
         cq/g==
X-Gm-Message-State: AOAM533bwAH68wd0iJ5rqIcVPG+oNiZUjzL5bdN8zNJVVwSiX/uUrPws
        ZlWKvtFV+/22lGQ6Jn+JD/dF+adv4FGBwKeqCTSfvAtLS5OH/w==
X-Google-Smtp-Source: ABdhPJx5wkw6dHMkiradr2WbwLfTtV29KtM+7NwVmATEL6TXG9hqvgvPEF1VudGS2RmhJlOCuIaPKo7S483cekMKQ3k=
X-Received: by 2002:a17:90b:3b43:: with SMTP id ot3mr35739953pjb.100.1619668335991;
 Wed, 28 Apr 2021 20:52:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210422073902.484953-1-tz.stoyanov@gmail.com> <20210428213506.7791db62@oasis.local.home>
In-Reply-To: <20210428213506.7791db62@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 29 Apr 2021 06:51:59 +0300
Message-ID: <CAPpZLN78vkjhiOOUx0gFjm+5NtPqGGtXJ3ECh_BP7V7rJYB0+w@mail.gmail.com>
Subject: Re: [POC PATCH 00/10] Add trace file compression
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 29, 2021 at 4:35 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 22 Apr 2021 10:38:52 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > A new PoC implementation for adding a compression to trace file version 7.
> > A basic infrastructure for compression support is added into the trace-cmd
> > library. The zlib is used for compression, but more libraries and algorithms
> > can be added. Only part of the trace file metadata is compressed:
> >  - ftrace events format
> >  - format of recorded events
> >  - information about the mapping of function addresses to the function names
> >  - trace_printk() format strings
> >  - information of the mapping a PID to a process name
> >
> > Note: not all trace-cmd commands are tested with these changes. These are
> > verified to work with compressed trace files:
> >  trace-cmd record
> >  trace-cmd report
> >  trace-cmd dump
> >
> > Todo list, in order to have complete trace file compression:
> >  - Compress trace file options.
> >  - Compress trace data.
> >  - Add support for more compression libraries.
> >  - Add new trace-cmd command to convert trace files from version 6 to
> >    version 7 and vise versa.
> >  - Add compression support to all trace-cmd commands.
> >  - Update trace-cmd documentation.
> >
> > This patch set depends on "[PATCH 0/6] Bump trace file version"
> > and should be applied on top of it.
> > https://lore.kernel.org/linux-trace-devel/20210422071718.483383-1-tz.stoyanov@gmail.com/
> >
> > Tzvetomir Stoyanov (VMware) (10):
> >   trace-cmd: Add APIs for library initialization and free
> >   trace-cmd library: Add support for compression algorithms
> >   trace-cmd library: Compress part of the trace file
> >   trace-cmd library: Read compressed trace file
> >   trace-cmd library: Add new API to get compression of input handler
> >   trace-cmd library: Inherit compression algorithm from input file
> >   trace-cmd library: Extend the create file APIs to support different
> >     compression
> >   trace-cmd record: Add new parameter --compression
> >   trace-cmd dump: Add support for trace files version 7
> >   trace-cmd library: Add support for zlib compression library
>
> I'm not able to apply these patches as I'm getting conflicts from your
> previous series that bumps the version number, as if what you sent to
> the mailing list was not what you have in your git repo.
>
> Can you please resend the version update patch series.

The order of applying the changes should be:
1. [PATCH v2] trace-cmd: Check if file version is supported
  https://lore.kernel.org/linux-trace-devel/20210419093156.200099-1-tz.stoyanov@gmail.com/
2. [PATCH 0/6] Bump trace file version
 https://lore.kernel.org/linux-trace-devel/20210422071718.483383-1-tz.stoyanov@gmail.com/
3. [POC PATCH 00/10] Add trace file compression
 https://lore.kernel.org/linux-trace-devel/20210422073902.484953-1-tz.stoyanov@gmail.com/

I wrote these dependencies in the cover-letters.  BTW, I do not see
(2) in patchwork, only in the mailing list.
I'll send v2 of "Bump trace file version" including (1) in the patchset.

>
> -- Steve
>
>
> >
> >  lib/trace-cmd/Makefile                        |  11 +
> >  .../include/private/trace-cmd-private.h       |  42 ++-
> >  lib/trace-cmd/include/trace-cmd-local.h       |   7 +
> >  lib/trace-cmd/trace-compress-zlib.c           | 172 ++++++++++
> >  lib/trace-cmd/trace-compress.c                | 289 +++++++++++++++++
> >  lib/trace-cmd/trace-input.c                   | 304 +++++++++++++-----
> >  lib/trace-cmd/trace-output.c                  | 268 ++++++++++++---
> >  lib/trace-cmd/trace-util.c                    |  12 +
> >  tracecmd/trace-cmd.c                          |  11 +-
> >  tracecmd/trace-dump.c                         | 164 ++++++++--
> >  tracecmd/trace-record.c                       |  18 +-
> >  tracecmd/trace-restore.c                      |   4 +-
> >  tracecmd/trace-usage.c                        |   1 +
> >  13 files changed, 1152 insertions(+), 151 deletions(-)
> >  create mode 100644 lib/trace-cmd/trace-compress-zlib.c
> >  create mode 100644 lib/trace-cmd/trace-compress.c
> >
>


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
