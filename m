Return-Path: <SRS0=Pjg+=SU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF67C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 06:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6538214DA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 06:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388040AbfDRGZk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 02:25:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:16089 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbfDRGZk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 02:25:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 23:25:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,364,1549958400"; 
   d="scan'208";a="151841923"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.198]) ([10.237.72.198])
  by orsmga002.jf.intel.com with ESMTP; 17 Apr 2019 23:25:34 -0700
Subject: Re: [PATCH v1 0/4] Add tracing for SDHCI register access
To:     Raul Rangel <rrangel@chromium.org>
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
References: <20190411220822.81845-1-rrangel@chromium.org>
 <7b77ebcb-b42b-2d14-f5f1-b37e07b88469@intel.com>
 <20190412145012.GA101407@google.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <bd3a1df1-5ac4-e23c-35a3-78361a5c356e@intel.com>
Date:   Thu, 18 Apr 2019 09:24:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190412145012.GA101407@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 12/04/19 5:50 PM, Raul Rangel wrote:
> On Fri, Apr 12, 2019 at 09:26:44AM +0300, Adrian Hunter wrote:
>> On 12/04/19 1:08 AM, Raul E Rangel wrote:
>>> I was debugging a SDHC hardware bug and got tired of having to
>>> translate the register values by hand. This patch set makes it so all
>>> SDHC register read and write operations can be traced and easily read by
>>> a human.
>>
>> While this might be useful for people unfamiliar with SDHCI, I am not sure
>> it should be in the upstream kernel.
> Can you help me understand your hesitation? Would you prefer removing the
> pretty printing? Or would you prefer not having any trace events at all?

It is just cost/benefit.  I am not sure the cost of maintaining it is worth
the benefit of having it upstream.

> The xhci driver has a bunch of pretty print trace events that make it
> invaluable when debugging.
> https://github.com/torvalds/linux/blob/d7563ca5bfca53398e100eb74345c5d3ef06bf9d/drivers/usb/host/xhci.h#L2160
> 
>> Also, it doesn't seem ideal for every
>> driver to add its own plumbing for such a feature.
> What do you mean by every driver having to add it's own plumbing? Any
> driver that uses sdhci_readX or sdhci_writeX get the functionality for
> free.

I/O memory mappings are recorded for devices. e.g. /proc/iomem so it could
be possible to add tracing for all I/O memory accesses via readx/writex etc,
configurable / filterable by device id.
