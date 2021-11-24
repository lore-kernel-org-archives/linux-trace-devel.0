Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF5FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 19:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244225AbhKXTgJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 14:36:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:59500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235882AbhKXTgI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 14:36:08 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7788060F58;
        Wed, 24 Nov 2021 19:32:58 +0000 (UTC)
Date:   Wed, 24 Nov 2021 14:32:56 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 12/25] trace-cmd library: Do not write CPUs with
 empty trace data
Message-ID: <20211124143256.7d46afc0@gandalf.local.home>
In-Reply-To: <20211124143000.1a21c1a1@gandalf.local.home>
References: <20211111151112.86751-1-tz.stoyanov@gmail.com>
        <20211111151112.86751-3-tz.stoyanov@gmail.com>
        <20211124143000.1a21c1a1@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 24 Nov 2021 14:30:00 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Will both trace-cmd record and report still report that a CPU had no data?
> Because that is useful information.

That is, we must differentiate between when a CPU was being recorded but
produced no information, and when the user used a CPU mask to record.

If CPU 1 has no data, it should report it did in both the record and the
report commands of trace-cmd, unless, the user had masked out CPU 1, where
it was not part of the record.

That information needs to be saved somewhere. If the user did mask out
CPUs, that could be saved in an option. And then when a CPU does not have
data, if it was masked out, nothing is to be reported, otherwise it is. We
also have to know how many CPUs were recorded, such that if he last CPU
doesn't have data, we report that if it was recorded.

-- Steve
