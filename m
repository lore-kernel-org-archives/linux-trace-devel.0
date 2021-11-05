Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71707C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CA9861212
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhKEMgG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232105AbhKEMgG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 08:36:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C4461212;
        Fri,  5 Nov 2021 12:33:26 +0000 (UTC)
Date:   Fri, 5 Nov 2021 08:33:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v4 08/10] libtracefs: Use the internal dynamic events
 API when creating synthetic events
Message-ID: <20211105083325.78b1de24@gandalf.local.home>
In-Reply-To: <CAPpZLN5bSdCKOvAMSefAaj0osq60qgcyRE7npMS6jPOcYoEAYg@mail.gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
        <20211104111047.302660-9-tz.stoyanov@gmail.com>
        <20211104131351.1110c122@gandalf.local.home>
        <CAPpZLN5bSdCKOvAMSefAaj0osq60qgcyRE7npMS6jPOcYoEAYg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 5 Nov 2021 14:15:05 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> I looked and tested more this code today, but as I understood the
> instance is mandatory in histograms creation and should not be removed
> from this API. That API appends the histogram config in the event's
> trigger files, which is for specific instances. The histogram is
> accumulated only in the context of that instance. I'm going to send
> next version of the patch set, but without changes to this API.

The histogram code is internal to the synthetic events. That's because it
uses the histogram to save the data across the start to end event to create
the synthetic event. The histogram is an implementation detail of the
synthetic event and should not be exposed via the API. And that is
*exactly* why instances should not be exposed to the synthetic event!

In fact, I don't wan the user to have control over the instances because
they are likely to screw it up if they don't know what they are doing.
That's why I suggested to convert the current API into a raw event, because
to use instances, you had better know what you are doing, otherwise you can
easily screw it up.

The histograms used by synthetic events are "special" and if not done
properly, will not do what people expect.

If you don't want to make this change, I will.

-- Steve
