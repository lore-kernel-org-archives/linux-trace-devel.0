Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D282C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A42A61185
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 13:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhD2NVF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 09:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231343AbhD2NVE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 09:21:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3936561158;
        Thu, 29 Apr 2021 13:20:07 +0000 (UTC)
Date:   Thu, 29 Apr 2021 09:20:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [POC PATCH 00/10] Add trace file compression
Message-ID: <20210429092005.5ae76a89@gandalf.local.home>
In-Reply-To: <CAPpZLN78vkjhiOOUx0gFjm+5NtPqGGtXJ3ECh_BP7V7rJYB0+w@mail.gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
        <20210428213506.7791db62@oasis.local.home>
        <CAPpZLN78vkjhiOOUx0gFjm+5NtPqGGtXJ3ECh_BP7V7rJYB0+w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Apr 2021 06:51:59 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> The order of applying the changes should be:
> 1. [PATCH v2] trace-cmd: Check if file version is supported
>   https://lore.kernel.org/linux-trace-devel/20210419093156.200099-1-tz.stoyanov@gmail.com/
> 2. [PATCH 0/6] Bump trace file version
>  https://lore.kernel.org/linux-trace-devel/20210422071718.483383-1-tz.stoyanov@gmail.com/
> 3. [POC PATCH 00/10] Add trace file compression
>  https://lore.kernel.org/linux-trace-devel/20210422073902.484953-1-tz.stoyanov@gmail.com/
> 
> I wrote these dependencies in the cover-letters.  BTW, I do not see

Yeah, I see that. But I was using patchwork to read the files and not the
email. But there is a way (not totally obvious) to read the cover letter
from patchwork. (just found it now!)

> (2) in patchwork, only in the mailing list.
> I'll send v2 of "Bump trace file version" including (1) in the patchset.

As I stated in the other email. After I make comments, and expect a newer
version, I'll set the older one to "changes needed", which makes it
disappear from the default view. You can still see it if you deselect
"Action Required".

-- Steve
