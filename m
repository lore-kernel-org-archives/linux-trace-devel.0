Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F77C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 03:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914156103B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 03:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhJ2DEB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 23:04:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhJ2DEB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 23:04:01 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2F8160F9B;
        Fri, 29 Oct 2021 03:01:32 +0000 (UTC)
Date:   Thu, 28 Oct 2021 23:01:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 05/12] libtracefs: Reimplement tracefs_kprobes_get API
Message-ID: <20211028230131.5a046292@rorschach.local.home>
In-Reply-To: <20211028120907.101847-6-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
        <20211028120907.101847-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 28 Oct 2021 15:09:00 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to unify the code and reuse the internal helpers for dynamic
> events helpers, the tracefs_kprobes_get() API is reimplemented using
> the new dynamic events APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs.h     |   2 +-
>  src/tracefs-kprobes.c | 127 +++++++++++-------------------------------
>  2 files changed, 33 insertions(+), 96 deletions(-)
> 
> diff --git a/include/tracefs.h b/include/tracefs.h
> index c7b9179..d4ac8fb 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -259,7 +259,7 @@ int tracefs_kprobe_raw(const char *system, const char *event,
>  		       const char *addr, const char *format);
>  int tracefs_kretprobe_raw(const char *system, const char *event,
>  			  const char *addr, const char *format);
> -char **tracefs_kprobes_get(enum tracefs_kprobe_type type);
> +int tracefs_kprobes_get(enum tracefs_kprobe_type type, struct tracefs_dynevent ***kprobes);

Like I mentioned for the other patches. This should return the array,
and not be passing in an object to allocate.

General rule is, if you need to have a parameter with three
dereferences (***) you're doing it wrong. ;-)

>  enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
>  					     char **type, char **addr, char **format);
>  
> diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c


-- Steve
