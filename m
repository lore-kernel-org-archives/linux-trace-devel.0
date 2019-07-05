Return-Path: <SRS0=byw1=VC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A061DC46499
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 10:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74B0920989
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Jul 2019 10:25:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ETg0VeY2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfGEKZU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 06:25:20 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42662 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfGEKZU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 06:25:20 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so18075008ior.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Jul 2019 03:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9qEBgIsAQHug4HkR95U19afJXKUZWcu4i8mqkztaBhg=;
        b=ETg0VeY2UJDGEQP224HNmMVnynTFc03YVE2GzcKHVzWO+yHUIS6K+5yQp00OLxJ4n0
         NwetELiQaYWh81o+ngTwQ1M+WqhaLp7Q7oDtXN5AVPDcn98i/c7QJC4BjdoHe2SvP4ei
         lnnbws7zI8Mm52BgX+6tNPpd40SDiXjDXROt5CcJOYrQxpxkRn0H0mRx7jmEJk5O/dxF
         ErD7j2MWnYiAeixShv8Pi7m3+yarqgamb82Gfb6yIjmksR5/o2Y5Swjc6tfqDmpzR/ph
         sdLp30jKi5yA5b5QrG0v8eTGSGoFv8YcT8BMjjX3Y/Dqn+TRom9x0xEsa8G4tV9I3CIE
         gyZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9qEBgIsAQHug4HkR95U19afJXKUZWcu4i8mqkztaBhg=;
        b=biuDIhy3BesANiq8/rOp7AuCf6s7v3ow6iA72OFB9vPv01NUSSWUSGa0QQjDMpY+U+
         mBME89TH5Kb6k0QkBv6my8aq+ldCSy9RqJekpqpKrfGVB99UA7myBbshivujK//vAzWC
         NNgC/XfhG7IdTr3DomC49+H1JfyQWSWBgq1cJ1c/YeX6asy9dqYdVg93XU+E8XBoxpgF
         YMYoPZM3DYSjvdteFIk1OA5NHMkWiauVy13iHURT6TWgdRxkbPxSMetm0JoGlYtxtRwO
         3U3rO4F+Rq/ZXvHIUHAuiW5j7pIb9UIgDh1AUySFw/xFSRqnqHx8NSTP3Q2PFo2qHnlU
         zzyQ==
X-Gm-Message-State: APjAAAVnEifoF1Lj4jg47VqrKeZmqhv96ycOfG9JLmvBAocfHUGqYe93
        jYDTaPWxQ5BR6BklgmOCuhZAUEbzYTdkJtOzsg==
X-Google-Smtp-Source: APXvYqw+NqEj5fgcGF/3OXqDPmzy2G2SceEMWxVbCs08ffmeo85uQcv5luBrtWDhv2N0VJ5nOGOm4cM7zNvDVXxDS1Y=
X-Received: by 2002:a5d:9642:: with SMTP id d2mr3242329ios.278.1562322319188;
 Fri, 05 Jul 2019 03:25:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190703121023.16655-1-y.karadz@gmail.com>
In-Reply-To: <20190703121023.16655-1-y.karadz@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 5 Jul 2019 13:25:08 +0300
Message-ID: <CAE0o1NvF0+aojaPYnmHc_-eUnwxgLP_oXkSYU-hpm8ydFzKE8w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] Add support for text rendering
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Jul 3, 2019 at 3:10 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
> Implemented using the single-file public domain library "stb_truetype":
> https://github.com/nothings/stb/blob/master/stb_truetype.h
>
> PS: Patch 1/3 is a simple fix suggested by Slavomir which strictly
> speaking is independent from the other two patches.
>
> v2 changes:
>   - 2 new patches (patches 4/5 and 5/5).
>
>   - Added a procedure for finding a font file (patch 2/5).
>
>   - Addressed the comments made by Slavomir in his review of the previous
>   version.
>
> Yordan Karadzhov (VMware) (5):
>   kernel-shark: Simplify the drawing of the Triangle Fan
>   kernel-shark: Add support for drawing text
>   kernel-shark: Add text rendering to the plotting example
>   kernel-shark: Add hello_kernel plugin
>   kernel-shark: Drop Freeglut as a compulsory dependency
>
>  kernel-shark/build/deff.h.cmake      |    3 +
>  kernel-shark/doc/dox_config          |    1 +
>  kernel-shark/examples/CMakeLists.txt |   14 +-
>  kernel-shark/examples/dataplot.cpp   |   11 +
>  kernel-shark/examples/hello_kernel.c |   67 +
>  kernel-shark/src/CMakeLists.txt      |    4 +-
>  kernel-shark/src/KsGLWidget.cpp      |    4 -
>  kernel-shark/src/KsPlotTools.cpp     |    4 -
>  kernel-shark/src/libkshark-plot.c    |  239 +-
>  kernel-shark/src/libkshark-plot.h    |   46 +
>  kernel-shark/src/libkshark-plugin.h  |    3 +
>  kernel-shark/src/stb_truetype.h      | 4882 ++++++++++++++++++++++++++
>  12 files changed, 5243 insertions(+), 35 deletions(-)
>  create mode 100644 kernel-shark/examples/hello_kernel.c
>  create mode 100644 kernel-shark/src/stb_truetype.h

For patches 1 to 4:

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Cheers,

-- Slavi
