Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D33C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 17:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0907C610C8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Oct 2021 17:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhJRRpf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 13:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbhJRRpe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 13:45:34 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE5DC06161C;
        Mon, 18 Oct 2021 10:43:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 453EC199E;
        Mon, 18 Oct 2021 17:43:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 453EC199E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1634579001; bh=On+vvnIjlnwvwqpWycMcn1ROTsL6lLApirxr0LG35Hc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PCQbilsAPBGb9A8Bhld9iPvc9Y3nQkIEdCrRqkBLedLMTJ0Mye+BL1n7CQTI4LV4A
         +Oo1KC5qp/kW2elZwZQO3uf0th15q8T58ta/EKpKUcAb2z21/pOFkV0k+mEW75syoW
         0HMNjHHd8eucsEVKVmiWd7bRXlc+5me7ycXiMCbVJmNdNt35dhqPBtLGVsmPlrQCJa
         wWkCa1pFgOgFvIcO1pb4uKc2tzzLgDenhRXp/TfVMffrAFcnhT+j2uybjljEKcmxoH
         XrtuxH1cGK7PKl8rZlzl2dLKNuvkvF6wL5ON/PvAbfkKpzW/urkin0zIaU6BE6l2sF
         lBo7b8/w+Jopw==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 13/19] rtla: Add Documentation
In-Reply-To: <7e205854656f41afe9a35e6390d3e3cbd724706f.1634574261.git.bristot@kernel.org>
References: <cover.1634574261.git.bristot@kernel.org>
 <7e205854656f41afe9a35e6390d3e3cbd724706f.1634574261.git.bristot@kernel.org>
Date:   Mon, 18 Oct 2021 11:43:20 -0600
Message-ID: <877deaut3b.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Daniel Bristot de Oliveira <bristot@kernel.org> writes:

> Adds the basis for rtla documentation. It is based on libtracefs
> Documentation as suggested by Steven Rostedt. This patch also
> includes the rtla(1) man page.
>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Tom Zanussi <zanussi@kernel.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Clark Williams <williams@redhat.com>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Daniel Bristot de Oliveira <bristot@kernel.org>
> Cc: linux-rt-users@vger.kernel.org
> Cc: linux-trace-devel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
> ---
>  tools/tracing/rtla/Documentation/Makefile     | 223 ++++++++++++++++++
>  .../tracing/rtla/Documentation/asciidoc.conf  | 118 +++++++++
>  .../rtla/Documentation/manpage-base.xsl       |  35 +++
>  .../rtla/Documentation/manpage-normal.xsl     |  13 +
>  tools/tracing/rtla/Documentation/rtla.txt     |  56 +++++
>  tools/tracing/rtla/Documentation/utils.mk     | 144 +++++++++++
>  tools/tracing/rtla/Makefile                   |  20 +-
>  7 files changed, 604 insertions(+), 5 deletions(-)
>  create mode 100644 tools/tracing/rtla/Documentation/Makefile
>  create mode 100644 tools/tracing/rtla/Documentation/asciidoc.conf
>  create mode 100644 tools/tracing/rtla/Documentation/manpage-base.xsl
>  create mode 100644 tools/tracing/rtla/Documentation/manpage-normal.xsl
>  create mode 100644 tools/tracing/rtla/Documentation/rtla.txt
>  create mode 100644 tools/tracing/rtla/Documentation/utils.mk

So please forgive me for being obnoxious but I have to ask...do we
*really* need to add yet another markup language and docs build
infrastructure to the kernel?  I'm glad to see documentation, of course,
but I would be gladder if it weren't a silo completely separate from the
rest of the kernel docs.  Is there a reason why this couldn't have been
done with Sphinx?

Thanks,

jon
