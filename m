Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01849C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 14:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA63E6120E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 14:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhKEO1I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 10:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232106AbhKEO1I (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 10:27:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3116044F;
        Fri,  5 Nov 2021 14:24:28 +0000 (UTC)
Date:   Fri, 5 Nov 2021 10:24:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 11/12] libtracefs: Remove man page compile artifact
Message-ID: <20211105102426.76a20a4b@gandalf.local.home>
In-Reply-To: <20211105121624.398717-12-tz.stoyanov@gmail.com>
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
        <20211105121624.398717-12-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  5 Nov 2021 14:16:23 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The libtracefs-sqlhist.txt.1 file is generated during the tracefs
> library man pages compilation, it should not be part of the sources.

Are you sure about that?

What creates it?

-- Steve
