Return-Path: <SRS0=jb6J=WC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA70C433FF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 13:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08A3F20C01
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 13:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbfHFN1G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 09:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfHFN1E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 09:27:04 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2888A20C01;
        Tue,  6 Aug 2019 13:27:04 +0000 (UTC)
Date:   Tue, 6 Aug 2019 09:27:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 0/2] [RFC] several build fixes
Message-ID: <20190806092702.31e62a83@gandalf.local.home>
In-Reply-To: <20190806055950.23842-1-sergey.senozhatsky@gmail.com>
References: <20190806055950.23842-1-sergey.senozhatsky@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  6 Aug 2019 14:59:48 +0900
Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:

> Hi,
> 
> 	RFC
> 
> These patches fix v1.1.1 build on my system.
> 

Hi Sergey,

v1.1.1 is 8 years old and no longer supported.

Care to use the latest code? Otherwise, you'll need to simply maintain
these changes locally.

Thanks!

-- Steve


> Sergey Senozhatsky (2):
>   parse-event: rename filter_arg_boolean arg
>   makefile: fix python SyntaxError
> 
>  Makefile       |  2 +-
>  parse-events.h |  2 +-
>  parse-filter.c | 32 ++++++++++++++++----------------
>  3 files changed, 18 insertions(+), 18 deletions(-)
> 

