Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256A9C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 16:25:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 011252075E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 16:25:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfECQZR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 12:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728370AbfECQZR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 12:25:17 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5328520651;
        Fri,  3 May 2019 16:25:16 +0000 (UTC)
Date:   Fri, 3 May 2019 12:25:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Kacur <jkacur@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH] trace-cmd: python: Apply 2to3 print transformation to
 python files
Message-ID: <20190503122514.0c36fdab@gandalf.local.home>
In-Reply-To: <20190503161541.15773-1-jkacur@redhat.com>
References: <20190503161541.15773-1-jkacur@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  3 May 2019 18:15:41 +0200
John Kacur <jkacur@redhat.com> wrote:

> In preperation for the python plugin to work with python3,
> apply the 2to3 print transformation on the python files.
> 
> In python3 print is a function so needs to be bracketted.
> This is safe to do because the syntax is compatible with python2 as well
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  python/event-viewer.py | 14 +++++++-------
>  python/tracecmd.py     |  6 +++---
>  python/tracecmdgui.py  | 12 ++++++------
>  3 files changed, 16 insertions(+), 16 deletions(-)

Allied. Thanks John!

-- Steve
