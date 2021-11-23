Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDF5C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 14:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhKWOwz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 09:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:56134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234126AbhKWOwz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 09:52:55 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D82B360D42;
        Tue, 23 Nov 2021 14:49:46 +0000 (UTC)
Date:   Tue, 23 Nov 2021 09:49:45 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] libtraceevent: Add __rel_loc relative location
 attribute support
Message-ID: <20211123094945.2ed99fe9@gandalf.local.home>
In-Reply-To: <20211123210543.06fed832b5ab3af31a789592@kernel.org>
References: <163757380763.511392.6830680420693577369.stgit@devnote2>
        <163757381684.511392.14804088833440960833.stgit@devnote2>
        <20211122223909.15f6fb50@rorschach.local.home>
        <20211123210543.06fed832b5ab3af31a789592@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 23 Nov 2021 21:05:43 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Oops, good catch! Yes, that's right.
> 
> BTW, are there any tool I can use for testing this library?

Usually the way I test it is by running the libtracefs unit tests and the
trace-cmd test suite (which isn't public yet), but we should add unit tests
for libtraceevent as well.

-- Steve
