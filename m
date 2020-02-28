Return-Path: <SRS0=HcHG=4Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9577CC3F2D2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Feb 2020 23:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 730CF246B6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Feb 2020 23:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgB1Xmf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Feb 2020 18:42:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbgB1Xmf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 18:42:35 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 364E0246B5;
        Fri, 28 Feb 2020 23:42:34 +0000 (UTC)
Date:   Fri, 28 Feb 2020 18:42:32 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v20 02/15] trace-cmd: Add new library API for local CPU
 count
Message-ID: <20200228184232.062c0f8d@gandalf.local.home>
In-Reply-To: <20200227142001.61577-3-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
        <20200227142001.61577-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 27 Feb 2020 16:19:48 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to reuse the code, the function detecting the
> number of local CPU is moved from trace-cmd application to
> libtracecmd. The following new library API is introduced:
> 	int tracecmd_count_cpus(void);
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
>

FYI,

I pulled in patch 1-2 of this series, so you don't need to resend those two.

I'm still looking at patch 14, but the rest look fine (besides what I
commented on). If you want to send the series again, please do. Just start
with patch 3 of this series and base it off of the latest master.

-- Steve
