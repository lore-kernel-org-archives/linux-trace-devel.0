Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A6EC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 23:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC32610F7
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 23:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhDHX6A (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 19:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232426AbhDHX5x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 19:57:53 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA69E610F7;
        Thu,  8 Apr 2021 23:57:40 +0000 (UTC)
Date:   Thu, 8 Apr 2021 19:57:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] trace-cmd: Implement warning() in the library
Message-ID: <20210408195738.5910fd96@oasis.local.home>
In-Reply-To: <20210408042843.3112349-1-tz.stoyanov@gmail.com>
References: <20210408042843.3112349-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  8 Apr 2021 07:28:43 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The warning() function is used in a lot of places in the trace-cmd
> library, but there is no implementation. The function is implemented in
> the trace-cmd application. There is also a weak implementation in
> traceevent library, which is specific to that library.
> Implemented a new tracecmd_lib_warning(), specific to the trace-cmd
> library and replaced all warning() calls with the new function in the
> library. The new function is implemented as weak, so it can be
> overridden by the application.
> The tracecm_lib_warning() uses tep_vwarning() from libtraceevent for
> printing the warning, which is also a weak function and can be
> overridden by the application.

Hmm, this seems inconsistent with the other warnings. We have
tep_warning(), tracefs_warning, and here it's tracecmd_lib_warning(). I
wonder if it's better to drop the "_lib" part, and just call it,
tracecmd_warning()?

And if we do, we should rename tracecmd_lib_fatal() to just
tracecmd_fatal(). The "lib" just seems redundant.

-- Steve
