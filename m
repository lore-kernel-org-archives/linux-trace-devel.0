Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33CAC433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 22:27:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9FB464FF4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 22:27:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhBEW0l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 17:26:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232574AbhBEOXL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 09:23:11 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5B5464E4E;
        Fri,  5 Feb 2021 14:45:48 +0000 (UTC)
Date:   Fri, 5 Feb 2021 09:45:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, douglas.raillard@arm.com
Subject: Re: [PATCH] trace-cmd: Add flags to APIs for opening trace file
Message-ID: <20210205094547.05cc8e88@gandalf.local.home>
In-Reply-To: <20210205075638.1283393-1-tz.stoyanov@gmail.com>
References: <20210205075638.1283393-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  5 Feb 2021 09:56:38 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +enum tracecmd_open_flags {
> +	TRACECMD_FLAG_LOAD_NO_PLUGINS		= 1 << 0, /* Do not load plugins */
> +	TRACECMD_FLAG_LOAD_NO_SYSTEM_PLUGINS	= 1 << 1, /* Do not load system plugins */
> +};

Small nit. It's been standard practice to use "_FL_" instead of "_FLAG_",
just to shorten the length of the name. That's also done in the Linux
kernel.

I can update this, if I don't find any other issues.

Thanks!

-- Steve
