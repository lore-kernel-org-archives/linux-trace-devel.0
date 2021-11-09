Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB37C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 21:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C04761177
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Nov 2021 21:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhKIVmk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Nov 2021 16:42:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243830AbhKIVmh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 16:42:37 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85D086112D;
        Tue,  9 Nov 2021 21:39:48 +0000 (UTC)
Date:   Tue, 9 Nov 2021 16:39:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Beau Belgrave <beaub@linux.microsoft.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 02/10] user_events: Add minimal support for
 trace_event into ftrace
Message-ID: <20211109163946.55bb6e8b@gandalf.local.home>
In-Reply-To: <20211109212756.GA1741@kbox>
References: <20211104170433.2206-3-beaub@linux.microsoft.com>
        <20211107233115.1f77e93c4bdf3ff649be99c1@kernel.org>
        <20211108171336.GA1690@kbox>
        <20211108131639.33a4f186@gandalf.local.home>
        <20211108202527.GA1862@kbox>
        <20211109115634.5fb6d984d7b4e701c740d5f3@kernel.org>
        <20211109190844.GA1529@kbox>
        <20211109142506.3c280469@gandalf.local.home>
        <20211109201432.GA1650@kbox>
        <20211109154520.11995e75@gandalf.local.home>
        <20211109212756.GA1741@kbox>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 9 Nov 2021 13:27:56 -0800
Beau Belgrave <beaub@linux.microsoft.com> wrote:

> Where were you thinking the filtering would occur? In the filter /
> histogram predicates or in user_events directly before buffer commit?

In the predicates. But we only care about the dynamic array ones.

-- Steve
