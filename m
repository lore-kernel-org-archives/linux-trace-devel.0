Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9AD0C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Nov 2021 15:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbhKWPmG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 10:42:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238474AbhKWPmF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 10:42:05 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 157F860698;
        Tue, 23 Nov 2021 15:38:57 +0000 (UTC)
Date:   Tue, 23 Nov 2021 10:38:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>, kernel <kernel@axis.com>
Subject: Re: [PATCH] trace-cmd report: Avoid crash on unknown event
Message-ID: <20211123103855.7deca5b4@gandalf.local.home>
In-Reply-To: <20211123085514.GA12234@axis.com>
References: <20211119112420.4826-1-vincent.whitchurch@axis.com>
        <20211119094434.718922fa@gandalf.local.home>
        <20211123085514.GA12234@axis.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 23 Nov 2021 09:55:14 +0100
Vincent Whitchurch <vincent.whitchurch@axis.com> wrote:

> Looks good to me.

Want to submit a v2 and add:

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

?

-- Steve
