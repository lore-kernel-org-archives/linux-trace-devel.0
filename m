Return-Path: <SRS0=a4XR=YP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419D2CA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 17:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25C5C20700
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Oct 2019 17:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbfJVReW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 13:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbfJVReV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 13:34:21 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3CA420700;
        Tue, 22 Oct 2019 17:34:20 +0000 (UTC)
Date:   Tue, 22 Oct 2019 13:34:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v12 3/9] trace-cmd: Fix tracecmd_read_page_record() to
 read more than one event
Message-ID: <20191022133418.7f751772@gandalf.local.home>
In-Reply-To: <20190828085746.26231-4-tz.stoyanov@gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
        <20190828085746.26231-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 28 Aug 2019 11:57:40 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> 
> The kbuffer_next_event() will return the next event on the sub buffer.
> If we pass in the last_record to tracecmd_read_page_record(), it
> initializes the sub buffer, and by calling kbuffer_next_event()
> (instead of kbuffer_read_event()), the second event on the sub buffer
> is returned. This causes the match of the last_record not to match if
> the last_record happens to be the first event on the sub buffer.

Bah, I see why this was done incorrectly. Good catch.

This should be added independent of this series.

Thanks!

-- Steve
