Return-Path: <SRS0=sU+T=WE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BF4C0650F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 22:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9294216C8
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Aug 2019 22:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404339AbfHHWD7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Aug 2019 18:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404325AbfHHWD7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Aug 2019 18:03:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 094CC2166E;
        Thu,  8 Aug 2019 22:03:57 +0000 (UTC)
Date:   Thu, 8 Aug 2019 18:03:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     tz.stoyanov@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4] trace-cmd: Save the tracee memory map into the
 trace.dat file.
Message-ID: <20190808180356.31644e0d@gandalf.local.home>
In-Reply-To: <20190703115134.16038-1-tz.stoyanov@gmail.com>
References: <20190703115134.16038-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  3 Jul 2019 14:51:34 +0300
tz.stoyanov@gmail.com wrote:

> From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
> 
> A new trace-cmd record option is added: "--mmap". When it is set with
> combination of -F or -P options, the memory map of the traced applications
> is stored in the trace.dat file. A new API tracecmd_search_task_mmap()
> can be used to look up into stored memory maps. The map is retrieved from
> /proc/<pid>/maps file.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>

Hi Ceco,

Just a reminder. Let's rename --mmap to --proc-map or something, as
mmap could confuse users that it is using the mmap() system call.

 man 2 mmap

Thanks!

-- Steve
