Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7AEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 02:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD06610A0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Oct 2021 02:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhJ2C6W (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 22:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:43532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhJ2C6W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 22:58:22 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46E27610A0;
        Fri, 29 Oct 2021 02:55:54 +0000 (UTC)
Date:   Thu, 28 Oct 2021 22:55:52 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 03/12] libtracefs: New kprobes APIs
Message-ID: <20211028225552.15bb2ac3@rorschach.local.home>
In-Reply-To: <20211028120907.101847-4-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
        <20211028120907.101847-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 28 Oct 2021 15:08:58 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static struct tracefs_dynevent *
> +kprobe_alloc(enum trace_dynevent_type type, const char *system, const char *event,
> +	     const char *addr, const char *format)
> +{
> +	struct tracefs_dynevent *kp;
> +	const char *sys = system;
> +	const char *ename = event;
> +	char *tmp;
> +
> +	if (!addr || !format) {
> +		errno = EBADMSG;
> +		return NULL;
> +	}
> +	if (!sys)
> +		sys = KPROBE_DEFAULT_GROUP;
> +
> +	if (!event) {
> +		ename = strdup(addr);
> +		if (!ename)
> +			return NULL;
> +		tmp = strchr(ename, ':');
> +		if (tmp)
> +			*tmp = '\0';
> +	}
> +
> +	kp = dynevent_alloc(type, sys, ename, addr, format);
> +	if (!event)
> +		free((char *)ename);
> +	if (!kp)
> +		return NULL;
> +	return kp;

If !kp is true, then return kp is the same as return NULL;

Nuke the "if (!kp)" code.

> +}
> +
> +

-- Steve
