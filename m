Return-Path: <SRS0=o1/+=W2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5EBDC3A59B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Aug 2019 15:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 812042073F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Aug 2019 15:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfH3PXP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbfH3PXP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 11:23:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D0E22073F;
        Fri, 30 Aug 2019 15:23:14 +0000 (UTC)
Date:   Fri, 30 Aug 2019 11:23:12 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] trace-cmd: Move libtraceevent plugins in its own
 directory.
Message-ID: <20190830112312.2f88adc5@gandalf.local.home>
In-Reply-To: <20190802110101.14759-5-tz.stoyanov@gmail.com>
References: <20190802110101.14759-1-tz.stoyanov@gmail.com>
        <20190802110101.14759-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  2 Aug 2019 14:00:59 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> All existing plugins are moved from plugins/ to plugins/traceevent/
> directory, as all of them (except plugin_python) are designed to be
> used with the traceevent library. This change paves the way for
> implementing trace-cmd specific plugins.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
>

To make this more consistent with the kernel, let's move it to:

 lib/traceevent/plugins

and I would suggest making a patch for the kernel to move all the
plugin code to:

 tools/lib/traceevent/plugins

We could then have the trace-cmd plugins be in:

 lib/trace-cmd/plugins

That way we know what goes with what library.

-- Steve
