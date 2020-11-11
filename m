Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2F2C56201
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 01:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA13F206CA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 01:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725290AbgKLBbB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 11 Nov 2020 20:31:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgKKWnS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 17:43:18 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D569208FE;
        Wed, 11 Nov 2020 22:43:17 +0000 (UTC)
Date:   Wed, 11 Nov 2020 17:43:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] libtracefs: Change APIs to work with constant
 strings
Message-ID: <20201111174302.2d8d2c84@gandalf.local.home>
In-Reply-To: <20201110122249.911664-3-tz.stoyanov@gmail.com>
References: <20201110122249.911664-1-tz.stoyanov@gmail.com>
        <20201110122249.911664-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 10 Nov 2020 14:22:45 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Some tracefs library APIs retrieve trace instance parameters as srings.
> As these strings are not meant to be changed by the API callers, set
> them to be constant. These APIs are affected:

>  tracefs_instance_get_name()

Correct, because we pass back a pointer to a stored internal name.


>  tracefs_event_systems()
>  tracefs_system_events()
>  tracefs_tracers()
>  tracefs_list_free()

I don't think we need to make the above const char*. We are allocating them
and these strings don't point to anything internal. In other words, they
are OK to modify without causing issues.

I think we only need the tracefs_instance_get_name() to be const.

Previously, I thought we were passing back internal pointers, but if we are
making strings with strdup, then we don't need to use const char *.

-- Steve


