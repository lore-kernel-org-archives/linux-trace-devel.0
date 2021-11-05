Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD02C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 15:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FC0360E93
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 15:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhKEPPA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 11:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229680AbhKEPO7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 11:14:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A49D460E93;
        Fri,  5 Nov 2021 15:12:19 +0000 (UTC)
Date:   Fri, 5 Nov 2021 11:12:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 01/12] libtracefs: New APIs for dynamic events
Message-ID: <20211105111218.334d75c5@gandalf.local.home>
In-Reply-To: <20211105110839.37e2198e@gandalf.local.home>
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
        <20211105121624.398717-2-tz.stoyanov@gmail.com>
        <20211105110839.37e2198e@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 5 Nov 2021 11:08:39 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> We can not rely on enums being signed or unsigned, so the above needs to be:
> 
> 	if ((unsigned int)type >= TRACEFS_DYNEVENT_MAX)
> 
> > +		return NULL;  
> 
> 
> And we should also not undefined types (more than one type masked in), so

   "we should also not allow undefined types"

-- Steve

> we really need an unsigned int:

