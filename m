Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E525EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Dec 2021 03:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbhLFD3l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 5 Dec 2021 22:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236194AbhLFD3k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 5 Dec 2021 22:29:40 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22CEC0613F8
        for <linux-trace-devel@vger.kernel.org>; Sun,  5 Dec 2021 19:26:12 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id x131so8876412pfc.12
        for <linux-trace-devel@vger.kernel.org>; Sun, 05 Dec 2021 19:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Al2Yb0vWzHsSi+HHumuV65n1V+2pa16ykITUWcmN8S4=;
        b=Jgx/bmkfhq7z1VtRFPrARXxhtfGQLbllQCryR3GKKU9U5l4E/lNGXXcQfQEG37uM4F
         KtCPSX3KAICJPIaoJbC7lvva31vaxW03UxOSxLlieNrxmF8sBpQGJ1AiMHEev2UDjtic
         bdwHQEaFKd0yOh1gFxN9/qCWKOYB2Gn/NGZmVD+PHrjKkOdKlrHqfwnQ8Lhe5h3ssY6M
         tkyLbZYf3eYgMBf58ojLCqWyXJGovKq0mLae9utRZdQnWMXRCygmkUJ0lTQGwtO5LlcI
         3xmioat0uD3NYxbeQyf/+oRS3f1/CINN8tMXaPrtwMBlW6q1EfNaVZB+7hihAy9tPqYC
         olwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Al2Yb0vWzHsSi+HHumuV65n1V+2pa16ykITUWcmN8S4=;
        b=NyrB1ccaDS7ZZ7D2ESupEKT1CRoLF1oQho2Qdv/+yVtkRPQTGmPr4mTmdSgwiXzDnI
         fGhy5upn7m7E9Xs01umjbbqlDaqDuUIRhrBFnLeiDSa5ObRAArr2Blr68778tceIhv6G
         QRa17aLP3RG97XPc+rYhvJ+jBvo6UmN0b/o2Iq826q4aJCZCByVb0sXnBHlBsSPfh+8y
         UbhufBIpZtnOGqxfGIqJCesnJSuV9mz/H+dm17Vv0tOBH9ubpfpm7z+E/zpp8WjAbV++
         TTQHwyAml1pmHmoRYl2lIn+1Qe6CXuyVazUhJNYXiYkLBZGX0vGzVyTeKVaUI/+BhQQG
         dnDw==
X-Gm-Message-State: AOAM531rKMFZVF3LoEUEoYRDMa5lBQltSRmXu0B0MfMOXYo/YRRJaUR6
        rvD6XmtSYbBgzbSx1PHZ3GHN+qfiD7Y2ID1veVYsDYaps0A=
X-Google-Smtp-Source: ABdhPJzbQlVY8JD0fk46o9dO+OgN2FZhAJ9mIH+8nkd+mDns5Reyd97QIRWhFMpwVFK9b1zfB9DTtrg0DEDcI8ZE9ZU=
X-Received: by 2002:a63:130c:: with SMTP id i12mr16998071pgl.297.1638761172452;
 Sun, 05 Dec 2021 19:26:12 -0800 (PST)
MIME-Version: 1.0
References: <20211111150900.86585-1-tz.stoyanov@gmail.com> <20211203203553.5bc05010@gandalf.local.home>
In-Reply-To: <20211203203553.5bc05010@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 6 Dec 2021 05:25:56 +0200
Message-ID: <CAPpZLN77x4P=p=DKvj4NMvv4LvVTpcfepFMbc_a-EwBzTkrWGQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/25] trace-cmd library: Add internal helper function
 for writing headers before file sections
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Dec 4, 2021 at 3:35 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 11 Nov 2021 17:09:00 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Introduce headers before each file section, in trace file version 7. The
> > section header has the following format:
> >  <2 bytes>, header ID
> >  <string>, null terminated ASCII string, description of the header
>
> We may have discussed this before, but I don't remember. Why did we make
> the second item a string? I would think we would want all the fixed size
> portions of the header to be first, and the variable size portion to be
> last?
>
The only reason to have a string is for "trace-cmd dump" - to be able
to dump some description for unknown sections, we discussed that in
the past. But now when I'm looking at that again - there is no sense
to have it only for that reason, the ID is enough. I can remove the
string from the header.

>  <2 bytes> header ID
>  <2 bytes> section flags
>  <4 bytes> size of section.
>
> Although, is 4 bytes big enough? Perhaps it should be 8 bytes? What happens
> if a section is bigger than 4 gigs?

agree, I will make it 8 bytes in the next version.

>
> And then have the string description at the end. Thoughts?
>
> -- Steve
>
>
> >  <2 bytes>, section flags:
> >      1: the section is compressed
> >  <4 bytes>, size of the section
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  include/trace-cmd/trace-cmd.h                 |  5 ++
> >  .../include/private/trace-cmd-private.h       |  1 +
> >  lib/trace-cmd/include/trace-cmd-local.h       |  5 ++
> >  lib/trace-cmd/trace-output.c                  | 68 +++++++++++++++++++
> >  4 files changed, 79 insertions(+)
> >



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
