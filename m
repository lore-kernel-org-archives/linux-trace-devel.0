Return-Path: <SRS0=SJyJ=7R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF73C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jun 2020 15:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D519207D8
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Jun 2020 15:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729293AbgFDPu3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Jun 2020 11:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729216AbgFDPu3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Jun 2020 11:50:29 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F1A20738;
        Thu,  4 Jun 2020 15:50:29 +0000 (UTC)
Date:   Thu, 4 Jun 2020 11:50:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] trace-cmd: Man page for "set" subcommand
Message-ID: <20200604115027.4a6217e7@gandalf.local.home>
In-Reply-To: <20200603121506.49992-4-tz.stoyanov@gmail.com>
References: <20200603121506.49992-1-tz.stoyanov@gmail.com>
        <20200603121506.49992-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  3 Jun 2020 15:15:04 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +AUTHOR
> +------
> +Written by Steven Rostedt, <rostedt@goodmis.org>

You can add your name as well. ;-)

> +
> +RESOURCES
> +---------
> +git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> +
> +COPYING
> +-------
> +Copyright \(C) 2010 Red Hat, Inc. Free use of this software is granted under
> +the terms of the GNU Public License (GPL).
> +

Remove the last extra line.

Thanks!

-- Steve
