Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943D3C282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F13220645
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 19:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfDSTIY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 15:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729546AbfDSTIV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 15:08:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C84832064A;
        Fri, 19 Apr 2019 19:08:19 +0000 (UTC)
Date:   Fri, 19 Apr 2019 15:08:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Raul Rangel <rrangel@chromium.org>
Cc:     linux-trace-devel@vger.kernel.org, linux-mmc@vger.kernel.org,
        djkurtz@chromium.org, zwisler@chromium.org,
        Ludovic Barre <ludovic.barre@st.com>,
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
Message-ID: <20190419150818.1f8ec963@gandalf.local.home>
In-Reply-To: <20190419184013.GA145226@google.com>
References: <20190411220822.81845-1-rrangel@chromium.org>
        <7b77ebcb-b42b-2d14-f5f1-b37e07b88469@intel.com>
        <20190412145012.GA101407@google.com>
        <bd3a1df1-5ac4-e23c-35a3-78361a5c356e@intel.com>
        <20190419184013.GA145226@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 19 Apr 2019 12:40:13 -0600
Raul Rangel <rrangel@chromium.org> wrote:

> Steven,
> Since it seems this series won't be accepted upstream, would you still be
> open to accepting patches for trace_print_register? I can work on adding
> support to lib traceevent.

It would require having a user in the kernel code.

If you are going to do something out of tree, simply make a helper
function inside your trace event, and then write a plugin for it if you
want to use it for libtraceevent. It allows for custom plugins.

-- Steve
