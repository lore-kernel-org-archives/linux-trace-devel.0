Return-Path: <SRS0=xFsM=X4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88ACEC4360C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 00:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 626EE215EA
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 00:01:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfJCABQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 20:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727327AbfJCABQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 20:01:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CF9620659;
        Thu,  3 Oct 2019 00:01:15 +0000 (UTC)
Date:   Wed, 2 Oct 2019 20:01:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] trace-cmd: Load libtraceevent plugins from build
 folder, if exists.
Message-ID: <20191002200113.56e7df4b@gandalf.local.home>
In-Reply-To: <20191002114152.30048-4-tz.stoyanov@gmail.com>
References: <20191002114152.30048-1-tz.stoyanov@gmail.com>
        <20191002114152.30048-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  2 Oct 2019 14:41:50 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

Also there's a few typos (which I originally fixed before seeing the
issue of trace-cmd code in libtraceevent).

> When a development version of trace-cmd is built and run on the machine,
> by default it loads only installed plugins, from system drierctories.

 "directories"

> Thus, the development plugins will not be loaded. To simplify the development
> process, a new logic is added:
>   At plugins load time, check the location of trace-cmd application and look
>   for "plugins" directory around it. If found, load plugins from it. Those
>   pluigins will be loaded last, so in case of duplication the "development"

 "plugins"

>   plugins win.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
>

-- Steve
