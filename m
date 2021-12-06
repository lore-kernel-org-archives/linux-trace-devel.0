Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 330D8C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Dec 2021 16:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349288AbhLFQMp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 11:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445702AbhLFQMK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 11:12:10 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D2CC0698CD
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 07:53:10 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id n8so7342533plf.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Dec 2021 07:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6q8BtaUOsU2GWoLhd/2GJ6FxRWU2tnE1k0O4fzl+ssM=;
        b=Tyk3UR4hTaT2I+Uf2rrCX8zMgyKQWOyMeSdJESH8umw3Kerfnk/ZQJBQ16s2Qf5E3u
         F7ALKUaVSVO5HNm+p7INfknmcL1RSma7RtKuSpCuxFjVtLABxjImA6tck3O2YTzXkYqb
         mDonD0BnlNPZCdAQf/hB0chHELDPRwr8BwIapy6KvNoUoM2zb4avFRHTY9h2s3OhuLhO
         dy4wBfmAlSr8n7x6bb1VJL5b19ANnVwphvYDjckA9SKdSZU/KTmapNGuaniH2cBSSPZZ
         7JNP67SikfGGAHyaIRQr7+ePYaq9jT9xgGQX98WGD9rFgMir8giQiPGTINsK/CFdcmCY
         dznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6q8BtaUOsU2GWoLhd/2GJ6FxRWU2tnE1k0O4fzl+ssM=;
        b=TA0RbV1fbOu//WiqQdV7RNLiC5dgtndHdIoIvIhp2TvJmUkN+o39YcTjxO2lIIf7e3
         2nPx6KgBS0ayG3Zanz29oOdsXjpvlgrEz5RkJqcJXE9+4Pe85OizgDLP9wMPJoyS8EmX
         cc+ARzPOeP1YfM6bGj0GQC4xAPZWXfKcXMN76ZZ06lKjrNrxUt1Tb8IVCir/u9Mqn5oy
         XKBEgEbk9D1iopkOBhnNL4kS6y2egalVX8br2IEiDbXKFNgbnTQcWjEX4g0IZ45IbvG5
         6vv5o0dXgGI7EPLJCv9UntLBEZQrPY9HD5CDsEVuPzR+3wX/TMqZfmTarYWReKfc7vCD
         Do8A==
X-Gm-Message-State: AOAM531mP5T3Pw0VBIxhu/qmXf7lkgJ4xerJRoCUcqnogTOa5zFsotiT
        t1lw+/ngJ2WtHa8ZSy4pkW4V9zuU84E18borbmocfO1XQfmoGw==
X-Google-Smtp-Source: ABdhPJxpFg7P38YTlmG0/4S+DMulPhMlUsJl0ROm6jOAOFPb48JcfWEcB202uHGZXbEzjAe2IAQQ6J9r/oJKxTbwyKk=
X-Received: by 2002:a17:90a:4815:: with SMTP id a21mr38124636pjh.111.1638805990312;
 Mon, 06 Dec 2021 07:53:10 -0800 (PST)
MIME-Version: 1.0
References: <20211111150900.86585-1-tz.stoyanov@gmail.com> <20211203203553.5bc05010@gandalf.local.home>
 <CAPpZLN77x4P=p=DKvj4NMvv4LvVTpcfepFMbc_a-EwBzTkrWGQ@mail.gmail.com> <20211206095531.55f8b0b8@gandalf.local.home>
In-Reply-To: <20211206095531.55f8b0b8@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 6 Dec 2021 17:52:54 +0200
Message-ID: <CAPpZLN4MznQUGc-yn6Cebt5FdONcwsAR48ySt9S_XJ594XULqw@mail.gmail.com>
Subject: Re: [PATCH v5 04/25] trace-cmd library: Add internal helper function
 for writing headers before file sections
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Dec 6, 2021 at 4:55 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 6 Dec 2021 05:25:56 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > The only reason to have a string is for "trace-cmd dump" - to be able
> > to dump some description for unknown sections, we discussed that in
> > the past. But now when I'm looking at that again - there is no sense
> > to have it only for that reason, the ID is enough. I can remove the
> > string from the header.
>
> I think we also discussed it for when a new section was added that wasn't
> known to the current trace-cmd, that it could give a more useful message.
> i.e. "This version of trace-cmd does not handle 'New feature here', please
> upgrade your trace-cmd".
>
> That way, the user would at least know why that new feature is not being
> processed.
>

As we discussed, there are two possible approaches for these descriptions:
 1. To add a new section with these descriptions, that way there will
be no strings in the section headers. I was thinking more about that
approach, it will make the parsing much more complicated. As all
sections are dynamically located in the file, there is no strict order
- that "description" section can be anywhere, even at the end. That
way during the parsing these strings will not be available for the
sections before, and the description cannot be displayed. To solve
that, parsing should be done in two steps -  first to find that
"description" section to get all the strings, and second to parse the
other sections. The description should be part of the section being
parsed, that's why I decided to go with the second approach.
2. Have a fixed size description string in the section header, I think
32 bytes should be OK.

> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
