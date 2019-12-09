Return-Path: <SRS0=BlfF=Z7=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD51C43603
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Dec 2019 19:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DC1B20637
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Dec 2019 19:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfLITdC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 14:33:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbfLITdB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 14:33:01 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 020B720637;
        Mon,  9 Dec 2019 19:33:00 +0000 (UTC)
Date:   Mon, 9 Dec 2019 14:32:59 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 15/18] trace-cmd: Refactor few trace-cmd internal
 functions.
Message-ID: <20191209143259.62e4cf3d@gandalf.local.home>
In-Reply-To: <20191203103522.482684-16-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-16-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  3 Dec 2019 12:35:19 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to reuse code inside trace-cmd application context,
> few functions are made non static:
> 	int make_vsock(unsigned int port);
> 	int get_vsock_port(int sd, unsigned int *port);
> 	int open_vsock(unsigned int cid, unsigned int port);
> 	char *get_guest_file(const char *file, const char *guest);

We should probably rename them to have a "trace_" prefix. This way we
know what functions are not static, but "trace_" means it's local,
where as "tracecmd_" means its exported.

-- Steve

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
