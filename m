Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2147C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 13:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FE5420842
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 13:24:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dI4AkWkG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfCENYc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 08:24:32 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:36968 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfCENYc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 08:24:32 -0500
Received: by mail-it1-f194.google.com with SMTP id z124so4404728itc.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Mar 2019 05:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HGiaVX7Ke5GuS57iWppdNzaD1PMkFIQByLr8KF8HNFs=;
        b=dI4AkWkGX2SiEsBZPyfvyyv5EWKNHzcT1Me1KrVMZF3nn/a2MovkM+cPkPDABgu+LY
         pZU9u9vZXbM6PViqItus2SlTB0daOx1GaEICXIFmaU3xsmGpeHN/rqg0T/2jTh51pKnv
         OeCtUZPCIoG+rxLwEhwYrQzkz+0JUGxPeyDd1GJ3oc0AQ/5p+3uaEtovWcbYRw9aJNYA
         ysbFqLmkG4o9vTU8bQ3FKtO3gr33VPwWNnwOzjJvVS1/fm55iJ5iBqO9ojh1l8tyaU/M
         xJdckl2RcGiIBvXefs0FUA8b4Nb+ztGRoSt76mqMcfGmiWcN0L2hdbV/w2od6JxBRZ16
         1EWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HGiaVX7Ke5GuS57iWppdNzaD1PMkFIQByLr8KF8HNFs=;
        b=bjvxiFjpGICdaWUkgnB7++LsBM/9rwBNyCPbyb2Cgb8jld1PfDIkccndnMgb0QjJMF
         /pEzI+3ii6xXhq3Yz9hiIh6yu0Un+tI5ckQa/5H+spRiflBx0tkulZbuc34kdKfoY8XF
         yeyUYpQ++4KJBLZzfzWlGPhr7zwIH5vHx0Pd5JEtL2Opml6lp3uQF/aSF9ngzgZhZ58c
         UYtDbI7BXymMorXog6ZnoDq8OndbYU2kqb9JgKtLuN0r5Qpd/9se7jVU4xM9WkTphEdi
         i0DmFKVz2l0YvIZy++XSG8z08UFzqXk2DaVUPmxtirzEki5tlDr1SKMx+qXDO1HEyAXR
         g+ag==
X-Gm-Message-State: APjAAAVrb1AtKSByOfHMMfC8mFatHO3qRvMY8I2WIYlq11BZ40LzrmSD
        47ETXdlQu66+hkVLy14FAAss2OrsYfCquD/M0Q==
X-Google-Smtp-Source: APXvYqwgeT8+56CIdd3kLFlxGcW1t3nf5kPuGOhY+7zse2O0uz4jLvhc6kCzdPuTJE6Un2+LvGcML86EtXxXKKsC2OQ=
X-Received: by 2002:a24:918c:: with SMTP id i134mr2508844ite.92.1551792271185;
 Tue, 05 Mar 2019 05:24:31 -0800 (PST)
MIME-Version: 1.0
References: <20181213142125.12149-1-tstoyanov@vmware.com>
In-Reply-To: <20181213142125.12149-1-tstoyanov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Tue, 5 Mar 2019 15:24:20 +0200
Message-ID: <CAE0o1NvxSaArhDO5W96tdy7AGDVOp8OTSFgDY_o6gP1Ga3tirw@mail.gmail.com>
Subject: Re: [PATCH 0/5] trace-cmd reset fixes
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Dec 13, 2018 at 4:22 PM Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:
>
> This patch series fixes "trace-cmd reset" command to
> restore default values of various ftrace configurations:
> tracng_on, trace_clock, set_event_pid and tracing_max_latency.
> It also fixes a segfault when the command is executed with
> "-a -d" options.
>
> Tzvetomir Stoyanov (5):
>   fix "trace-cmd reset" command to restore "tracng_on"
>   fix "trace-cmd reset -a -d" segfault
>   fix "trace-cmd reset" command to restore default clock
>   fix "trace-cmd reset" command to restore the default value of
>     set_event_pid
>   fix "trace-cmd reset" command to restore the default value of
>     tracing_max_latency
>
>  tracecmd/trace-record.c | 37 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 34 insertions(+), 3 deletions(-)

All 5 patches seems good to me

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Thank you,

-- Slavi
