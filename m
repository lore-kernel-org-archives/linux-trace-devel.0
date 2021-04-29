Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA237C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 03:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DBAB61433
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 03:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbhD2Do5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 23:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbhD2Do5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 23:44:57 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC33C06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 20:44:11 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id y30so1024667pgl.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 20:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lMQ/uuAWTiPCNZrzcBWCebQlIotxZpaxyXWhuYhooG8=;
        b=UWtVU8VHEX3NiVlBZ/hp6sewXLq6H90088FNEqgFy8chjFYs7sxfugZ2ZqI4BHhJGp
         cqQMK+oxegdYQ/H1IXlb9T1dFl5Wfyr+q3OOkzaUVXD4o51DUv6pdqLBkLO+yEGgdN3t
         y/VSwXytE7hgakAQ84lpQt5bsiC3B5YkGQLLhXFCaqFCDZy33v96LvmnMDaZHwdrj7tQ
         M1aHX7nMX5jkSm6ohnv8KVIvAi7PDHgoIKar7/A67iPMiZsSxxMzn0gu92tsEQkKdrNA
         MS9LzCbSjhNjvpNCc5yqLkIviJy9mOf+lxtfr8VQYy2WVs8RP79bmNknr43E08t6lvBL
         0+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lMQ/uuAWTiPCNZrzcBWCebQlIotxZpaxyXWhuYhooG8=;
        b=XolM3Un28SnjVfif0j21gxfcCJ80AntgtuUgpzpI+yRKdVaLXDOD3Z1EeyomWZyqVT
         17CTLljyoIVkILzME294sSHmXldYkADyoUXNdY6HS6aZZHp0xbVmy+r6bCo00BTXp3Zs
         RogHw8kBQd1bWilb6yhFpdpxcQ9Kn1M5zmWWh1BFKX0wa/PjbhVykm4Dd/Z1dLHTqGwA
         Gxk6EVvToaDSu988wrTDXFjqg1Bkkm+G8P1PwD/cjCk2Kd5wME4p0Wuxv5ss8WJ9bi8o
         zANZkRS/iF6nF6OEdNNOGskKj4nnTGBZl7T/dajIbbUpcyYB28/agf7wDmUzDHW0ekke
         vtXw==
X-Gm-Message-State: AOAM533KhjSYs5vPCFcbydDud9BR3rfsHQ4Ob/dKwsnsCajkeqcTfcwU
        1sNMeSLUvL1rU7ROK55Dp/l5wURCm0rOIgYMYDhx+4T9MCg=
X-Google-Smtp-Source: ABdhPJyXucTGt7WtBEn+6dxn4nYtOdDUNHzuPbZhlLOTfaAThQ5kZLGV7WWKtYP4xSD8ILSIpvAaTA1Y/hPo4E1SOFA=
X-Received: by 2002:aa7:8051:0:b029:272:7b9c:cde1 with SMTP id
 y17-20020aa780510000b02902727b9ccde1mr23572582pfm.55.1619667850844; Wed, 28
 Apr 2021 20:44:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
 <20210422071718.483383-2-tz.stoyanov@gmail.com> <20210428211920.001a66c8@oasis.local.home>
In-Reply-To: <20210428211920.001a66c8@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 29 Apr 2021 06:43:54 +0300
Message-ID: <CAPpZLN5g3ySyo-sWpB9nyumRzQCLngzbwHeG6b1Z8YVW1augCg@mail.gmail.com>
Subject: Re: [PATCH 1/6] trace-cmd library: Bump the trace file version to 7
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 29, 2021 at 4:19 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 22 Apr 2021 10:17:13 +0300
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Adding a compression of the trace.dat file will change its structure.
> > These changes are not backward compatible, the old trace-cmd binaries
> > will not be able to read compressed trace files. Bumping the version to
> > 7 will prevent old trace-cmd to read such files.
>
> But this series doesn't add anything to the file that breaks the
> version. The version should be updated with the patch that breaks the
> backward compatibility. of the file, not before.
>
I need the new version before the compression changes, because there
is logic which relies on the new version. There is a check whether to
read / write compression data based on the new file version. I was
wondering if to put all changes into a single patchset, version +
compression. Decided to split in two, although there is no sense to
bump the version without adding a compression.


> -- Steve
[...]
-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
