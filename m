Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24ADBC433E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Jan 2021 18:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF84364E1C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Jan 2021 18:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhA1SDk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:03:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231149AbhA1SAO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Jan 2021 13:00:14 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C22764E18;
        Thu, 28 Jan 2021 17:59:33 +0000 (UTC)
Date:   Thu, 28 Jan 2021 12:59:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: Re: libtracefs: New APIS to write/erase 'set_ftrace_filter' and
 'set_ftrace_notrace' Inbox
Message-ID: <20210128125931.300d5c8d@gandalf.local.home>
In-Reply-To: <CAK7tX=akBmqBDUZ1k6dDd9aZ=xoTwppBiEa21wQomME-vQzv7g@mail.gmail.com>
References: <CAK7tX=akBmqBDUZ1k6dDd9aZ=xoTwppBiEa21wQomME-vQzv7g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 28 Jan 2021 11:20:38 +0530
Sameeruddin Shaik <sameeruddin.shaik8@gmail.com> wrote:

> hi,
> I am working on the below API's
> ----------------------------------------------------
> 
> Add an API to set filtering of functions:
> 
> int tracefs_function_filter(struct tracefs_instance *instance, const
> char *filter);
> 
> Which would write into the set_ftrace_filter file for the instance.
> 
> Also have a:
> 
> int tracefs_function_notrace(struct tracefs_instance *instance, const
> char *filter);
> 
> That would write into the set_ftrace_notrace file for the instance.
> 
> Have a:
> 
> int tracefs_function_filter_clear(struct tracefs_instance *instance);
> 
> That clears the set_ftrace_filter file.
> 
> and a:
> 
> int tracefs_function_notrace_clear(struct tracefs_instance *instance);
> 
> That clears the set_ftrace_notrace file.
> ----------------------------------------------------------
> 
> Bugzilla link: https://bugzilla.kernel.org/show_bug.cgi?id=210643
> 
> if there is anyone already working on these API's please let me know.
> 
>

I don't believe anyone is currently working on this APIs. We're happy to
see patches for them coming from you.

-- Steve
