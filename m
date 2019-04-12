Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9432C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 14:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0DF920850
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 14:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfDLOuS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 10:50:18 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34699 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfDLOuS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 10:50:18 -0400
Received: by mail-io1-f65.google.com with SMTP id n11so8699914ioh.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2019 07:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=026rI8MJzjyzfshoC5xMpEHOr17lhZO0kAd596HN0JU=;
        b=tChGGsBeUwcKPjHg2bjYHW3vFtwdOs3gCRTdgrDK4hHUh0RmHjjtc/hZk6d3TOzmy4
         a2o8tVv2ndKJtIcq0aZ2LTHfdB50QSDq7e1cG5/pFstxv26znWGZQwtrXV6c7p6U61p9
         vih5KeE/Tlz0vh0m9X0wFKxiNvjwRVGEjVh3zJwH/u8cW+pVHRcGtOLMQBkPaAjLUYOg
         lphPjqLixpyC8xkYF9Wle+W+l0GZFoZXNubF9Hl3bbLGdrpJCqT6GoEj85aIAdob199s
         pGLh0KWXyuHlX4qTmXpVQ1eDPjecwETWIDm9EqfTuXwXhZEp3a13yqxLc/F3T+xPItOz
         NFLQ==
X-Gm-Message-State: APjAAAUK1ejI719Jjcd9yvgofyxbf8usg1UFSNIUgBoi9kCAx4+IjG9L
        RGPRi3+rvkCpRwMXz85Mct9ONg==
X-Google-Smtp-Source: APXvYqyv2BCNc2VjGaU8dE/IZKjk/3fljRXH7+Vh1DyV8PM7OCK2n/MOC3EQaxNjQF+aSLnVrq98gg==
X-Received: by 2002:a6b:4e09:: with SMTP id c9mr30626144iob.251.1555080617394;
        Fri, 12 Apr 2019 07:50:17 -0700 (PDT)
Received: from google.com ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id 125sm4186012itx.21.2019.04.12.07.50.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Apr 2019 07:50:16 -0700 (PDT)
Date:   Fri, 12 Apr 2019 08:50:12 -0600
From:   Raul Rangel <rrangel@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     linux-trace-devel@vger.kernel.org, linux-mmc@vger.kernel.org,
        djkurtz@chromium.org, zwisler@chromium.org,
        Ludovic Barre <ludovic.barre@st.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Faiz Abbas <faiz_abbas@ti.com>, linux-kernel@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Liming Sun <lsun@mellanox.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ingo Molnar <mingo@redhat.com>,
        Prabu Thangamuthu <Prabu.T@synopsys.com>,
        Chunyan Zhang <chunyan.zhang@unisoc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v1 0/4] Add tracing for SDHCI register access
Message-ID: <20190412145012.GA101407@google.com>
References: <20190411220822.81845-1-rrangel@chromium.org>
 <7b77ebcb-b42b-2d14-f5f1-b37e07b88469@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b77ebcb-b42b-2d14-f5f1-b37e07b88469@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Apr 12, 2019 at 09:26:44AM +0300, Adrian Hunter wrote:
> On 12/04/19 1:08 AM, Raul E Rangel wrote:
> > I was debugging a SDHC hardware bug and got tired of having to
> > translate the register values by hand. This patch set makes it so all
> > SDHC register read and write operations can be traced and easily read by
> > a human.
> 
> While this might be useful for people unfamiliar with SDHCI, I am not sure
> it should be in the upstream kernel.
Can you help me understand your hesitation? Would you prefer removing the
pretty printing? Or would you prefer not having any trace events at all?

The xhci driver has a bunch of pretty print trace events that make it
invaluable when debugging.
https://github.com/torvalds/linux/blob/d7563ca5bfca53398e100eb74345c5d3ef06bf9d/drivers/usb/host/xhci.h#L2160

> Also, it doesn't seem ideal for every
> driver to add its own plumbing for such a feature.
What do you mean by every driver having to add it's own plumbing? Any
driver that uses sdhci_readX or sdhci_writeX get the functionality for
free.

Thanks,
Raul
