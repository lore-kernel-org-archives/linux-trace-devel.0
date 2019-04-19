Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=FSL_HELO_FAKE,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D47C282DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 710B0204FD
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfDSSkV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:40:21 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:35082 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbfDSSkU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:40:20 -0400
Received: by mail-it1-f195.google.com with SMTP id w15so9510315itc.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 11:40:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h89jbsyKZFLdHfaOBCwQAn52VqoU6F6H0npqSz7mIhI=;
        b=pjAjXI/iKAApcS7DgzyBvJXCVVt/o9PHCqKXNfd6c3a2bvKCqOd2sLea/T4xJPyZ8l
         Zp6gqUqj5DsLUEJ1eiTu8XotF+pFzAd5VftAMnTeHJbOTBgGqGz/g8l1wBOQ5CNMoTk2
         iWtPJZS0Bs/snbLEKWw7Zcf5u9qVmPiVVMZZ8/E1dYC450nSt/87kjNfOgFs262yp/yZ
         We4Jd/ntwC8T6zv2H3S0YikutrFvH+lvijJkofR/ulj2WtdLrXUpDl+OnRi0P79jkfsU
         jo5NFJgh8CzPMzJuV7lxRqpLECroqL7O326ZlZMqUNJFLwvXJN8THiP1ZrlX/Qh6VAil
         axxA==
X-Gm-Message-State: APjAAAUUK53d7r2yp7wjV5zQhMSQOB8dJvxf9gnw+g1SGY9g/8bvtz+A
        8AdvnzgG4SoBZAFOQGWPCgPanhFEQQ2RYiL6
X-Google-Smtp-Source: APXvYqyxB9ATaErq8VI0gfSGCwxDxUYLFmhbPWtElP+cGKDE6m/xtTGqQxWO0jBJTgf1/KcGc0Tpaw==
X-Received: by 2002:a24:35d4:: with SMTP id k203mr3943021ita.89.1555699219243;
        Fri, 19 Apr 2019 11:40:19 -0700 (PDT)
Received: from google.com ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id t67sm2708682ita.35.2019.04.19.11.40.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Apr 2019 11:40:18 -0700 (PDT)
Date:   Fri, 19 Apr 2019 12:40:13 -0600
From:   Raul Rangel <rrangel@chromium.org>
To:     Steven Rostedt <rostedt@goodmis.org>
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
        Ulf Hansson <ulf.hansson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v1 0/4] Add tracing for SDHCI register access
Message-ID: <20190419184013.GA145226@google.com>
References: <20190411220822.81845-1-rrangel@chromium.org>
 <7b77ebcb-b42b-2d14-f5f1-b37e07b88469@intel.com>
 <20190412145012.GA101407@google.com>
 <bd3a1df1-5ac4-e23c-35a3-78361a5c356e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd3a1df1-5ac4-e23c-35a3-78361a5c356e@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 18, 2019 at 09:24:16AM +0300, Adrian Hunter wrote:
> On 12/04/19 5:50 PM, Raul Rangel wrote:
> > On Fri, Apr 12, 2019 at 09:26:44AM +0300, Adrian Hunter wrote:
> >> On 12/04/19 1:08 AM, Raul E Rangel wrote:
> >>> I was debugging a SDHC hardware bug and got tired of having to
> >>> translate the register values by hand. This patch set makes it so all
> >>> SDHC register read and write operations can be traced and easily read by
> >>> a human.
> >>
> >> While this might be useful for people unfamiliar with SDHCI, I am not sure
> >> it should be in the upstream kernel.
> > Can you help me understand your hesitation? Would you prefer removing the
> > pretty printing? Or would you prefer not having any trace events at all?
> 
> It is just cost/benefit.  I am not sure the cost of maintaining it is worth
> the benefit of having it upstream.
> 
Steven,
Since it seems this series won't be accepted upstream, would you still be
open to accepting patches for trace_print_register? I can work on adding
support to lib traceevent.

Thanks,
Raul
> > The xhci driver has a bunch of pretty print trace events that make it
> > invaluable when debugging.
> > https://github.com/torvalds/linux/blob/d7563ca5bfca53398e100eb74345c5d3ef06bf9d/drivers/usb/host/xhci.h#L2160
> > 
> >> Also, it doesn't seem ideal for every
> >> driver to add its own plumbing for such a feature.
> > What do you mean by every driver having to add it's own plumbing? Any
> > driver that uses sdhci_readX or sdhci_writeX get the functionality for
> > free.
> 
> I/O memory mappings are recorded for devices. e.g. /proc/iomem so it could
> be possible to add tracing for all I/O memory accesses via readx/writex etc,
> configurable / filterable by device id.
