Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E04C04A6B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 17:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 610CE217F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 17:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfEJRsn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 13:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727569AbfEJRsn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 13:48:43 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44E32217D6;
        Fri, 10 May 2019 17:48:42 +0000 (UTC)
Date:   Fri, 10 May 2019 13:48:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v6 09/26] tools/lib/traceevent: Man page for
 tep_strerror()
Message-ID: <20190510134840.41d3ca77@gandalf.local.home>
In-Reply-To: <20190503091119.23399-10-tstoyanov@vmware.com>
References: <20190503091119.23399-1-tstoyanov@vmware.com>
        <20190503091119.23399-10-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  3 May 2019 12:11:02 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +It as a thread safe wrapper around strerror_r(). The library function has two
> +different behaviors - POSIX and GNU specific. The _tep_strerror()_ API behaves
> +as the POSIX version - the error string is copied in the user supplied buffer.

I updated this to say "API always behaves as the POSIX version", to
remove any ambiguity.

Thanks!

-- Steve
