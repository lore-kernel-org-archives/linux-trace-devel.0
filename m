Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAD0C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Feb 2021 14:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1634F64DDD
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Feb 2021 14:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbhBDOc0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Feb 2021 09:32:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236749AbhBDOb6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Feb 2021 09:31:58 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF22E64F42;
        Thu,  4 Feb 2021 14:31:11 +0000 (UTC)
Date:   Thu, 4 Feb 2021 09:31:10 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Move "load_plugins" out of the opening code
Message-ID: <20210204093110.0b2780ba@gandalf.local.home>
In-Reply-To: <20210204091727.5ae308dc@gandalf.local.home>
References: <20210119095939.6f307c4d@gandalf.local.home>
        <CAPpZLN4D4zDfErUVpXfdaY3iciV0k+nW+uJsBeu79XtaVjxatw@mail.gmail.com>
        <20210204091727.5ae308dc@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 4 Feb 2021 09:17:27 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Note, because libtracecmd has not been released yet, we still have the
> luxury of breaking its APIs ;-)

Also, the reason I have not yet released libtracecmd, is because I want to
change the current APIs. Even if it breaks KernelShark.

-- Steve
