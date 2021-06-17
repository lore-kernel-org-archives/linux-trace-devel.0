Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604B8C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Jun 2021 19:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 461FA613E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Jun 2021 19:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhFQTD5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Jun 2021 15:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhFQTD5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Jun 2021 15:03:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B926760BBB;
        Thu, 17 Jun 2021 19:01:48 +0000 (UTC)
Date:   Thu, 17 Jun 2021 15:01:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Claire Jensen <cjense@google.com>
Cc:     Ian Rogers <irogers@google.com>, linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH 1/2] libtraceevent: Add eof checks.
Message-ID: <20210617150147.2ca5c990@gandalf.local.home>
In-Reply-To: <CAFPGG2iQK8XMv6Z1-KurgjOnYuk=m=uWNWJXj6OEb_SBQkokZA@mail.gmail.com>
References: <20210612014501.890593-1-irogers@google.com>
        <20210612014501.890593-2-irogers@google.com>
        <20210613193037.2ec40453@rorschach.local.home>
        <CAFPGG2iQK8XMv6Z1-KurgjOnYuk=m=uWNWJXj6OEb_SBQkokZA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 17 Jun 2021 13:56:49 -0500
Claire Jensen <cjense@google.com> wrote:

> Hi Steve,
> 
> This issue was found while fuzz testing. One of the test cases created an
> infinite loop because __read_token had reached end of file. Checking was
> added to all cases where this may occur.
> 
> Sorry for the late reply, I just got an issue surrounding email permissions
> resolved so I was unable to respond earlier.
> 
>

Can you resend the patch with this information in the change log.

Thanks!

-- Steve
