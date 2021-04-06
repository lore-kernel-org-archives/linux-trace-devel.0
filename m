Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA21C433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC35D613C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 12:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240599AbhDFMjX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238946AbhDFMjX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 08:39:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C65A61380;
        Tue,  6 Apr 2021 12:39:15 +0000 (UTC)
Date:   Tue, 6 Apr 2021 08:39:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <y.karadz@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: Re: [PATCH] trace-cmd: Add CODING_STYLE and CONTRIBUTE documents
Message-ID: <20210406083913.7f7f6d0a@gandalf.local.home>
In-Reply-To: <7ef527d0-b17e-6292-d8f5-dc730a1751aa@gmail.com>
References: <20210405151959.1d6901b2@gandalf.local.home>
        <7ef527d0-b17e-6292-d8f5-dc730a1751aa@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 6 Apr 2021 11:18:07 +0300
Yordan Karadzhov <y.karadz@gmail.com> wrote:

> Maybe we should include an explanation what to do in cases like this:
> 
>          struct instance_wrapper *iw, **iw_ptr;
> 
> 
> Let's say, the two are closely related in the code of the function, 
> however technically speaking the types are different. Is it OK to have 
> both on the same line?

That's one of the cases where I would say it's an exception and not a rule.
Remember this document is a guide not a requirement as I state at the end.
I wouldn't include the above, as it's not common, and it really is a case
by case situation on how to do that, so it is out of scope for this
document.

-- Steve
