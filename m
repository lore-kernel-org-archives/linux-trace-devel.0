Return-Path: <SRS0=wRMB=UQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A92BC31E57
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:18:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E96F52084B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Jun 2019 13:18:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGD3FU78"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFQNSu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 09:18:50 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37388 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFQNSu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 09:18:50 -0400
Received: by mail-oi1-f194.google.com with SMTP id t76so6973094oih.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jun 2019 06:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rsOsUiJu1/blVLFEGgHGtamYHGYiUk1LwHNFrxc2h68=;
        b=jGD3FU78v1VEVO0wEenfO9r7h8i/J4NEzKX/rZRSiicnVMXtybeiPa5kmNgj6qr9n+
         XskaGm87aRdthzSkpGsmFTiQXYg49BWboIweAn6oC8FqbVdq/Cpvd7YqSErMGN3EeoH/
         zMkezKJpUV4Byu8PbawRLOIHrQINbNElevR/FeEgxiLRRztbAuJyIOIenVeXk69I+UPg
         CcS9aQUht5X2awwNFiE+DqIO9NNtkWU4SVs0f1OYBQkD1Rf8fg1eKcRbhWQdfgHM1Jy8
         mC4giOUr0U9A5TrWnxXcCI5r+sgw9gR9BZ6YhQLb9R4wtZ8nEmNv+2BAKfiIl1gIorzh
         PMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rsOsUiJu1/blVLFEGgHGtamYHGYiUk1LwHNFrxc2h68=;
        b=AHzXJ2VbtLRZtH1aQsJ1cE6Z87OWmEP2B9tRbFgvEzauxy9Q5SJ4w0Ab7fKoLFbG1O
         C/j/LjSoSs/rgzWJLvHPVSQVjsqWP70ZlsZ9CEnU/gSi5zJUmhY+2YV0OhVxY1ZHezpM
         v1Gp5LJGkVBRmuk480MtfcQ9vkeh8kPbYgukIXIYOG83tH5XRbQBs8//b/5iF5d2thTQ
         j0JpROV+1/PPyqYhlFjdsu0WIULD73qBqgxlTC5BMC4wGFe1LLUN6/wrTWQ/sxfhZT6F
         BdpaIuIrwfKRxEwMoRHu+8ItzIF18EQcEKmTUT+kyKKt7Bfj4jcrI1NknfMeFYpInWKE
         L3FQ==
X-Gm-Message-State: APjAAAVDLWFmbIGMf1VI0U5kS7m3o2oKcMiXBfnQNuIckXshqCk7w6y6
        3FAC0hmSAt24JGNizZXE8RrzT3Q3M6BdXG1Bji0=
X-Google-Smtp-Source: APXvYqymOkoId/p+vSCbZ6+g1NRNA0gyI10OCMkbZ+5gVgNUkrsXe3s6XYzeamOoVri7wn/qOcB81AaO9gxptDQnJKw=
X-Received: by 2002:aca:48c2:: with SMTP id v185mr10707456oia.132.1560777529897;
 Mon, 17 Jun 2019 06:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190617115218.6279-1-tz.stoyanov@gmail.com> <20190617115218.6279-2-tz.stoyanov@gmail.com>
 <20190617090603.495e4333@gandalf.local.home>
In-Reply-To: <20190617090603.495e4333@gandalf.local.home>
From:   Ceco <tz.stoyanov@gmail.com>
Date:   Mon, 17 Jun 2019 16:18:38 +0300
Message-ID: <CAPpZLN4ZwsZYCzjSGkyuu8r0ih-=7K8qG+TtQA33OxTfqbFjhA@mail.gmail.com>
Subject: Re: [PATCH 1/2] trace-cmd: Implemented new API tracecmd_add_option_v()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven

On Mon, Jun 17, 2019 at 4:06 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
...
>
> Hmm, I think this is a bit overkill. I don't really see anything using
> more than one or two data vectors. All I see would be at most a "count"
> followed by a list of data, which is what I think you are using this
> for.
>
> I rather wait to implement something like this when there's more of a
> need for it. I don't believe this change really requires it.
>
> -- Steve
>

Actually, this patch is from the patch set (N 7):
 "trace-cmd: Timetamps sync between host and guest machines, relying
on vsock events. "
and I took it as-is. In timesync changes tracecmd_add_option_v() is
used in similar way.
That explains the tracecmd_append_options() API, which is used there.


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
