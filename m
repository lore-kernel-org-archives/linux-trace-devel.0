Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59371C433C1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B98619C8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhC3Oxs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhC3Ox0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 10:53:26 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 918EA619CE;
        Tue, 30 Mar 2021 14:53:25 +0000 (UTC)
Date:   Tue, 30 Mar 2021 10:53:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: Re: [PATCH 10/13 v2] libtracefs: Pass in reset via flags to
 tracefs_function_filter()
Message-ID: <20210330105324.6d763312@gandalf.local.home>
In-Reply-To: <CAPpZLN764QK2eZy=D+w8BqC_BDAiYpas53Ef4w5ySBECHkZiFA@mail.gmail.com>
References: <20210330005123.151740983@goodmis.org>
        <20210330005248.694899644@goodmis.org>
        <CAPpZLN764QK2eZy=D+w8BqC_BDAiYpas53Ef4w5ySBECHkZiFA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 30 Mar 2021 17:29:35 +0300
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> It will be useful to allow calling the API with RESET flag set and no
> filters, just to reset the current filters without adding new:
>    tracefs_function_filter(NULL, NULL, NULL,TRACEFS_FL_RESET, NULL);
> could be a valid call to reset filters in the top trace instance.

Agreed. I planned on adding a patch to do just that.

-- Steve
