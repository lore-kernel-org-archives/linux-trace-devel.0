Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE76EC48BDF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 13 Jun 2021 23:29:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C87D5611CA
	for <linux-trace-devel@archiver.kernel.org>; Sun, 13 Jun 2021 23:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhFMXbb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 13 Jun 2021 19:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232156AbhFMXba (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 13 Jun 2021 19:31:30 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2864761159;
        Sun, 13 Jun 2021 23:29:28 +0000 (UTC)
Date:   Sun, 13 Jun 2021 19:29:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Claire Jensen <cjense@google.com>
Subject: Re: [PATCH 2/2] libtraceevent: Changed angled brackets to double
 quotes.
Message-ID: <20210613192926.6cb6b983@rorschach.local.home>
In-Reply-To: <CAP-5=fX1riLr6y8KapEhmxk3BW1Xq9kV_zMywoQ+B8Dgs6fxeg@mail.gmail.com>
References: <20210612014501.890593-1-irogers@google.com>
        <20210612014501.890593-3-irogers@google.com>
        <20210612190049.7e09d8c6@rorschach.local.home>
        <CAP-5=fX1riLr6y8KapEhmxk3BW1Xq9kV_zMywoQ+B8Dgs6fxeg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 13 Jun 2021 14:31:42 -0700
Ian Rogers <irogers@google.com> wrote:


> Would it be more conventional in this situation to use quotes within
> the library and angles outside? This change is within the library and
> not with code trying to link against it.

Does it matter? If not, what's the purpose of changing it?

Note, the change log is empty, and is where rationale for the change is
suppose to be added.

-- Steve
