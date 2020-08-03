Return-Path: <SRS0=of8y=BN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC61C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  3 Aug 2020 00:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 920902076B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  3 Aug 2020 00:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgHCAZz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 2 Aug 2020 20:25:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgHCAZz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 2 Aug 2020 20:25:55 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86D282070A;
        Mon,  3 Aug 2020 00:25:54 +0000 (UTC)
Date:   Sun, 2 Aug 2020 20:25:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     linux-trace-devel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: Where is proper libtraceevent plugins tree?
Message-ID: <20200802202553.2819e393@oasis.local.home>
In-Reply-To: <20200802210904.iotublzj5bmp32sl@altlinux.org>
References: <20200802210904.iotublzj5bmp32sl@altlinux.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 3 Aug 2020 00:09:04 +0300
Vitaly Chikunov <vt@altlinux.org> wrote:

> Steven,
> 
> I am trying to rework trace-cmd and perf packages for ALT Linux. But, I
> found that trace-cmd 2.9 builds and installs /usr/lib64/traceevent/plugins
> and perf builds and installs /usr/lib64/traceevent/plugins (some plugins
> have same names, some different).
> 
> This would create bad files conflict in packaging system.
> 
> Both source trees seems to be recently updated:
>   linux/tools/lib/traceevent/plugins/ and
>   trace-cmd/lib/traceevent/plugins/
> 
> (trace-cmd 2.8 it installed these same plugins in /usr/lib64/trace-cmd/plugins).
> 
> How it's supposed to build and install (perf and trace-cmd) without conflicts?
> Where is true (lib?)traceevent source tree?

Actually, I'm working on making a stand alone libtraceevent, that's
going to live on kernel.org, that should be the main source. Perhaps
sometime this week I may have something working.

-- Steve
