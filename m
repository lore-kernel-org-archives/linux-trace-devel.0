Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A701C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 01:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E48E161090
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 01:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhEGBlO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 May 2021 21:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhEGBlO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 May 2021 21:41:14 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC3A611AD;
        Fri,  7 May 2021 01:40:14 +0000 (UTC)
Date:   Thu, 6 May 2021 21:40:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dario Faggioli <dfaggioli@suse.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2] trace-cmd: Find PID of host-guest task from tracing
 vsock connection
Message-ID: <20210506214012.741cbbd7@oasis.local.home>
In-Reply-To: <f4c372f2138151299588b702567827a61954f775.camel@suse.com>
References: <20210506171400.7c00b731@gandalf.local.home>
        <f4c372f2138151299588b702567827a61954f775.camel@suse.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 07 May 2021 02:32:05 +0200
Dario Faggioli <dfaggioli@suse.com> wrote:

> What am I missing?

When you have 10 guests running, and you are only tracing one. How do
you know which guest that kvm exit was for?

-- Steve
